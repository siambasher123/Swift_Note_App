import SwiftUI

struct AddNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var firestoreManager: FirestoreManager
    var noteToEdit: Note?

    @State private var title = ""
    @State private var content = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Title", text: $title)
                    .font(.title2)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                TextEditor(text: $content)
                    .font(.body)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .frame(minHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)

                Spacer()

                Button("Save") {
                    if let note = noteToEdit {
                        var updatedNote = note
                        updatedNote.title = title
                        updatedNote.content = content
                        firestoreManager.updateNote(updatedNote)
                    } else {
                        firestoreManager.addNote(title: title, content: content)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .padding(.horizontal)
                .disabled(title.isEmpty || content.isEmpty)
                .opacity(title.isEmpty || content.isEmpty ? 0.5 : 1)

                // Roll number footer
                Text("Roll: 2107078")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
            }
            .padding(.vertical)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle(noteToEdit == nil ? "Add Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                if let note = noteToEdit {
                    title = note.title
                    content = note.content
                }
            }
        }
    }
}

#Preview {
    Text("AddNoteView preview – run in simulator to test")
}
