import Foundation

extension Int {
    func formatSeconds() -> String {
        let minutesAndSeconds = ((self/60), (self%60))
        return "\(String(format: "%02d", minutesAndSeconds.0)) : \(String(format: "%02d", minutesAndSeconds.1))"
    }
}
