import 'package:flutter/material.dart';
import '../models/handbook_topic.dart';
import 'exercise_detail_screen.dart';
import '../services/handbook_firestore_service.dart';

/// Now supports listening to a topic stream and finding the section by title

class ExerciseListScreen extends StatefulWidget {
  final String title;
  final String topicId;
  final List<ExerciseDetail>? initialExercises;

  const ExerciseListScreen({
    Key? key,
    required this.title,
    required this.topicId,
    this.initialExercises,
  }) : super(key: key);

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late List<ExerciseDetail> filteredExercises;
  List<ExerciseDetail> _currentSource = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Định nghĩa màu chủ đạo 1AB7B0
  static const Color primaryColor = Color(0xFF1AB7B0);

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.initialExercises ?? [];
  }

  void _runFilter(String query) {
    setState(() {
      final source = _currentSource;
      filteredExercises = source
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HandbookTopic?>(
      stream: HandbookFirestoreService().topicStream(widget.topicId),
      builder: (context, snapshot) {
        final topic = snapshot.data;
        final exercises =
            topic?.sections
                .firstWhere(
                  (s) => s.title == widget.title,
                  orElse: () => ContentSection(title: widget.title),
                )
                .exercises ??
            widget.initialExercises ??
            [];
        _currentSource = exercises;
        // keep current search filter but reset if source changed
        if (!_isSearching) filteredExercises = exercises;

        return Scaffold(
          backgroundColor:
              Colors.grey[50], // Nền hơi xám nhẹ để Card nổi bật hơn
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0, // Phẳng hóa AppBar cho hiện đại
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm bài tập...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: _runFilter,
                  )
                : Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      _runFilter('');
                    }
                  });
                },
              ),
            ],
          ),
          body: filteredExercises.isEmpty
              ? const Center(
                  child: Text(
                    'Không tìm thấy bài tập nào!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = filteredExercises[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: primaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ExerciseDetailScreen(exercise: exercise),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              // Ảnh đại diện bo góc (90x90)
                              Hero(
                                tag: exercise
                                    .name, // Hiệu ứng chuyển cảnh mượt mà
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    exercise.image,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Nội dung text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            primaryColor, // Đổi từ tím sang xanh
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.play_circle_outline,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Xem hướng dẫn chi tiết",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: primaryColor, // Đồng bộ màu xanh
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ), // end ListView.builder
        ); // end Scaffold
      }, // end builder
    );
  }
}
