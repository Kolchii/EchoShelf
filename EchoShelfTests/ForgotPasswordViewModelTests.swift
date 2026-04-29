//
//  ForgotPasswordViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class ForgotPasswordViewModelTests: XCTestCase {

    private var sut: ForgotPasswordViewModel!
    private var mockAuth: MockAuthManager!

    override func setUp() {
        super.setUp()
        mockAuth = MockAuthManager()
        sut = ForgotPasswordViewModel(authManager: mockAuth)
    }

    override func tearDown() {
        sut = nil
        mockAuth = nil
        super.tearDown()
    }

    // MARK: - Validation

    func test_reset_nilEmail_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.resetPassword(email: nil)

        XCTAssertEqual(msg, "Email is required.")
        XCTAssertEqual(mockAuth.resetPasswordCallCount, 0)
    }

    func test_reset_emptyEmail_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.resetPassword(email: "")

        XCTAssertEqual(msg, "Email is required.")
        XCTAssertEqual(mockAuth.resetPasswordCallCount, 0)
    }

    func test_reset_invalidEmail_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.resetPassword(email: "badformat")

        XCTAssertEqual(msg, "Please enter a valid email address.")
        XCTAssertEqual(mockAuth.resetPasswordCallCount, 0)
    }

    func test_reset_emailWithoutTLD_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.resetPassword(email: "user@domain")

        XCTAssertEqual(msg, "Please enter a valid email address.")
    }

    // MARK: - Success Path

    func test_reset_validEmail_callsAuthManager() {
        mockAuth.resetPasswordResult = .success(())
        var successCalled = false
        sut.onResetSuccess = { successCalled = true }

        sut.resetPassword(email: "valid@example.com")

        XCTAssertTrue(successCalled)
        XCTAssertEqual(mockAuth.resetPasswordCallCount, 1)
        XCTAssertEqual(mockAuth.lastResetEmail, "valid@example.com")
    }

    func test_reset_success_loaderToggled() {
        mockAuth.resetPasswordResult = .success(())
        var states: [Bool] = []
        sut.onLoadingChanged = { states.append($0) }

        sut.resetPassword(email: "valid@example.com")

        XCTAssertEqual(states, [true, false])
    }

    // MARK: - Failure Path

    func test_reset_failure_firesError() {
        mockAuth.resetPasswordResult = .failure(TestError("No user found"))
        var msg: String?
        sut.onError = { msg = $0 }

        sut.resetPassword(email: "valid@example.com")

        XCTAssertEqual(msg, "No user found")
    }

    func test_reset_failure_loaderStops() {
        mockAuth.resetPasswordResult = .failure(TestError())
        var states: [Bool] = []
        sut.onLoadingChanged = { states.append($0) }

        sut.resetPassword(email: "valid@example.com")

        XCTAssertEqual(states, [true, false])
    }
}
