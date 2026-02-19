import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var firestoreManager: FirestoreManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        Text(note.title)
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding(.bottom, 5)

                    Divider()
                        .background(Color.blue.opacity(0.3))

                    Text(note.content)
                        .font(.body)
                        .lineSpacing(8)
                        .padding(.top, 5)

                    Spacer(minLength: 40)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.systemBackground))
                        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
                )
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())

            // Delete button with gradient
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete Note", systemImage: "trash")
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
            .alert("Delete Note", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    firestoreManager.deleteNote(note)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this note?")
            }

            // Roll number footer
            Text("Roll: 2107078")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingEditSheet = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddNoteView(firestoreManager: firestoreManager, noteToEdit: note)
        }
    }
}

#Preview {
    NavigationView {
        NoteDetailView(
            note: Note(id: "1", title: "Sample", content: "Content", userId: "user"),
            firestoreManager: FirestoreManager()
        )
    }
}
