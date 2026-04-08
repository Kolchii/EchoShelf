//
//  PlayerViewModel.swift
//  EchoShelf
//
//  Created by Ibrahim Kolchi on 27.02.26.
//
import Foundation

final class PlayerViewModel {

    private let manager = PlayerManager.shared

    var currentBook: Audiobook? { manager.currentBook }
    var isPlaying: Bool { manager.isPlaying }

    var currentTimeText: String { formatTime(manager.currentTime) }
    var durationText: String { formatTime(manager.duration) }
    var progress: Float {
        guard manager.duration > 0 else { return 0 }
        return Float(manager.currentTime / manager.duration)
    }

    var onProgressUpdated: (() -> Void)?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(progressUpdated),
            name: .playerProgressUpdated,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func togglePlayPause() {
        manager.togglePlayPause()
    }

    func seek(to progress: Float) {
        let time = Double(progress) * manager.duration
        manager.seek(to: time)
    }

    @objc private func progressUpdated() {
        onProgressUpdated?()
    }

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "0:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}
