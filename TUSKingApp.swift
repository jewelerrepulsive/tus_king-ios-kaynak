import SwiftUI

@main
@MainActor
struct TUSKingApp: App {
    @StateObject private var store = StudyStore()

    var body: some Scene {
        WindowGroup {
            LibraryView(store: store)
                .tint(.blue)
        }
    }
}
