import SwiftUI

struct ReviewView: View {
    @ObservedObject var store: StudyStore
    @Environment(\.dismiss) private var dismiss
    @State private var revealed = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let card = store.current, let round = store.session {
                        Text("\(round.index + 1) / \(round.queue.count)")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                        Text(card.topic).font(.caption).foregroundStyle(.secondary)
                        Text(revealed ? card.answer : card.question)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                        if revealed {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 108))], spacing: 12) {
                                ForEach(Rating.allCases) { rating in
                                    Button {
                                        if store.rate(rating) { revealed = false }
                                    } label: {
                                        Text(rating.rawValue)
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        } else {
                            Button {
                                revealed = true
                            } label: {
                                Text("Cevabı göster").frame(maxWidth: .infinity, minHeight: 44)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        Label("Tur tamamlandı", systemImage: "checkmark.circle")
                            .font(.title2.bold())
                    }
                    Button("Son yanıtı geri al") {
                        if store.undo() { revealed = false }
                    }
                    .disabled(store.previous == nil)
                }
                .padding()
                .frame(maxWidth: 680)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Çalışma")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}
