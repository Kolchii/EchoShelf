//
//  SettingsViewModelTests.swift
//  EchoShelfTests
//
import XCTest
@testable import EchoShelf

final class SettingsViewModelTests: XCTestCase {

    private var sut: SettingsViewModel!

    override func setUp() {
        super.setUp()
        sut = SettingsViewModel()
        // Clear prefs so tests are isolated
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.prefAutoplay)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.prefAutoDownload)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.prefAudioQuality)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.prefAutoplay)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.prefAutoDownload)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.prefAudioQuality)
        sut = nil
        super.tearDown()
    }

    // MARK: - isAutoPlayEnabled

    func test_autoPlay_defaultIsFalse() {
        XCTAssertFalse(sut.isAutoPlayEnabled)
    }

    func test_autoPlay_setTrue_persists() {
        sut.isAutoPlayEnabled = true
        XCTAssertTrue(sut.isAutoPlayEnabled)
    }

    func test_autoPlay_setFalse_persists() {
        sut.isAutoPlayEnabled = true
        sut.isAutoPlayEnabled = false
        XCTAssertFalse(sut.isAutoPlayEnabled)
    }

    func test_autoPlay_writesToCorrectKey() {
        sut.isAutoPlayEnabled = true
        let stored = UserDefaults.standard.bool(forKey: UserDefaultsKey.prefAutoplay)
        XCTAssertTrue(stored)
    }

    // MARK: - isAutoDownloadEnabled

    func test_autoDownload_defaultIsFalse() {
        XCTAssertFalse(sut.isAutoDownloadEnabled)
    }

    func test_autoDownload_setTrue_persists() {
        sut.isAutoDownloadEnabled = true
        XCTAssertTrue(sut.isAutoDownloadEnabled)
    }

    func test_autoDownload_writesToCorrectKey() {
        sut.isAutoDownloadEnabled = true
        let stored = UserDefaults.standard.bool(forKey: UserDefaultsKey.prefAutoDownload)
        XCTAssertTrue(stored)
    }

    // MARK: - audioQuality

    func test_audioQuality_defaultValue() {
        XCTAssertEqual(sut.audioQuality, "Yüksək (Lossless)")
    }

    func test_audioQuality_setNewValue_persists() {
        sut.audioQuality = "Orta (AAC)"
        XCTAssertEqual(sut.audioQuality, "Orta (AAC)")
    }

    func test_audioQuality_setAnother_persists() {
        sut.audioQuality = "Aşağı (MP3)"
        XCTAssertEqual(sut.audioQuality, "Aşağı (MP3)")
    }

    func test_audioQuality_writesToCorrectKey() {
        sut.audioQuality = "Orta (AAC)"
        let stored = UserDefaults.standard.string(forKey: UserDefaultsKey.prefAudioQuality)
        XCTAssertEqual(stored, "Orta (AAC)")
    }

    // MARK: - Preferences are independent

    func test_autoPlay_doesNotAffectAutoDownload() {
        sut.isAutoPlayEnabled = true
        XCTAssertFalse(sut.isAutoDownloadEnabled)
    }

    func test_autoDownload_doesNotAffectAudioQuality() {
        sut.isAutoDownloadEnabled = true
        XCTAssertEqual(sut.audioQuality, "Yüksək (Lossless)")
    }
}
