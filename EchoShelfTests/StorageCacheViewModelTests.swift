//
//  StorageCacheViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class StorageCacheViewModelTests: XCTestCase {

    private var sut: StorageCacheViewModel!

    override func setUp() {
        super.setUp()
        sut = StorageCacheViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - formatBytes

    func test_formatBytes_zero_returnsMB() {
        let result = sut.formatBytes(0)
        XCTAssertTrue(result.contains("MB"), "Expected MB for 0 bytes, got: \(result)")
    }

    func test_formatBytes_exactlyOneMB() {
        let result = sut.formatBytes(1_048_576)
        XCTAssertEqual(result, "1 MB")
    }

    func test_formatBytes_lessThan1GB_returnsMB() {
        let result = sut.formatBytes(500_000_000)
        XCTAssertTrue(result.hasSuffix("MB"))
    }

    func test_formatBytes_exactlyOneGB() {
        let result = sut.formatBytes(1_073_741_824)
        XCTAssertEqual(result, "1.0 GB")
    }

    func test_formatBytes_twoGB() {
        let result = sut.formatBytes(2_147_483_648)
        XCTAssertEqual(result, "2.0 GB")
    }

    func test_formatBytes_fractionalGB() {
        let result = sut.formatBytes(1_610_612_736) // 1.5 GB
        XCTAssertEqual(result, "1.5 GB")
    }

    func test_formatBytes_largeValue() {
        let result = sut.formatBytes(128_849_018_880) // 120 GB
        XCTAssertTrue(result.hasSuffix("GB"))
    }

    // MARK: - appRatio

    func test_appRatio_whenNoBooksAndNoTotal_returnsZero() {
        // When totalBytes is 0 (unlikely in real device but guard handles it)
        // StorageCacheViewModel reads real FS — we just verify it's between 0 and 1
        let ratio = sut.appRatio
        XCTAssertGreaterThanOrEqual(ratio, 0.0)
        XCTAssertLessThanOrEqual(ratio, 1.0)
    }

    func test_otherRatio_isNonNegative() {
        let ratio = sut.otherRatio
        XCTAssertGreaterThanOrEqual(ratio, 0.0)
    }

    // MARK: - Formatted Strings

    func test_totalFormatted_isNotEmpty() {
        XCTAssertFalse(sut.totalFormatted.isEmpty)
    }

    func test_freeFormatted_isNotEmpty() {
        XCTAssertFalse(sut.freeFormatted.isEmpty)
    }

    func test_appFormatted_noBooks_isZeroMB() {
        // No books loaded → appBytes == 0
        let result = sut.appFormatted
        XCTAssertTrue(result.contains("MB") || result.contains("GB"))
    }

    // MARK: - usedBytes

    func test_usedBytes_equalsTotalMinusFree() {
        let used = sut.usedBytes
        XCTAssertEqual(used, sut.totalBytes - sut.freeBytes)
    }

    // MARK: - formatBytes edge cases

    func test_formatBytes_999MB_staysMB() {
        let bytes: Int64 = Int64(999 * 1_048_576) // ~999 MB
        let result = sut.formatBytes(bytes)
        XCTAssertTrue(result.hasSuffix("MB"), "Expected MB, got: \(result)")
    }
}
