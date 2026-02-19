import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

struct Note: Identifiable {
    var id: String
    var title: String
    var content: String
    var userId: String
}

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    @Published var notes = [Note]()
    private var listener: ListenerRegistration?

    deinit { listener?.remove() }

    func addNote(title: String, content: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = ["title": title, "content": content, "userId": currentUserID]
        db.collection("notes").addDocument(data: data) { error in
            if let error = error { print("Error adding document: \(error)") }
        }
    }

    func getNotes() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            self.notes = []
            return
        }

        listener?.remove()

        listener = db.collection("notes")
            .whereField("userId", isEqualTo: currentUserID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting notes: \(error)")
                    return
                }
                let fetched: [Note] = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let title   = data["title"]   as? String,
                        let content = data["content"] as? String,
                        let userId  = data["userId"]  as? String
                    else { return nil }
                    return Note(id: doc.documentID, title: title, content: content, userId: userId)
                } ?? []

                DispatchQueue.main.async {
                    self.notes = fetched.sorted { $0.title.lowercased() < $1.title.lowercased() }
                }
            }
    }

    func updateNote(_ note: Note) {
        let data: [String: Any] = ["title": note.title, "content": note.content, "userId": note.userId]
        db.collection("notes").document(note.id).setData(data) { error in
            if let error = error { print("Error updating note: \(error)") }
        }
    }

    func deleteNote(_ note: Note) {
        db.collection("notes").document(note.id).delete { error in
            if let error = error { print("Error deleting note: \(error)") }
        }
    }
}
