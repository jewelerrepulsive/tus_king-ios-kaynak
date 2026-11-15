import Foundation
import Combine

struct StudyCard: Codable, Identifiable {
    let id: String
    let subject: String
    let topic: String
    let question: String
    let answer: String
}

enum Rating: String, CaseIterable, Identifiable, Codable {
    case again = "Tekrar", hard = "Zor", good = "İyi", easy = "Kolay"
    var id: String { rawValue }
}

struct Session: Codable {
    var queue: [String]
    var index = 0
    var lastRating: Rating?
}

@MainActor
final class StudyStore: ObservableObject {
    @Published private(set) var session: Session?
    @Published private(set) var previous: Session?
    @Published var error: String?
    let cards: [StudyCard]
    let byID: [String: StudyCard]
    private let file: URL?

    private struct Progress: Codable {
        let session: Session
        let previous: Session?
    }

    init() {
        let loaded: [StudyCard]
        do {
            guard let resource = Bundle.main.url(forResource: "SampleCards", withExtension: "json") else {
                throw CocoaError(.fileNoSuchFile)
            }
            loaded = try JSONDecoder().decode([StudyCard].self, from: Data(contentsOf: resource))
        } catch {
            loaded = []
        }
        cards = loaded
        byID = Dictionary(loaded.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        file = try? FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("TUSKingStudy.json")
        if loaded.isEmpty { error = "Örnek deste açılamadı."; return }
        guard let file, FileManager.default.fileExists(atPath: file.path) else { return }
        do {
            let progress = try JSONDecoder().decode(Progress.self, from: Data(contentsOf: file))
            guard isValid(progress.session), progress.previous.map(isValid) ?? true else {
                throw CocoaError(.fileReadCorruptFile)
            }
            session = progress.session
            previous = progress.previous
        } catch {
            self.error = "Kayıtlı çalışma turu okunamadı."
        }
    }

    var current: StudyCard? {
        guard let session, session.queue.indices.contains(session.index) else { return nil }
        return byID[session.queue[session.index]]
    }

    func start(_ cards: [StudyCard]) -> Bool {
        guard !cards.isEmpty else { return false }
        return save(Session(queue: cards.map(\.id)), previous: nil)
    }

    func rate(_ rating: Rating) -> Bool {
        guard let old = session, let current else { return false }
        var updated = old
        if rating == .again { updated.queue.append(current.id) }
        updated.index += 1
        updated.lastRating = rating
        return save(updated, previous: old)
    }

    func undo() -> Bool {
        guard let previous else { return false }
        return save(previous, previous: nil)
    }

    private func isValid(_ session: Session) -> Bool {
        (0...session.queue.count).contains(session.index) &&
            session.queue.allSatisfy { byID[$0] != nil }
    }

    private func save(_ next: Session, previous: Session?) -> Bool {
        do {
            guard let file else { throw CocoaError(.fileNoSuchFile) }
            let data = try JSONEncoder().encode(Progress(session: next, previous: previous))
            try data.write(to: file, options: .atomic)
            session = next
            self.previous = previous
            return true
        } catch {
            self.error = "Çalışma kaydedilemedi. Cihazda yer açıp tekrar dene."
            return false
        }
    }
}
