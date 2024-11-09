// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseAPI {
  FirebaseApp? app;
  FirebaseFirestore? firestore;
  static final DatabaseAPI instance = DatabaseAPI();

  Future<void> initialize() async {
    app = await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCSlnx2-0kUvWL_Eqaq-esyXEOfRU_Fmy8",
        appId: "1:612713813970:web:fbcc90cc4f3268004e1a0b",
        messagingSenderId: "612713813970",
        projectId: "offseason-scouting",
        storageBucket: "offseason-scouting.appspot.com",
      ),
    );

    firestore = FirebaseFirestore.instanceFor(app: app!);
  }

  Future<void> uploadJson(Map<String, dynamic> jsonData, String collectionPath,
      String documentId) async {
    if (firestore == null) {
      throw Exception("Firebase not initialized");
    }

    try {
      await firestore!.collection(collectionPath).doc(documentId).set(jsonData);
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  Future<(Map<String, dynamic>, bool)> downloadJson(
      String collectionPath, String documentId) async {
    if (firestore == null) {
      throw Exception("Firebase not initialized");
    }

    try {
      DocumentSnapshot docSnapshot =
          await firestore!.collection(collectionPath).doc(documentId).get();
      if (docSnapshot.exists) {
        return (docSnapshot.data() as Map<String, dynamic>, true);
      } else {
        Map<String, dynamic> map = {};
        return (map, false);
      }
    } on FirebaseException catch (_) {
      rethrow;
    }
  }
}
