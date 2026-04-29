//
//  MockAuthManager.swift
//  EchoShelfTests
//
import Foundation
@testable import EchoShelf

final class MockAuthManager: AuthManagerProtocol {

    // MARK: - Stubs

    var loginResult: Result<Void, Error> = .success(())
    var registerResult: Result<Void, Error> = .success(())
    var resetPasswordResult: Result<Void, Error> = .success(())

    // MARK: - Call Counts

    var loginCallCount = 0
    var registerCallCount = 0
    var resetPasswordCallCount = 0
    var logoutCallCount = 0

    // MARK: - Captured Args

    var lastLoginEmail: String?
    var lastLoginPassword: String?
    var lastRegisterName: String?
    var lastResetEmail: String?

    // MARK: - Protocol

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        loginCallCount += 1
        lastLoginEmail = email
        lastLoginPassword = password
        completion(loginResult)
    }

    func register(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        registerCallCount += 1
        lastRegisterName = name
        completion(registerResult)
    }

    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        resetPasswordCallCount += 1
        lastResetEmail = email
        completion(resetPasswordResult)
    }

    func logout() {
        logoutCallCount += 1
    }
}
