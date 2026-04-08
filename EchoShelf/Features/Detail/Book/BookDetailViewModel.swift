//
//  BookDetailViewModel.swift
//  EchoShelf
//
//  Created by Ibrahim Kolchi on 27.02.26.
//
import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

final class BookDetailViewModel {

    private let service: AudiobookServiceProtocol
    private let ai = GeminiService()
    private let favoritesViewModel = FavoritesViewModel()

    private(set) var book: Audiobook
    private(set) var aiSummary: [String] = []
    private(set) var state: ViewState<Void> = .idle {
        didSet { onStateChanged?(state) }
    }

    var onStateChanged: ((ViewState<Void>) -> Void)?
    var onAIUpdated: (() -> Void)?

    init(book: Audiobook, service: AudiobookServiceProtocol = AudiobookService()) {
        self.book = book
        self.service = service
    }

    func fetchDetail() {
        state = .loading
        service.fetchAudiobookDetail(id: book.id.value) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedBook):
                    self.book = updatedBook
                    self.state = .success(())
                    self.fetchAISummary()
                case .failure(let error):
                    self.state = .failure(error)
                    self.aiSummary = self.fallbackSummary()
                    self.onAIUpdated?()
                }
            }
        }
    }

    func toggleFavorite(bookType: BookDetailType) {
        switch bookType {
        case .audiobook:
            favoritesViewModel.toggleBook(book)
        case .ebook(let ebook):
            if ebook.isKids {
                favoritesViewModel.toggleKidsBook(ebook)
            } else {
                favoritesViewModel.toggleEbook(ebook)
            }
        }
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }

    func isFavorited(bookType: BookDetailType) -> Bool {
        switch bookType {
        case .audiobook:
            return favoritesViewModel.isBookFavorited(book)
        case .ebook(let ebook):
            return ebook.isKids
                ? favoritesViewModel.isKidsBookFavorited(ebook)
                : favoritesViewModel.isEbookFavorited(ebook)
        }
    }
}

private extension BookDetailViewModel {

    func fetchAISummary() {
        let title = book.title
        let author = book.authorName
        let prompt = """
        Give me exactly 3 short interesting facts about the audiobook "\(title)" by \(author).
        Each fact must be a single sentence.
        Return only the 3 facts as a numbered list like:
        1. Fact one.
        2. Fact two.
        3. Fact three.
        """
        Task {
            let response = await ai.ask(prompt: prompt)
            let lines = response?
                .components(separatedBy: "\n")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
                .map { $0.replacingOccurrences(of: #"^\d+[\.\)]\s*"#, with: "", options: .regularExpression) }
                .filter { !$0.isEmpty } ?? []

            await MainActor.run {
                self.aiSummary = lines.isEmpty ? self.fallbackSummary() : Array(lines.prefix(3))
                self.onAIUpdated?()
            }
        }
    }

    func fallbackSummary() -> [String] {
        let title = book.title
        let author = book.authorName
        return [
            "A compelling story by \(author) that draws readers into a unique world.",
            "\"\(title)\" explores themes of identity, purpose, and the human condition.",
            "Narrated with emotional depth, capturing every moment of the journey."
        ]
    }
}

final class EbookDetailViewModel {

    let ebook: Ebook
    private(set) var aiSummary: [String] = []
    private(set) var description: String = ""

    var onDataUpdated: (() -> Void)?

    init(ebook: Ebook) {
        self.ebook = ebook
        buildContent()
    }

    private func buildContent() {
        description = buildDescription()
        aiSummary = buildAISummary()
        onDataUpdated?()
    }

    private func buildDescription() -> String {
        var parts: [String] = []
        if let subject = ebook.subject {
            parts.append("Genre: \(subject.capitalized)")
        }
        parts.append("\"\(ebook.title)\" is a classic work by \(ebook.authorName), available as a free ebook from Project Gutenberg.")
        if ebook.downloadCount > 0 {
            parts.append("This book has been downloaded \(formatDownloadCount(ebook.downloadCount)) times, making it one of the most popular titles in the public domain.")
        }
        return parts.joined(separator: "\n\n")
    }

    private func buildAISummary() -> [String] {
        let title = ebook.title
        let author = ebook.authorName
        var points = [
            "Written by \(author), \"\(title)\" is a timeless classic that has captivated readers for generations.",
            "Freely available in the public domain — read it anytime, anywhere within the app."
        ]
        if let subject = ebook.subject {
            points.append("Categorized under \(subject.capitalized) — perfect for fans of the genre.")
        } else {
            points.append("A landmark work of literature that continues to inspire readers worldwide.")
        }
        return points
    }

    private func formatDownloadCount(_ count: Int) -> String {
        switch count {
        case 0..<1_000:  return "\(count)"
        case 0..<10_000: return String(format: "%.1fK", Double(count) / 1_000)
        default:         return String(format: "%.0fK", Double(count) / 1_000)
        }
    }
}
