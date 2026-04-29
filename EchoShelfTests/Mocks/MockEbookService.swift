//
//  MockEbookService.swift
//  EchoShelfTests
//
import Foundation
@testable import EchoShelf

final class MockEbookService: EbookServiceProtocol {

    // MARK: - Stubs

    var searchEbooksResult: Result<[Ebook], APIError> = .success([])
    var fetchBySubjectResult: Result<[Ebook], APIError> = .success([])

    // MARK: - Call Counts

    var searchEbooksCallCount = 0
    var fetchBySubjectCallCount = 0

    // MARK: - Captured Args

    var lastSearchQuery: String?
    var lastSubject: String?

    // MARK: - Protocol

    func searchEbooks(query: String, completion: @escaping (Result<[Ebook], APIError>) -> Void) {
        searchEbooksCallCount += 1
        lastSearchQuery = query
        completion(searchEbooksResult)
    }

    func fetchEbooksBySubject(subject: String, page: Int, completion: @escaping (Result<[Ebook], APIError>) -> Void) {
        fetchBySubjectCallCount += 1
        lastSubject = subject
        completion(fetchBySubjectResult)
    }
}
