//
//  FlexibleIntTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class FlexibleIntTests: XCTestCase {

    // MARK: - init(from value:)

    func test_initFromInt_storesValue() {
        let fi = FlexibleInt(from: 42)
        XCTAssertEqual(fi.value, 42)
    }

    func test_initFromInt_zero() {
        let fi = FlexibleInt(from: 0)
        XCTAssertEqual(fi.value, 0)
    }

    func test_initFromInt_negative() {
        let fi = FlexibleInt(from: -10)
        XCTAssertEqual(fi.value, -10)
    }

    // MARK: - Decoding from JSON Int

    func test_decodeFromInt_success() throws {
        let json = Data("42".utf8)
        let fi = try JSONDecoder().decode(FlexibleInt.self, from: json)
        XCTAssertEqual(fi.value, 42)
    }

    func test_decodeFromInt_zero() throws {
        let json = Data("0".utf8)
        let fi = try JSONDecoder().decode(FlexibleInt.self, from: json)
        XCTAssertEqual(fi.value, 0)
    }

    func test_decodeFromInt_largeNumber() throws {
        let json = Data("999999".utf8)
        let fi = try JSONDecoder().decode(FlexibleInt.self, from: json)
        XCTAssertEqual(fi.value, 999_999)
    }

    // MARK: - Decoding from JSON String

    func test_decodeFromString_success() throws {
        let json = Data("\"123\"".utf8)
        let fi = try JSONDecoder().decode(FlexibleInt.self, from: json)
        XCTAssertEqual(fi.value, 123)
    }

    func test_decodeFromString_zero() throws {
        let json = Data("\"0\"".utf8)
        let fi = try JSONDecoder().decode(FlexibleInt.self, from: json)
        XCTAssertEqual(fi.value, 0)
    }

    func test_decodeFromString_nonNumeric_fallsBackToZero() throws {
        let json = Data("\"abc\"".utf8)
        let fi = try JSONDecoder().decode(FlexibleInt.self, from: json)
        XCTAssertEqual(fi.value, 0)
    }

    // MARK: - Encoding

    func test_encodeAndDecode_roundTrip() throws {
        let original = FlexibleInt(from: 77)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(FlexibleInt.self, from: encoded)
        XCTAssertEqual(original.value, decoded.value)
    }

    func test_encode_producesCorrectJSON() throws {
        let fi = FlexibleInt(from: 5)
        let data = try JSONEncoder().encode(fi)
        let str = String(data: data, encoding: .utf8)
        XCTAssertEqual(str, "5")
    }
}
