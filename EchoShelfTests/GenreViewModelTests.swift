//
//  GenreViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class GenreViewModelTests: XCTestCase {

    private var sut: GenreViewModel!
    private var mockAudiobook: MockAudiobookService!
    private var mockEbook: MockEbookService!

    override func setUp() {
        super.setUp()
        mockAudiobook = MockAudiobookService()
        mockEbook = MockEbookService()
        sut = GenreViewModel(genre: "fantasy",
                             audiobookService: mockAudiobook,
                             ebookService: mockEbook)
    }

    override func tearDown() {
        sut = nil
        mockAudiobook = nil
        mockEbook = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_audiobooksEmpty() {
        XCTAssertTrue(sut.audiobooks.isEmpty)
    }

    func test_initialState_ebooksEmpty() {
        XCTAssertTrue(sut.ebooks.isEmpty)
    }

    func test_initialState_genreCorrect() {
        XCTAssertEqual(sut.genre, "fantasy")
    }

    func test_initialState_hasMore() {
        XCTAssertTrue(sut.hasMore(for: .audiobooks))
        XCTAssertTrue(sut.hasMore(for: .books))
    }

    func test_initialState_notLoading() {
        XCTAssertFalse(sut.isLoading(for: .audiobooks))
        XCTAssertFalse(sut.isLoading(for: .books))
    }

    // MARK: - fetchAudiobooks

    func test_fetchAudiobooks_success_appendsBooks() {
        mockAudiobook.fetchByGenreResult = .success(Audiobook.stubs(count: 10))

        sut.fetchAudiobooks()

        XCTAssertEqual(sut.audiobooks.count, 10)
    }

    func test_fetchAudiobooks_emptyResult_setsHasMoreFalse() {
        mockAudiobook.fetchByGenreResult = .success([])

        sut.fetchAudiobooks()

        XCTAssertFalse(sut.hasMore(for: .audiobooks))
    }

    func test_fetchAudiobooks_usesCorrectGenre() {
        mockAudiobook.fetchByGenreResult = .success([])

        sut.fetchAudiobooks()

        XCTAssertEqual(mockAudiobook.lastGenreSubject, "fantasy")
    }

    func test_fetchAudiobooks_failure_firesError() {
        mockAudiobook.fetchByGenreResult = .failure(.requestFailed)
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.fetchAudiobooks()

        XCTAssertEqual(errorMsg, "Failed to load audiobooks")
    }

    func test_fetchAudiobooks_callsOnDataUpdated() {
        mockAudiobook.fetchByGenreResult = .success(Audiobook.stubs(count: 5))
        var updateCount = 0
        sut.onDataUpdated = { updateCount += 1 }

        sut.fetchAudiobooks()

        XCTAssertEqual(updateCount, 1)
    }

    // MARK: - fetchEbooks

    func test_fetchEbooks_success_appendsEbooks() {
        mockEbook.fetchBySubjectResult = .success(Ebook.stubs(count: 8))

        sut.fetchEbooks()

        XCTAssertEqual(sut.ebooks.count, 8)
    }

    func test_fetchEbooks_emptyResult_setsHasMoreFalse() {
        mockEbook.fetchBySubjectResult = .success([])

        sut.fetchEbooks()

        XCTAssertFalse(sut.hasMore(for: .books))
    }

    func test_fetchEbooks_failure_firesError() {
        mockEbook.fetchBySubjectResult = .failure(.requestFailed)
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.fetchEbooks()

        XCTAssertEqual(errorMsg, "Failed to load books")
    }

    // MARK: - items(for:)

    func test_items_audiobooks_returnsCorrectCount() {
        mockAudiobook.fetchByGenreResult = .success(Audiobook.stubs(count: 6))
        sut.fetchAudiobooks()
        XCTAssertEqual(sut.items(for: .audiobooks), 6)
    }

    func test_items_books_returnsCorrectCount() {
        mockEbook.fetchBySubjectResult = .success(Ebook.stubs(count: 4))
        sut.fetchEbooks()
        XCTAssertEqual(sut.items(for: .books), 4)
    }

    // MARK: - shouldFetchNextPage

    func test_shouldFetchNextPage_belowThreshold_returnsFalse() {
        mockAudiobook.fetchByGenreResult = .success(Audiobook.stubs(count: 10))
        sut.fetchAudiobooks()

        let result = sut.shouldFetchNextPage(for: .audiobooks, at: 0)

        XCTAssertFalse(result)
    }

    func test_shouldFetchNextPage_atThreshold_returnsTrue() {
        mockAudiobook.fetchByGenreResult = .success(Audiobook.stubs(count: 10))
        sut.fetchAudiobooks()

        // threshold = count - 4 = 6
        let result = sut.shouldFetchNextPage(for: .audiobooks, at: 7)

        XCTAssertTrue(result)
    }

    func test_shouldFetchNextPage_whenNoMore_returnsFalse() {
        mockAudiobook.fetchByGenreResult = .success([]) // hasMore = false after empty result
        sut.fetchAudiobooks()

        let result = sut.shouldFetchNextPage(for: .audiobooks, at: 0)

        XCTAssertFalse(result)
    }

    // MARK: - reset via fetchAudiobooks(reset:)

    func test_fetchAudiobooks_reset_clearsExisting() {
        mockAudiobook.fetchByGenreResult = .success(Audiobook.stubs(count: 5))
        sut.fetchAudiobooks()
        XCTAssertEqual(sut.audiobooks.count, 5)

        mockAudiobook.fetchByGenreResult = .success(Audiobook.stubs(count: 3))
        sut.fetchAudiobooks(reset: true)

        XCTAssertEqual(sut.audiobooks.count, 3)
    }
}
