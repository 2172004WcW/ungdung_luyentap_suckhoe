import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/handbook_topic.dart';
import '../models/handbook_serialization.dart';

class HandbookFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'handbook_topics';

  CollectionReference get _colRef => _db.collection(_collection);

  Stream<List<HandbookTopic>> topicsStream() {
    return _colRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data() as Map);
        data['id'] = doc.id;
        return handbookTopicFromJson(data);
      }).toList();
    });
  }

  Future<List<HandbookTopic>> fetchAllTopics() async {
    final snapshot = await _colRef.get();
    return snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data() as Map);
      data['id'] = doc.id;
      return handbookTopicFromJson(data);
    }).toList();
  }

  Future<HandbookTopic?> fetchTopicById(String id) async {
    final doc = await _colRef.doc(id).get();
    if (!doc.exists) return null;
    final data = Map<String, dynamic>.from(doc.data() as Map);
    data['id'] = doc.id;
    return handbookTopicFromJson(data);
  }

  Stream<HandbookTopic?> topicStream(String id) {
    return _colRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = Map<String, dynamic>.from(doc.data() as Map);
      data['id'] = doc.id;
      return handbookTopicFromJson(data);
    });
  }

  Future<void> uploadTopic(HandbookTopic topic) async {
    final data = topic.toJson();
    // Use provided id or let Firestore generate one
    if (topic.id.isEmpty) {
      await _colRef.add(data);
    } else {
      await _colRef.doc(topic.id).set(data);
    }
  }

  Future<void> deleteTopic(String id) async {
    await _colRef.doc(id).delete();
  }
}
