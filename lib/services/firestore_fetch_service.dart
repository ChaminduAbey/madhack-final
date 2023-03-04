import 'dart:developer';

import 'package:client_app/exceptions/not_found_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFetchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<T> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data) fromDocument,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.doc(path).get();

      if (!snapshot.exists) throw NotFoundException();

      return fromDocument(snapshot.data()!);
    } catch (e, s) {
      log("GetDocument :" + e.toString(), stackTrace: s);
      rethrow;
    }
  }

  Future<void> setOrUpdateDocument<T>({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.doc(path).set(data);
    } catch (e, s) {
      log("setOrUpdateDocument :" + e.toString(), stackTrace: s);
      rethrow;
    }
  }
}
