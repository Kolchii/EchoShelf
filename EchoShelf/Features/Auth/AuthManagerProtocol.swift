//
//  AuthManagerProtocol.swift
//  EchoShelf
//
import Foundation

protocol AuthManagerProtocol {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func register(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func logout()
}
