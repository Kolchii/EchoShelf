//
//  FavoritesViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class FavoritesViewModelTests: XCTestCase {

    private var sut: FavoritesViewModel!

    // Use a dedicated UserDefaults suite to avoid polluting real app storage
    private let defaults = UserDefaults(suiteName: "com.echoshelf.test.favorites")!

    override func setUp() {
        super.setUp()
        clearTestDefaults()
        sut = FavoritesViewModel()
    }

    override func tearDown() {
        clearTestDefaults()
        sut = nil
        super.tearDown()
    }

    private func clearTestDefaults() {
        ["favorite_books", "favorite_ebooks", "favorite_kids_books",
         "favorite_authors", "favorite_genres"].forEach {
            UserDefaults.standard.removeObject(forKey: $0)
        }
    }

    // MARK: - Toggle Audiobook

    func test_toggleBook_addsBookWhenNotPresent() {
        let book = Audiobook.stub(id: 42)

        sut.toggleBook(book)

        XCTAssertTrue(sut.isBookFavorited(book))
    }

    func test_toggleBook_removesBookWhenAlreadyPresent() {
        let book = Audiobook.stub(id: 42)
        sut.toggleBook(book)

        sut.toggleBook(book)

        XCTAssertFalse(sut.isBookFavorited(book))
    }

    func test_toggleBook_insertsAtFront() {
        let book1 = Audiobook.stub(id: 1, title: "First")
        let book2 = Audiobook.stub(id: 2, title: "Second")
        sut.toggleBook(book1)
        sut.toggleBook(book2)

        XCTAssertEqual(sut.favoriteBooks.first?.title, "Second")
    }

    func test_toggleBook_callsOnDataUpdated() {
        var updateCount = 0
        sut.onDataUpdated = { updateCount += 1 }

        sut.toggleBook(Audiobook.stub())

        XCTAssertEqual(updateCount, 1)
    }

    // MARK: - Toggle Ebook

    func test_toggleEbook_addsEbookWhenNotPresent() {
        let ebook = Ebook.stub(id: "100")

        sut.toggleEbook(ebook)

        XCTAssertTrue(sut.isEbookFavorited(ebook))
    }

    func test_toggleEbook_removesEbookWhenPresent() {
        let ebook = Ebook.stub(id: "100")
        sut.toggleEbook(ebook)

        sut.toggleEbook(ebook)

        XCTAssertFalse(sut.isEbookFavorited(ebook))
    }

    func test_toggleEbook_differentIds_bothPresent() {
        let e1 = Ebook.stub(id: "1")
        let e2 = Ebook.stub(id: "2")

        sut.toggleEbook(e1)
        sut.toggleEbook(e2)

        XCTAssertTrue(sut.isEbookFavorited(e1))
        XCTAssertTrue(sut.isEbookFavorited(e2))
    }

    // MARK: - Toggle Kids Book

    func test_toggleKidsBook_addsWhenNotPresent() {
        let kids = Ebook.stub(id: "k1", title: "Kids Story")

        sut.toggleKidsBook(kids)

        XCTAssertTrue(sut.isKidsBookFavorited(kids))
    }

    func test_toggleKidsBook_removesWhenPresent() {
        let kids = Ebook.stub(id: "k1")
        sut.toggleKidsBook(kids)

        sut.toggleKidsBook(kids)

        XCTAssertFalse(sut.isKidsBookFavorited(kids))
    }

    // MARK: - Toggle Author

    func test_toggleAuthor_addsWhenNotPresent() {
        let author = Author.stub(first: "Leo", last: "Tolstoy")

        sut.toggleAuthor(author)

        XCTAssertTrue(sut.isAuthorFavorited(author))
    }

    func test_toggleAuthor_removesWhenPresent() {
        let author = Author.stub(first: "Leo", last: "Tolstoy")
        sut.toggleAuthor(author)

        sut.toggleAuthor(author)

        XCTAssertFalse(sut.isAuthorFavorited(author))
    }

    func test_toggleAuthor_matchesByName_notByReference() {
        let a1 = Author.stub(first: "Mark", last: "Twain")
        let a2 = Author.stub(first: "Mark", last: "Twain") // different instance, same name

        sut.toggleAuthor(a1)

        XCTAssertTrue(sut.isAuthorFavorited(a2))
    }

    // MARK: - Toggle Genre

    func test_toggleGenre_addsWhenNotPresent() {
        sut.toggleGenre("Fantasy")
        XCTAssertTrue(sut.isGenreFavorited("Fantasy"))
    }

    func test_toggleGenre_removesWhenPresent() {
        sut.toggleGenre("Fantasy")
        sut.toggleGenre("Fantasy")
        XCTAssertFalse(sut.isGenreFavorited("Fantasy"))
    }

    func test_toggleGenre_multipleGenres() {
        sut.toggleGenre("Fantasy")
        sut.toggleGenre("Mystery")
        sut.toggleGenre("Sci-Fi")

        XCTAssertEqual(sut.favoriteGenres.count, 3)
    }

    func test_toggleGenre_insertsAtFront() {
        sut.toggleGenre("Fantasy")
        sut.toggleGenre("Mystery")

        XCTAssertEqual(sut.favoriteGenres.first, "Mystery")
    }

    // MARK: - items(for:) & isEmpty(for:)

    func test_items_emptySection_returnsZero() {
        XCTAssertEqual(sut.items(for: .audiobooks), 0)
        XCTAssertEqual(sut.items(for: .books), 0)
        XCTAssertEqual(sut.items(for: .kids), 0)
        XCTAssertEqual(sut.items(for: .authors), 0)
        XCTAssertEqual(sut.items(for: .genres), 0)
    }

    func test_items_afterAdding_returnsCorrectCount() {
        sut.toggleBook(Audiobook.stub(id: 1))
        sut.toggleBook(Audiobook.stub(id: 2))
        sut.toggleEbook(Ebook.stub(id: "1"))
        sut.toggleGenre("Fantasy")
        sut.toggleGenre("Mystery")
        sut.toggleGenre("Sci-Fi")

        XCTAssertEqual(sut.items(for: .audiobooks), 2)
        XCTAssertEqual(sut.items(for: .books), 1)
        XCTAssertEqual(sut.items(for: .genres), 3)
    }

    func test_isEmpty_true_whenNoItems() {
        XCTAssertTrue(sut.isEmpty(for: .audiobooks))
    }

    func test_isEmpty_false_afterAdding() {
        sut.toggleBook(Audiobook.stub())
        XCTAssertFalse(sut.isEmpty(for: .audiobooks))
    }
}

