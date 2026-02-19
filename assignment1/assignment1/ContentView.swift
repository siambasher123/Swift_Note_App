import SwiftUI

struct ContentView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(firestoreManager.notes) { note in
                        ZStack {
                            NavigationLink(destination: NoteDetailView(note: note, firestoreManager: firestoreManager)) {
                                EmptyView()
                            }
                            .opacity(0)

                            VStack(alignment: .leading, spacing: 8) {
                                Text(note.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(note.content)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                            .padding(.vertical, 4)
                        }
                        .swipeActions {
                            Button("Delete") {
                                firestoreManager.deleteNote(note)
                            }
                            .tint(.red)

                            Button("Edit") {
                                selectedNote = note
                            }
                            .tint(.blue)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .background(Color(.systemGroupedBackground))
                .onAppear {
                    firestoreManager.getNotes()
                }

                // Sign Out button with gradient
                Button(action: { authViewModel.signOut() }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red, Color.orange]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                .padding(.bottom, 4)

                // Roll number footer
                Text("Roll: 2107078")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .navigationTitle("My Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedNote = nil
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .background(Circle().fill(Color.white).shadow(radius: 2))
                    }
                }
            }
            .sheet(item: $selectedNote) { note in
                AddNoteView(firestoreManager: firestoreManager, noteToEdit: note)
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(firestoreManager: firestoreManager, noteToEdit: nil)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
