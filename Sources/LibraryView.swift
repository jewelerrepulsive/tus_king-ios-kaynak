import SwiftUI

struct LibraryView: View {
    @ObservedObject var store: StudyStore
    @State private var subject: String?
    @State private var pendingSubject: String?
    @State private var pendingTopic: String?
    @State private var search = ""
    @State private var showingStudy = false
    @State private var confirmingNewRound = false

    private var subjects: [String] {
        Set(store.cards.map(\.subject)).sorted()
    }

    private var selection: [StudyCard] {
        store.cards.filter { card in
            (pendingSubject == nil || card.subject == pendingSubject) &&
            (pendingTopic == nil || card.topic == pendingTopic)
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $subject) {
                Section {
                    NavigationLink(value: "") { Label("Tüm branşlar", systemImage: "square.grid.2x2") }
                    ForEach(subjects.filter { search.isEmpty || $0.localizedStandardContains(search) }, id: \.self) { name in
                        NavigationLink(value: name) { Text(name) }
                    }
                } header: { Text("Örnek deste") }
            }
            .searchable(text: $search, prompt: "Branş ara")
            .navigationTitle("TUS King")
        } detail: {
            deckOverview(subject == "" ? nil : subject)
        }
        .sheet(isPresented: $showingStudy) {
            ReviewView(store: store)
        }
        .alert("TUS King", isPresented: Binding(
            get: { store.error != nil }, set: { if !$0 { store.error = nil } }
        )) {
            Button("Tamam", role: .cancel) { store.error = nil }
        } message: { Text(store.error ?? "") }
    }

    private func deckOverview(_ name: String?) -> some View {
        let cards = store.cards.filter { name == nil || $0.subject == name }
        return List {
            Section {
                Label("Bu cihazda • çevrimdışı", systemImage: "internaldrive")
                    .foregroundStyle(.secondary)
                if store.current != nil {
                    Button("Devam et") { showingStudy = true }
                }
                Button {
                    if store.current != nil {
                        pendingSubject = name
                        pendingTopic = nil
                        confirmingNewRound = true
                    } else if store.start(cards) {
                        showingStudy = true
                    }
                } label: {
                    Label("Serbest çalışma", systemImage: "play.fill")
                }
                .disabled(cards.isEmpty)
            } header: {
                Text("\(cards.count) örnek kart")
            }
            Section("Konular") {
                ForEach(Set(cards.map(\.topic)).sorted(), id: \.self) { topic in
                    Button(topic) {
                        let topicCards = cards.filter { $0.topic == topic }
                        if store.current != nil {
                            pendingSubject = name
                            pendingTopic = topic
                            confirmingNewRound = true
                        } else if store.start(topicCards) {
                            showingStudy = true
                        }
                    }
                }
            }
        }
        .navigationTitle(name ?? "Tüm branşlar")
        .confirmationDialog("Yeni çalışma turu açılsın mı?", isPresented: $confirmingNewRound) {
            Button("Yeni tur aç") {
                if store.start(selection) { showingStudy = true }
            }
            Button("Vazgeç", role: .cancel) {}
        } message: {
            Text("Yarım kalan turun yerine yeni tur açılır.")
        }
    }
}
