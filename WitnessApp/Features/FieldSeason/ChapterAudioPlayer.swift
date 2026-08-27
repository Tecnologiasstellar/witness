import AVFoundation
import Foundation
import WitnessCore

/// Playback for a bundled chapter narration. Local file only — no
/// streaming, no network. Honest states: if the file is missing from the
/// bundle the player reports unavailable and the reader shows text only.
@MainActor
final class ChapterAudioPlayer: NSObject, ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var duration: TimeInterval = 0
    @Published private(set) var isAvailable = false

    private var player: AVAudioPlayer?
    private var ticker: Timer?

    func load(_ audio: FieldSeasonAudio) {
        guard player == nil else { return }
        guard let url = Bundle.main.url(forResource: audio.fileName, withExtension: audio.fileExtension),
              let loaded = try? AVAudioPlayer(contentsOf: url) else {
            isAvailable = false
            return
        }
        loaded.delegate = self
        loaded.prepareToPlay()
        player = loaded
        duration = loaded.duration
        isAvailable = true
    }

    func toggle() {
        guard let player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopTicker()
        } else {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
            try? AVAudioSession.sharedInstance().setActive(true)
            player.play()
            isPlaying = true
            startTicker()
        }
    }

    func seek(to fraction: Double) {
        guard let player, duration > 0 else { return }
        player.currentTime = max(0, min(duration, fraction * duration))
        currentTime = player.currentTime
    }

    func stop() {
        player?.stop()
        isPlaying = false
        stopTicker()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func startTicker() {
        stopTicker()
        ticker = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self, let player = self.player else { return }
                self.currentTime = player.currentTime
            }
        }
    }

    private func stopTicker() {
        ticker?.invalidate()
        ticker = nil
    }

    static func timestamp(_ seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}

extension ChapterAudioPlayer: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.isPlaying = false
            self.currentTime = 0
            self.stopTicker()
        }
    }
}
