//
//  AuthorDetailViewModel.swift
//  EchoShelf
//
import Foundation

final class AuthorDetailViewModel {

    private let service: AuthorService
    private let ebookService: EbookServiceProtocol
    private(set) var author: Author
    private(set) var authorDetail: AuthorDetail?
    private(set) var audiobooks: [Audiobook] = []
    private(set) var ebooks: [Ebook] = []

    private var audiobookPage = 0
    private var ebookPage = 0
    private var isLoadingAudiobooks = false
    private var isLoadingEbooks = false
    var hasMoreAudiobooks = true
    var hasMoreEbooks = true

    private(set) var state: ViewState<Void> = .idle {
        didSet { onStateChanged?(state) }
    }

    var onStateChanged: ((ViewState<Void>) -> Void)?
    var onAudiobooksUpdated: (() -> Void)?
    var onEbooksUpdated: (() -> Void)?

    var books: [Audiobook] { audiobooks }

    init(author: Author, service: AuthorService = .shared, ebookService: EbookServiceProtocol = EbookService.shared) {
        self.author = author
        self.service = service
        self.ebookService = ebookService
    }

    func fetchData() {
        state = .loading
        let group = DispatchGroup()

        group.enter()
        service.fetchAuthorDetail(firstName: author.firstName, lastName: author.lastName) { [weak self] detail in
            self?.authorDetail = detail
            group.leave()
        }

        group.enter()
        fetchNextAudiobooks {
            group.leave()
        }

        group.enter()
        fetchNextEbooks {
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.state = .success(())
        }
    }

    func fetchNextAudiobooks(completion: (() -> Void)? = nil) {
        guard !isLoadingAudiobooks, hasMoreAudiobooks else { completion?(); return }
        isLoadingAudiobooks = true

        var params: [String: Any] = ["format": "json", "limit": 20, "offset": audiobookPage * 20]
        if let first = author.firstName { params["first_name"] = first }
        if let last = author.lastName  { params["last_name"] = last }

        service.fetchAuthorBooks(firstName: author.firstName, lastName: author.lastName) { [weak self] books in
            guard let self else { completion?(); return }
            DispatchQueue.main.async {
                self.isLoadingAudiobooks = false
                if books.isEmpty {
                    self.hasMoreAudiobooks = false
                } else {
                    self.audiobooks.append(contentsOf: books)
                    self.audiobookPage += 1
                    if books.count < 20 { self.hasMoreAudiobooks = false }
                }
                self.onAudiobooksUpdated?()
                completion?()
            }
        }
    }

    func fetchNextEbooks(completion: (() -> Void)? = nil) {
        guard !isLoadingEbooks, hasMoreEbooks else { completion?(); return }
        isLoadingEbooks = true

        ebookService.fetchEbooksBySubject(subject: fullName, page: ebookPage) { [weak self] result in
            guard let self else { completion?(); return }
            DispatchQueue.main.async {
                self.isLoadingEbooks = false
                let newBooks = (try? result.get()) ?? []
                if newBooks.isEmpty {
                    self.hasMoreEbooks = false
                } else {
                    self.ebooks.append(contentsOf: newBooks)
                    self.ebookPage += 1
                    if newBooks.count < 20 { self.hasMoreEbooks = false }
                }
                self.onEbooksUpdated?()
                completion?()
            }
        }
    }

    var fullName: String {
        let full = "\(author.firstName ?? "") \(author.lastName ?? "")".trimmingCharacters(in: .whitespaces)
        return full.isEmpty ? "Unknown Author" : full
    }
}
