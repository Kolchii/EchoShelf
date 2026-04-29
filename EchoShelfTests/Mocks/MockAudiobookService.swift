//
//  MockAudiobookService.swift
//  EchoShelfTests
//
import Foundation
@testable import EchoShelf

final class MockAudiobookService: AudiobookServiceProtocol {

    // MARK: - Stubs

    var fetchAudiobooksResult: Result<[Audiobook], APIError> = .success([])
    var searchAudiobooksResult: Result<[Audiobook], APIError> = .success([])
    var fetchDetailResult: Result<Audiobook, APIError> = .success(Audiobook.stub())
    var fetchByGenreResult: Result<[Audiobook], APIError> = .success([])

    // MARK: - Call Counts

    var fetchAudiobooksCallCount = 0
    var searchAudiobooksCallCount = 0
    var fetchDetailCallCount = 0
    var fetchByGenreCallCount = 0

    // MARK: - Captured Args

    var lastSearchQuery: String?
    var lastFetchPage: Int?
    var lastGenreSubject: String?

    // MARK: - Protocol

    func fetchAudiobooks(page: Int, completion: @escaping (Result<[Audiobook], APIError>) -> Void) {
        fetchAudiobooksCallCount += 1
        lastFetchPage = page
        completion(fetchAudiobooksResult)
    }

    func searchAudiobooks(query: String, completion: @escaping (Result<[Audiobook], APIError>) -> Void) {
        searchAudiobooksCallCount += 1
        lastSearchQuery = query
        completion(searchAudiobooksResult)
    }

    func fetchAudiobookDetail(id: Int, completion: @escaping (Result<Audiobook, APIError>) -> Void) {
        fetchDetailCallCount += 1
        completion(fetchDetailResult)
    }

    func fetchByGenre(subject: String, page: Int, completion: @escaping (Result<[Audiobook], APIError>) -> Void) {
        fetchByGenreCallCount += 1
        lastGenreSubject = subject
        completion(fetchByGenreResult)
    }
}
