//
//  ViewStateTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class ViewStateTests: XCTestCase {

    func test_idle_isIdle() {
        let state: ViewState<[Audiobook]> = .idle
        if case .idle = state { } else { XCTFail("Expected .idle") }
    }

    func test_loading_isLoading() {
        let state: ViewState<[Audiobook]> = .loading
        if case .loading = state { } else { XCTFail("Expected .loading") }
    }

    func test_success_holdsValue() {
        let books = Audiobook.stubs(count: 3)
        let state: ViewState<[Audiobook]> = .success(books)
        if case .success(let v) = state {
            XCTAssertEqual(v.count, 3)
        } else {
            XCTFail("Expected .success")
        }
    }

    func test_failure_holdsError() {
        let state: ViewState<[Audiobook]> = .failure(.requestFailed)
        if case .failure(let e) = state {
            XCTAssertEqual(e, .requestFailed)
        } else {
            XCTFail("Expected .failure")
        }
    }
}
