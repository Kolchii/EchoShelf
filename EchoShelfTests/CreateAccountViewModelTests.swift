//
//  CreateAccountViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class CreateAccountViewModelTests: XCTestCase {

    private var sut: CreateAccountViewModel!
    private var mockAuth: MockAuthManager!

    override func setUp() {
        super.setUp()
        mockAuth = MockAuthManager()
        sut = CreateAccountViewModel(authManager: mockAuth)
        // Isolate UserDefaults side-effects
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userName)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userName)
        sut = nil
        mockAuth = nil
        super.tearDown()
    }

    // MARK: - Name Validation

    func test_createAccount_nilName_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: nil, email: "a@b.com", password: "password")

        XCTAssertEqual(msg, "Full name is required.")
        XCTAssertEqual(mockAuth.registerCallCount, 0)
    }

    func test_createAccount_emptyName_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "", email: "a@b.com", password: "password")

        XCTAssertEqual(msg, "Full name is required.")
    }

    // MARK: - Email Validation

    func test_createAccount_nilEmail_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "Ali", email: nil, password: "password")

        XCTAssertEqual(msg, "Email is required.")
    }

    func test_createAccount_emptyEmail_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "Ali", email: "", password: "password")

        XCTAssertEqual(msg, "Email is required.")
    }

    func test_createAccount_invalidEmail_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "Ali", email: "not-valid", password: "password")

        XCTAssertEqual(msg, "Please enter a valid email address.")
    }

    // MARK: - Password Validation

    func test_createAccount_nilPassword_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "Ali", email: "a@b.com", password: nil)

        XCTAssertEqual(msg, "Password is required.")
    }

    func test_createAccount_emptyPassword_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "Ali", email: "a@b.com", password: "")

        XCTAssertEqual(msg, "Password is required.")
    }

    func test_createAccount_shortPassword_firesError() {
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "Ali", email: "a@b.com", password: "12345")

        XCTAssertEqual(msg, "Password must be at least 6 characters.")
    }

    // MARK: - Success Path

    func test_createAccount_validInputs_callsRegister() {
        mockAuth.registerResult = .success(())
        var successCalled = false
        sut.onCreateSuccess = { successCalled = true }

        sut.createAccount(name: "Ali Mammadov", email: "ali@test.com", password: "secure123")

        XCTAssertTrue(successCalled)
        XCTAssertEqual(mockAuth.registerCallCount, 1)
        XCTAssertEqual(mockAuth.lastRegisterName, "Ali Mammadov")
    }

    func test_createAccount_success_savesNameToUserDefaults() {
        mockAuth.registerResult = .success(())

        sut.createAccount(name: "Ibrahim", email: "i@b.com", password: "password")

        let saved = UserDefaults.standard.string(forKey: UserDefaultsKey.userName)
        XCTAssertEqual(saved, "Ibrahim")
    }

    func test_createAccount_success_loaderToggled() {
        mockAuth.registerResult = .success(())
        var states: [Bool] = []
        sut.onLoadingChanged = { states.append($0) }

        sut.createAccount(name: "Ali", email: "a@b.com", password: "password")

        XCTAssertEqual(states, [true, false])
    }

    // MARK: - Failure Path

    func test_createAccount_failure_firesError() {
        mockAuth.registerResult = .failure(TestError("Email already in use"))
        var msg: String?
        sut.onError = { msg = $0 }

        sut.createAccount(name: "Ali", email: "a@b.com", password: "password")

        XCTAssertEqual(msg, "Email already in use")
    }

    func test_createAccount_failure_doesNotSaveName() {
        mockAuth.registerResult = .failure(TestError())

        sut.createAccount(name: "Ali", email: "a@b.com", password: "password")

        XCTAssertNil(UserDefaults.standard.string(forKey: UserDefaultsKey.userName))
    }
}
