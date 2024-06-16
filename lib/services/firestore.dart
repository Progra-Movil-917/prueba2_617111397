import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes =FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(String note) {
    return notes.add(
      {
      'note': note,
      "timestamp": Timestamp.now()
      });
  }

  Stream<QuerySnapshot> getNotesStream() {
    final NotesStream = notes.orderBy('timestamp', descending: true).snapshots();
    return NotesStream;
  }

  Future<void> updateNotes(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      "timestamp": Timestamp.now()
      });
  }

  Future<void> deleteNotes(String docID) {
    return notes.doc(docID).delete();
  }
}