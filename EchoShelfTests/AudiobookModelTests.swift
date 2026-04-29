//
//  AudiobookModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class AudiobookModelTests: XCTestCase {

    // MARK: - authorName

    func test_authorName_withFirstAndLast_returnsFullName() {
        let book = Audiobook.stub(authors: [Author(firstName: "Jane", lastName: "Austen")])
        XCTAssertEqual(book.authorName, "Jane Austen")
    }

    func test_authorName_nilFirstName_returnsLastOnly() {
        let book = Audiobook.stub(authors: [Author(firstName: nil, lastName: "Dickens")])
        XCTAssertEqual(book.authorName, "Dickens")
    }

    func test_authorName_nilLastName_returnsFirstOnly() {
        let book = Audiobook.stub(authors: [Author(firstName: "Leo", lastName: nil)])
        XCTAssertEqual(book.authorName, "Leo")
    }

    func test_authorName_nilAuthors_returnsUnknown() {
        let book = Audiobook.stub(authors: nil)
        XCTAssertEqual(book.authorName, "Unknown Author")
    }

    func test_authorName_emptyAuthors_returnsUnknown() {
        let book = Audiobook.stub(authors: [])
        XCTAssertEqual(book.authorName, "Unknown Author")
    }

    func test_authorName_bothNilNames_returnsUnknown() {
        let book = Audiobook.stub(authors: [Author(firstName: nil, lastName: nil)])
        XCTAssertEqual(book.authorName, "Unknown Author")
    }

    func test_authorName_usesFirstAuthorOnly() {
        let book = Audiobook.stub(authors: [
            Author(firstName: "First", lastName: "Author"),
            Author(firstName: "Second", lastName: "Author")
        ])
        XCTAssertEqual(book.authorName, "First Author")
    }

    // MARK: - archiveIdentifier

    func test_archiveIdentifier_validArchiveURL_returnsIdentifier() {
        var book = Audiobook.stub()
        book = Audiobook(
            id: FlexibleInt(from: 1),
            title: "Test",
            description: nil,
            urlLibrivox: nil,
            urlRss: nil,
            urlZipFile: "https://archive.org/download/test_identifier_1234/test.zip",
            numSections: nil,
            authors: nil,
            coverURL: nil
        )
        XCTAssertEqual(book.archiveIdentifier, "test_identifier_1234")
    }

    func test_archiveIdentifier_nilZipFile_returnsNil() {
        let book = Audiobook(
            id: FlexibleInt(from: 1),
            title: "Test",
            description: nil,
            urlLibrivox: nil,
            urlRss: nil,
            urlZipFile: nil,
            numSections: nil,
            authors: nil,
            coverURL: nil
        )
        XCTAssertNil(book.archiveIdentifier)
    }

    // MARK: - Codable round-trip

    func test_audiobook_encodeDecode_preservesTitle() throws {
        let original = Audiobook.stub(id: 99, title: "Moby Dick")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Audiobook.self, from: data)
        XCTAssertEqual(decoded.title, "Moby Dick")
        XCTAssertEqual(decoded.id.value, 99)
    }

    func test_audiobook_encodeDecode_preservesAuthors() throws {
        let original = Audiobook.stub(authors: [Author(firstName: "Herman", lastName: "Melville")])
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Audiobook.self, from: data)
        XCTAssertEqual(decoded.authors?.first?.firstName, "Herman")
        XCTAssertEqual(decoded.authors?.first?.lastName, "Melville")
    }

    // MARK: - Author model

    func test_author_stub_hasCorrectNames() {
        let author = Author.stub(first: "Mark", last: "Twain")
        XCTAssertEqual(author.firstName, "Mark")
        XCTAssertEqual(author.lastName, "Twain")
    }
}
