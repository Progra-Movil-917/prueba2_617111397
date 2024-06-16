import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  Future<void> addNote({
    required Map<String, dynamic> noteData,
  }) {
    return notes.add({
      'name': noteData['name'],
      'note': noteData['note'],
      'center': noteData['center'],
      'doctor': noteData['doctor'],
      'date': noteData['date'],
      'timestamp': noteData['timestamp'],
    });
  }

  Future<void> updateNotes(String docID, {
    required Map<String, dynamic> noteData,
  }) {
    return notes.doc(docID).update({
      'name': noteData['name'],
      'note': noteData['note'],
      'center': noteData['center'],
      'doctor': noteData['doctor'],
      'date': noteData['date'],
    });
  }

  Future<void> deleteNotes(String docID) {
    return notes.doc(docID).delete();
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }
}
