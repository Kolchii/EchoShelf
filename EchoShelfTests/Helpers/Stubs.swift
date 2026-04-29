//
//  Stubs.swift
//  EchoShelfTests
//
//  Convenient factory helpers so tests don't need to repeat boilerplate.
//
import Foundation
@testable import EchoShelf

// MARK: - Audiobook

extension Audiobook {
    static func stub(
        id: Int = 1,
        title: String = "Test Book",
        description: String? = "A great audiobook",
        authors: [Author]? = [Author(firstName: "Jane", lastName: "Doe")]
    ) -> Audiobook {
        Audiobook(
            id: FlexibleInt(from: id),
            title: title,
            description: description,
            urlLibrivox: "https://librivox.org/test",
            urlRss: nil,
            urlZipFile: nil,
            numSections: FlexibleInt(from: 10),
            authors: authors,
            coverURL: nil
        )
    }

    static func stubs(count: Int, startId: Int = 1) -> [Audiobook] {
        (startId ..< startId + count).map { stub(id: $0, title: "Book \($0)") }
    }
}

// MARK: - Author

extension Author {
    static func stub(first: String = "John", last: String = "Doe") -> Author {
        Author(firstName: first, lastName: last)
    }
}

// MARK: - Ebook

extension Ebook {
    static func stub(id: String = "1", title: String = "Test Ebook") -> Ebook {
        Ebook(
            id: id,
            title: title,
            authorName: "Test Author",
            coverURL: nil,
            pdfURL: URL(string: "https://example.com/test.pdf"),
            subject: "fiction",
            subjects: ["fiction"],
            downloadCount: 100
        )
    }

    static func stubs(count: Int, startId: Int = 1) -> [Ebook] {
        (startId ..< startId + count).map { stub(id: "\($0)", title: "Ebook \($0)") }
    }
}

// MARK: - TestError

struct TestError: Error, LocalizedError {
    let msg: String
    var errorDescription: String? { msg }
    init(_ msg: String = "Test error") { self.msg = msg }
}
