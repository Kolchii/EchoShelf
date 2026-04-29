//
//  AllBooksViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class AllBooksViewModelTests: XCTestCase {

    private var sut: AllBooksViewModel!
    private var mockService: MockAudiobookService!

    override func setUp() {
        super.setUp()
        mockService = MockAudiobookService()
        sut = AllBooksViewModel(type: .trending, service: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_booksEmpty() {
        XCTAssertTrue(sut.books.isEmpty)
    }

    func test_initialState_notLoading() {
        XCTAssertFalse(sut.isLoading)
    }

    func test_initialState_hasMore() {
        XCTAssertTrue(sut.hasMore)
    }

    func test_initialState_typeTrending() {
        XCTAssertEqual(sut.type, .trending)
    }

    // MARK: - Fetch

    func test_fetchBooks_success_appendsBooks() {
        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 5))

        sut.fetchBooks()

        XCTAssertEqual(sut.books.count, 5)
    }

    func test_fetchBooks_success_callsOnDataUpdated() {
        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 3))
        var updateCount = 0
        sut.onDataUpdated = { updateCount += 1 }

        sut.fetchBooks()

        XCTAssertEqual(updateCount, 1)
    }

    func test_fetchBooks_emptyResult_setsHasMoreFalse() {
        mockService.fetchAudiobooksResult = .success([])

        sut.fetchBooks()

        XCTAssertFalse(sut.hasMore)
    }

    func test_fetchBooks_failure_firesError() {
        mockService.fetchAudiobooksResult = .failure(.requestFailed)
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.fetchBooks()

        XCTAssertNotNil(errorMsg)
        XCTAssertEqual(mockService.fetchAudiobooksCallCount, 1)
    }

    func test_fetchBooks_partialPage_setsHasMoreFalse() {
        // pageSize is 20, fewer than 20 books means no more pages
        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 10))

        sut.fetchBooks()

        XCTAssertFalse(sut.hasMore)
    }

    func test_fetchBooks_fullPage_hasMoreStaysTrue() {
        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 20))

        sut.fetchBooks()

        XCTAssertTrue(sut.hasMore)
    }

    // MARK: - Pagination

    func test_fetchBooks_secondPage_appendsToExisting() {
        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 20))
        sut.fetchBooks()

        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 20, startId: 21))
        sut.fetchBooks()

        XCTAssertEqual(sut.books.count, 40)
        XCTAssertEqual(mockService.fetchAudiobooksCallCount, 2)
    }

    func test_fetchBooks_whenLoading_doesNotFetchAgain() {
        // Simulate loading state by not providing result yet (synchronous mock always resolves,
        // so we check the guard by calling twice in rapid succession after hasMore = false)
        mockService.fetchAudiobooksResult = .success([])
        sut.fetchBooks() // sets hasMore = false

        sut.fetchBooks() // should be blocked by hasMore guard

        XCTAssertEqual(mockService.fetchAudiobooksCallCount, 1)
    }

    // MARK: - Reset

    func test_reset_clearsBooks() {
        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 10))
        sut.fetchBooks()

        sut.reset()

        XCTAssertTrue(sut.books.isEmpty)
    }

    func test_reset_resetsHasMore() {
        mockService.fetchAudiobooksResult = .success([])
        sut.fetchBooks()
        XCTAssertFalse(sut.hasMore)

        sut.reset()

        XCTAssertTrue(sut.hasMore)
    }

    func test_reset_setsNotLoading() {
        sut.reset()
        XCTAssertFalse(sut.isLoading)
    }

    func test_reset_thenFetch_startsFromPageOne() {
        mockService.fetchAudiobooksResult = .success(Audiobook.stubs(count: 20))
        sut.fetchBooks()
        sut.reset()
        sut.fetchBooks()

        XCTAssertEqual(mockService.fetchAudiobooksCallCount, 2)
        XCTAssertEqual(sut.books.count, 20)
    }

    // MARK: - AllBooksType

    func test_typeRecommended_correctTitle() {
        let vm = AllBooksViewModel(type: .recommended, service: mockService)
        XCTAssertEqual(vm.type.title, "Recommended For You")
    }

    func test_typeTrending_correctTitle() {
        XCTAssertEqual(sut.type.title, "Trending Today")
    }
}
