//
//  SignInViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class SignInViewModelTests: XCTestCase {

    private var sut: SignInViewModel!
    private var mockAuth: MockAuthManager!

    override func setUp() {
        super.setUp()
        mockAuth = MockAuthManager()
        sut = SignInViewModel(authManager: mockAuth)
    }

    override func tearDown() {
        sut = nil
        mockAuth = nil
        super.tearDown()
    }

    // MARK: - Email Validation

    func test_login_nilEmail_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: nil, password: "password123")

        XCTAssertEqual(errorMsg, "Email is required.")
        XCTAssertEqual(mockAuth.loginCallCount, 0)
    }

    func test_login_emptyEmail_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "", password: "password123")

        XCTAssertEqual(errorMsg, "Email is required.")
        XCTAssertEqual(mockAuth.loginCallCount, 0)
    }

    func test_login_invalidEmailFormat_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "notanemail", password: "password123")

        XCTAssertEqual(errorMsg, "Please enter a valid email address.")
        XCTAssertEqual(mockAuth.loginCallCount, 0)
    }

    func test_login_emailMissingDomain_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "user@", password: "password123")

        XCTAssertEqual(errorMsg, "Please enter a valid email address.")
    }

    // MARK: - Password Validation

    func test_login_nilPassword_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "user@example.com", password: nil)

        XCTAssertEqual(errorMsg, "Password is required.")
        XCTAssertEqual(mockAuth.loginCallCount, 0)
    }

    func test_login_emptyPassword_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "user@example.com", password: "")

        XCTAssertEqual(errorMsg, "Password is required.")
        XCTAssertEqual(mockAuth.loginCallCount, 0)
    }

    func test_login_shortPassword_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "user@example.com", password: "abc")

        XCTAssertEqual(errorMsg, "Password must be at least 6 characters.")
        XCTAssertEqual(mockAuth.loginCallCount, 0)
    }

    func test_login_passwordExactly5Chars_firesError() {
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "user@example.com", password: "12345")

        XCTAssertEqual(errorMsg, "Password must be at least 6 characters.")
    }

    // MARK: - Success Path

    func test_login_validCredentials_callsAuthManager() {
        mockAuth.loginResult = .success(())
        var successCalled = false
        sut.onLoginSuccess = { successCalled = true }

        sut.login(email: "user@example.com", password: "password123")

        XCTAssertEqual(mockAuth.loginCallCount, 1)
        XCTAssertEqual(mockAuth.lastLoginEmail, "user@example.com")
        XCTAssertEqual(mockAuth.lastLoginPassword, "password123")
        XCTAssertTrue(successCalled)
    }

    func test_login_validCredentials_loaderToggled() {
        mockAuth.loginResult = .success(())
        var loadingStates: [Bool] = []
        sut.onLoadingChanged = { loadingStates.append($0) }

        sut.login(email: "user@example.com", password: "password123")

        XCTAssertEqual(loadingStates, [true, false])
    }

    // MARK: - Failure Path

    func test_login_authFailure_firesError() {
        mockAuth.loginResult = .failure(TestError("Invalid credentials"))
        var errorMsg: String?
        sut.onError = { errorMsg = $0 }

        sut.login(email: "user@example.com", password: "password123")

        XCTAssertEqual(errorMsg, "Invalid credentials")
        XCTAssertEqual(mockAuth.loginCallCount, 1)
    }

    func test_login_authFailure_loaderStopsOnError() {
        mockAuth.loginResult = .failure(TestError())
        var loadingStates: [Bool] = []
        sut.onLoadingChanged = { loadingStates.append($0) }

        sut.login(email: "user@example.com", password: "password123")

        XCTAssertEqual(loadingStates, [true, false])
    }
}