// MARK: - FavoriteSectionTests

final class FavoriteSectionTests: XCTestCase {

    func test_allCases_count() {
        XCTAssertEqual(FavoriteSection.allCases.count, 5)
    }

    func test_titles_areCorrect() {
        XCTAssertEqual(FavoriteSection.books.title, "Books")
        XCTAssertEqual(FavoriteSection.audiobooks.title, "Audiobooks")
        XCTAssertEqual(FavoriteSection.kids.title, "Kids")
        XCTAssertEqual(FavoriteSection.authors.title, "Authors")
        XCTAssertEqual(FavoriteSection.genres.title, "Genres")
    }

    func test_icons_areSystemSymbols() {
        XCTAssertFalse(FavoriteSection.books.icon.isEmpty)
        XCTAssertFalse(FavoriteSection.audiobooks.icon.isEmpty)
        XCTAssertFalse(FavoriteSection.kids.icon.isEmpty)
        XCTAssertFalse(FavoriteSection.authors.icon.isEmpty)
        XCTAssertFalse(FavoriteSection.genres.icon.isEmpty)
    }

    func test_rawValues_sequential() {
        XCTAssertEqual(FavoriteSection.books.rawValue, 0)
        XCTAssertEqual(FavoriteSection.audiobooks.rawValue, 1)
        XCTAssertEqual(FavoriteSection.kids.rawValue, 2)
        XCTAssertEqual(FavoriteSection.authors.rawValue, 3)
        XCTAssertEqual(FavoriteSection.genres.rawValue, 4)
    }
}
