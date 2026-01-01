import '../models/exercise.dart';
import '../services/handbook_firestore_service.dart';
import '../models/handbook_topic.dart';

/// ExerciseLibrary now prefers remote handbook topic (doc '1') stored in
/// Firestore under `handbookTopics/1`. If remote doc is missing or fails,
/// it falls back to local `HandbookData.topics` (id '1') or the built-in
/// default list.
class ExerciseLibrary {
  static List<Exercise> exercises = [];
  static bool _loaded = false;

  /// Public loader — call once on app start or before showing selection UI.
  static Future<void> load() async {
    if (_loaded) return;
    // Prefer Firestore handbook topic with id '1'.
    final fetched = await loadFromFirestoreTopic('1');
    if (fetched) return;

    // Firestore missing or failed — no local handbook helper available, so leave empty.
    // If you want a local fallback, add `HandbookData.topics` helper in
    // `lib/models/handbook_topic.dart` and re-enable loading here.
    // ignore: avoid_print
    print('ExerciseLibrary.load: Firestore doc not found; using empty list');
    exercises = [];
    _loaded = true;
  }

  /// Try loading a handbook topic from Firestore by `docId`.
  /// Returns true if exercises were loaded.
  static Future<bool> loadFromFirestoreTopic(String docId) async {
    try {
      final service = HandbookFirestoreService();
      final topic = await service.fetchTopicById(docId);
      if (topic == null) return false;
      final loaded = _mapFromHandbookTopic(topic);
      if (loaded.isEmpty) return false;
      exercises = loaded;
      _loaded = true;
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('ExerciseLibrary.loadFromFirestoreTopic error: $e');
      return false;
    }
  }

  static List<Exercise> _mapFromHandbookTopic(HandbookTopic topic) {
    // Normalize incoming handbook topic into app `Exercise` objects.
    final out = <Exercise>[];
    for (final section in topic.sections) {
      final rawGroup = section.title;
      final group = _standardizeGroup(rawGroup);
      if (section.exercises == null) continue;
      for (final ex in section.exercises!) {
        try {
          final name = _normalizeExerciseName(ex.name);
          final theory = ex.theory;
          final steps = ex.steps;
          final description = theory.isNotEmpty
              ? theory
              : (steps.isNotEmpty ? steps.first : '');

          out.add(
            Exercise(
              id: '${group}_$name',
              name: name,
              description: description,
              muscleGroup: group,
              equipment: '',
              imageUrl: ex.image,
              instructionImages: ex.instructionImages,
              instructions: steps,
              theory: theory,
              difficulty: 'Trung bình',
            ),
          );
        } catch (_) {
          continue;
        }
      }
    }
    return out;
  }

  // Map raw section titles (various forms) to the canonical Vietnamese groups
  // requested by the user.
  static String _standardizeGroup(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('ngực') || s.contains('nguc') || s.contains('chest')) {
      return 'Ngực';
    }
    if (s.contains('lưng') || s.contains('lung') || s.contains('back')) {
      return 'Lưng';
    }
    if (s.contains('chân') || s.contains('chan') || s.contains('leg')) {
      return 'Chân';
    }
    if (s.contains('mông') || s.contains('mong') || s.contains('glute')) {
      return 'Cơ mông';
    }
    if (s.contains('vai') || s.contains('delta')) {
      return 'Cơ delta';
    }
    if (s.contains('tay trước') ||
        s.contains('taytruoc') ||
        s.contains('bắp tay trước') ||
        s.contains('bap tay truoc')) {
      return 'Cơ tay trước';
    }
    if (s.contains('tay sau') ||
        s.contains('taysau') ||
        s.contains('bắp tay sau') ||
        s.contains('bap tay sau')) {
      return 'Cơ tay sau';
    }
    if (s.contains('cẳng tay') ||
        s.contains('cang tay') ||
        s.contains('forearm')) {
      return 'Cẳng tay';
    }
    if (s.contains('bụng') || s.contains('bung') || s.contains('ab')) {
      return 'Cơ bụng';
    }
    if (s.contains('chức năng') ||
        s.contains('chuc nang') ||
        s.contains('functional')) {
      return 'Luyện tập chức năng';
    }
    if (s.contains('cardio')) {
      return 'Cardio';
    }
    if (s.contains('giãn') || s.contains('gian') || s.contains('stretch')) {
      return 'Giãn cơ';
    }

    // If nothing matches, try a cleaned-up capitalization of the raw title.
    final cleaned = raw.trim();
    if (cleaned.isEmpty) return 'Khác';
    return cleaned
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static String _normalizeExerciseName(String name) {
    final n = name.trim();
    if (n.isEmpty) return 'Không tên';
    // Capitalize first letter of each word (simple, works for Vietnamese as well).
    return n
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  static List<Exercise> _parseFromRemote(Map<String, dynamic> data) {
    final out = <Exercise>[];
    final sections = data['sections'] as List<dynamic>?;
    if (sections == null) return out;
    for (final s in sections) {
      final title = (s['title'] ?? '').toString();
      final exs = s['exercises'] as List<dynamic>?;
      if (exs == null) continue;
      for (final e in exs) {
        try {
          final name = (e['name'] ?? e['title'] ?? '').toString();
          final image = (e['image'] ?? '').toString();
          final instructionImages =
              (e['instructionImages'] as List<dynamic>?)
                  ?.map((x) => x.toString())
                  .toList() ??
              [];
          final theory = (e['theory'] ?? '').toString();
          final steps =
              (e['steps'] as List<dynamic>?)
                  ?.map((x) => x.toString())
                  .toList() ??
              [];
          out.add(
            Exercise(
              id: (e['id'] ?? '${title}_$name').toString(),
              name: name,
              description: theory.isNotEmpty
                  ? theory
                  : (steps.isNotEmpty ? steps.first : ''),
              muscleGroup: title,
              equipment: (e['equipment'] ?? '').toString(),
              imageUrl: image,
              instructionImages: instructionImages,
              instructions: steps,
              theory: theory,
              difficulty: (e['difficulty'] ?? 'Trung bình').toString(),
            ),
          );
        } catch (_) {
          continue;
        }
      }
    }
    return out;
  }

  /// Lấy bài tập theo nhóm cơ
  static List<Exercise> getByMuscleGroup(String muscleGroup) {
    return exercises.where((e) => e.muscleGroup == muscleGroup).toList();
  }

  /// Lấy bài tập theo độ khó
  static List<Exercise> getByDifficulty(String difficulty) {
    return exercises.where((e) => e.difficulty == difficulty).toList();
  }

  /// Tìm kiếm bài tập
  static List<Exercise> search(String query) {
    final lowerQuery = query.toLowerCase();
    return exercises
        .where(
          (e) =>
              e.name.toLowerCase().contains(lowerQuery) ||
              e.description.toLowerCase().contains(lowerQuery) ||
              e.muscleGroup.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  // No built-in default exercises; rely on Firestore-backed data.
}
