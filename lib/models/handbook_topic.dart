import '../models/thuc_pham.dart';

/// Model for handbook topics/categories
class HandbookTopic {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<ContentSection> sections;
  final List<ThucPham>? foodList; // Danh sách thực phẩm tùy chọn
  final bool isSupplement;

  HandbookTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sections,
    this.foodList,
    this.isSupplement = false,
  });

  bool get isFoodList => foodList != null && foodList!.isNotEmpty;
}

class ExerciseDetail {
  final String name;
  final String image; // Ảnh đại diện ở danh sách ngoài
  final List<String> instructionImages; // Danh sách ảnh hướng dẫn (47-56)
  final String theory;
  final List<String> steps;

  ExerciseDetail({
    required this.name,
    required this.image,
    required this.instructionImages, // Thêm cái này
    this.theory = "",
    this.steps = const [],
  });
}

/// Content section within a topic - Đã loại bỏ hoàn toàn content
class ContentSection {
  final String title;
  final String? imageUrl;
  final List<ExerciseDetail>? exercises;
  final List<ThucPham>? foods;
  final bool isSupplement;
  ContentSection({
    required this.title,
    this.imageUrl,
    this.exercises,
    this.foods,
    this.isSupplement = false,
  });
}

/// Sample handbook data
class HandbookData {
  static final List<HandbookTopic> topics = [
    HandbookTopic(
      id: '1',
      title: 'Các bài tập',
      description: 'Exercise routines and training',
      imageUrl: 'assets/onboarding/18.jpg',
      sections: [
        ContentSection(
          title: 'Ngực',
          imageUrl: 'assets/onboarding/20.jpg',
          exercises: [
            ExerciseDetail(
              name: 'Barbell Bench Press',
              image: 'assets/onboarding/46.jpg',
              instructionImages: ['assets/onboarding/47.jpg'],
              theory:
                  'Đây là bài tập "ông vua" để xây dựng độ dày và sức mạnh tổng thể cho toàn bộ vùng cơ ngực, đặc biệt là ngực giữa.',
              steps: [
                'Nằm phẳng trên ghế, hai chân đặt vững trên sàn.',
                'Nắm thanh đòn rộng hơn vai, hạ từ từ xuống chạm nhẹ ngực giữa.',
                'Dùng cơ ngực đẩy mạnh thanh đòn lên vị trí ban đầu và thở ra.',
              ],
            ),
            ExerciseDetail(
              name: 'Dumbbell Bench Press',
              image: 'assets/onboarding/45.jpg',
              instructionImages: ['assets/onboarding/48.jpg'],
              theory:
                  'Sử dụng tạ đơn giúp cơ ngực hoạt động độc lập, khắc phục tình trạng lệch cơ và tăng biên độ chuyển động sâu hơn.',
              steps: [
                'Mỗi tay cầm một quả tạ đơn, nằm phẳng trên ghế.',
                'Hạ tạ xuống sát hai bên rìa ngực để cảm nhận cơ ngực căng ra.',
                'Ép cơ ngực đẩy tạ lên cao sao cho hai quả tạ gần chạm nhau.',
              ],
            ),
            ExerciseDetail(
              name: 'Incline Bench Press',
              image: 'assets/onboarding/44.jpg',
              instructionImages: ['assets/onboarding/49.jpg'],
              theory:
                  'Bài tập tập trung tối đa vào phần ngực trên, giúp lấp đầy vùng cơ sát xương quai xanh, tạo khuôn ngực cao.',
              steps: [
                'Chỉnh ghế dốc lên một góc khoảng 30-45 độ.',
                'Hạ thanh đòn (hoặc tạ đơn) xuống vị trí ngực trên.',
                'Đẩy tạ lên thẳng đứng và tập trung cảm nhận phần cơ phía trên.',
              ],
            ),
            ExerciseDetail(
              name: 'Decline Bench Press',
              image: 'assets/onboarding/43.jpg',
              instructionImages: ['assets/onboarding/50.jpg'],
              theory:
                  'Tác động mạnh vào phần ngực dưới và cạnh ngực, giúp tạo nét rõ ràng cho khuôn ngực phía dưới.',
              steps: [
                'Nằm trên ghế dốc xuống, chân móc chặt vào giá đỡ.',
                'Hạ tạ xuống vị trí ngực dưới (ngang xương ức).',
                'Đẩy tạ lên và giữ kiểm soát để tránh tạ rơi vào mặt.',
              ],
            ),
            ExerciseDetail(
              name: 'Machine Chest Press',
              image: 'assets/onboarding/42.jpg',
              instructionImages: ['assets/onboarding/51.jpg'],
              theory:
                  'Sử dụng máy giúp cố định quỹ đạo chuyển động, cực kỳ an toàn và hiệu quả để cô lập cơ ngực mà không lo rơi tạ.',
              steps: [
                'Điều chỉnh ghế sao cho tay cầm ngang với ngực.',
                'Đạp chân vững, đẩy tay cầm về phía trước hết mức.',
                'Thả tạ về chậm rãi để duy trì áp lực lên cơ ngực.',
              ],
            ),
            ExerciseDetail(
              name: 'Push up',
              image: 'assets/onboarding/41.jpg',
              instructionImages: ['assets/onboarding/52.jpg'],
              theory:
                  'Bài tập hít đất giúp phát triển sức mạnh bền bỉ và sự ổn định của khớp vai bằng chính trọng lượng cơ thể.',
              steps: [
                'Đặt hai tay rộng hơn vai, thân người tạo thành một đường thẳng.',
                'Hạ người xuống cho đến khi ngực gần chạm sàn.',
                'Gồng cơ ngực đẩy người lên vị trí cũ.',
              ],
            ),
            ExerciseDetail(
              name: 'DIP',
              image: 'assets/onboarding/40.jpg',
              instructionImages: ['assets/onboarding/53.jpg'],
              theory:
                  'Bài tập xà kép tác động sâu vào cạnh ngực dưới và cơ tay sau, giúp cơ ngực trông rộng và sắc nét hơn.',
              steps: [
                'Chống hai tay lên xà, hơi nghiêng người về phía trước.',
                'Hạ người xuống sâu cho đến khi thấy ngực căng nhẹ.',
                'Dùng sức ngực và tay sau đẩy người lên cao.',
              ],
            ),
            ExerciseDetail(
              name: 'Chest Fly',
              image: 'assets/onboarding/39.jpg',
              instructionImages: ['assets/onboarding/54.jpg'],
              theory:
                  'Đây là bài tập cô lập hoàn hảo để tạo rãnh ngực và kéo dãn các sợi cơ ngực theo chiều ngang.',
              steps: [
                'Nằm ngửa, hai tay cầm tạ đơn đưa thẳng lên trên.',
                'Mở rộng cánh tay sang hai bên như hình cánh cung (hơi cong khuỷu tay).',
                'Ép hai tay lại với nhau như đang ôm một thân cây lớn.',
              ],
            ),
            ExerciseDetail(
              name: 'Dumbbell Pull-Over',
              image: 'assets/onboarding/38.jpg',
              instructionImages: ['assets/onboarding/55.jpg'],
              theory:
                  'Bài tập đặc biệt giúp mở rộng lồng ngực và tác động vào cả cơ ngực lẫn cơ xô.',
              steps: [
                'Nằm ngang ghế, chỉ đặt phần vai lên ghế, tay cầm một quả tạ đơn.',
                'Hạ tạ ra phía sau đầu cho đến khi cảm thấy lồng ngực giãn ra.',
                'Kéo tạ ngược trở lại vị trí trước ngực.',
              ],
            ),
            ExerciseDetail(
              name: 'Machine Fly',
              image: 'assets/onboarding/37.jpg',
              instructionImages: ['assets/onboarding/56.jpg'],
              theory:
                  'Máy ép ngực giúp duy trì lực căng không đổi trong suốt chuyển động, rất tốt để làm "khô" cơ ngực.',
              steps: [
                'Ngồi thẳng lưng, nắm lấy tay cầm của máy.',
                'Ép hai cánh tay lại sát nhau ở trước mặt và giữ 1 giây.',
                'Mở tay ra thật chậm để cảm nhận cơ ngực bị kéo căng.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Lưng',
          imageUrl: 'assets/onboarding/21.jpg',
          exercises: [
            // 1. Deadlift
            ExerciseDetail(
              name: 'Deadlift',
              image: 'assets/onboarding/66.jpg',
              instructionImages: ['assets/onboarding/57.jpg'],
              theory:
                  'Đây là bài tập xây dựng sức mạnh tổng thể tốt nhất, tác động toàn bộ chuỗi cơ sau từ lưng dưới đến đùi sau.',
              steps: [
                'Đứng chân rộng bằng vai, thanh đòn nằm trên giữa bàn chân.',
                'Cúi người nắm thanh đòn, giữ lưng thẳng, hạ hông xuống.',
                'Gồng bụng, dùng lực chân và lưng kéo tạ lên thẳng đứng.',
                'Hạ tạ xuống kiểm soát, luôn giữ thanh đòn sát chân.',
              ],
            ),
            // 2. Bent-Over Row
            ExerciseDetail(
              name: 'Bent-Over Row',
              image: 'assets/onboarding/67.jpg',
              instructionImages: ['assets/onboarding/58.jpg'],
              theory:
                  'Vua của các bài tập xây dựng độ dày cho lưng giữa, giúp phần lưng trông khỏe khoắn và dày dặn hơn.',
              steps: [
                'Gập người khoảng 45 độ, lưng thẳng, hai tay cầm thanh đòn.',
                'Kéo thanh đòn về phía bụng trên, ép chặt bả vai.',
                'Hạ tạ từ từ để cảm nhận sự co giãn của cơ lưng.',
              ],
            ),
            // 3. Pull Up
            ExerciseDetail(
              name: 'Pull Up',
              image: 'assets/onboarding/68.jpg',
              instructionImages: ['assets/onboarding/59.jpg'],
              theory:
                  'Bài tập kinh điển để phát triển độ rộng của lưng (V-taper), tập trung tối đa vào cơ xô và cơ tròn.',
              steps: [
                'Nắm xà đơn lòng bàn tay hướng ra ngoài, rộng hơn vai.',
                'Ưỡn ngực, dùng cơ xô kéo người lên đến khi cằm vượt xà.',
                'Giữ 1 giây ở đỉnh, sau đó hạ xuống chậm rãi.',
              ],
            ),
            // 4. T-Bar Row
            ExerciseDetail(
              name: 'T-Bar Row',
              image: 'assets/onboarding/69.jpg',
              instructionImages: ['assets/onboarding/60.jpg'],
              theory:
                  'Tập trung vào phần lưng giữa và cơ trám, giúp tạo chi tiết và độ dày ở khu vực gần cột sống.',
              steps: [
                'Đứng chân rộng bằng vai, kẹp thanh đòn giữa hai chân.',
                'Nắm tay cầm, kéo tạ về phía bụng, giữ khuỷu tay sát sườn.',
                'Lưng luôn giữ thẳng, không dùng đà của cơ thể.',
              ],
            ),
            // 5. Seated Row
            ExerciseDetail(
              name: 'Seated Row',
              image: 'assets/onboarding/70.jpg',
              instructionImages: ['assets/onboarding/61.jpg'],
              theory:
                  'Bài tập kéo cáp giúp duy trì lực căng liên tục lên cơ lưng giữa và cơ xô trong suốt chuyển động.',
              steps: [
                'Ngồi vào máy, đặt chân lên giá đỡ, giữ lưng thẳng.',
                'Kéo tay cầm về phía eo, ưỡn ngực và ép chặt xương bả vai.',
                'Nhả tạ ra từ từ, cảm nhận cơ xô được kéo giãn.',
              ],
            ),
            // 6. Single-Arm Smith Machine Row
            ExerciseDetail(
              name: 'Single-Arm Smith Machine Row',
              image: 'assets/onboarding/71.jpg',
              instructionImages: ['assets/onboarding/62.jpg'],
              theory:
                  'Sử dụng máy Smith giúp cố định quỹ đạo, cực kỳ an toàn để cô lập từng bên cơ lưng.',
              steps: [
                'Đứng bên cạnh máy Smith, nắm thanh đòn bằng một tay.',
                'Kéo thanh đòn lên theo phương thẳng đứng hướng về phía hông.',
                'Duy trì tư thế lưng thẳng và không xoay người.',
              ],
            ),
            // 7. Lat Pull-Down
            ExerciseDetail(
              name: 'Lat Pull-Down',
              image: 'assets/onboarding/72.jpg',
              instructionImages: ['assets/onboarding/63.jpg'],
              theory:
                  'Giải pháp thay thế Pull-up hiệu quả, cho phép kiểm soát áp lực lên cơ xô bằng cách điều chỉnh khối lượng tạ.',
              steps: [
                'Ngồi vào máy, nắm thanh kéo rộng hơn vai.',
                'Kéo thanh đòn xuống sát ngực trên, hơi ngả người ra sau.',
                'Đưa thanh đòn lên chậm rãi, giữ lực căng liên tục.',
              ],
            ),
            // 8. Single-Arm Dumbbell Row
            ExerciseDetail(
              name: 'Single-Arm Dumbbell Row',
              image: 'assets/onboarding/73.jpg',
              instructionImages: ['assets/onboarding/64.jpg'],
              theory:
                  'Tập độc lập từng bên giúp khắc phục lệch cơ lưng và tăng biên độ chuyển động kéo sâu hơn.',
              steps: [
                'Một tay chống lên ghế, tay kia cầm tạ đơn.',
                'Kéo tạ lên sát hông, tập trung dùng cơ xô kéo thay vì tay trước.',
                'Hạ tạ xuống hết cỡ để cơ được kéo dãn hoàn toàn.',
              ],
            ),
            // 9. Chest-Supported Row
            ExerciseDetail(
              name: 'Chest-Supported Row',
              image: 'assets/onboarding/74.jpg',
              instructionImages: ['assets/onboarding/65.jpg'],
              theory:
                  'Loại bỏ hoàn toàn việc dùng đà từ lưng dưới bằng cách tựa ngực vào ghế, giúp cô lập cơ lưng trên.',
              steps: [
                'Nằm úp ngực lên ghế dốc khoảng 30 độ.',
                'Hai tay cầm tạ kéo lên theo phương thẳng đứng.',
                'Ép chặt bả vai và giữ 1 giây ở vị trí cao nhất.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Chân',
          imageUrl: 'assets/onboarding/23.jpg',
          exercises: [
            // 1. Barbell Back Squat
            ExerciseDetail(
              name: 'Barbell Back Squat',
              image: 'assets/onboarding/81.jpg',
              instructionImages: ['assets/onboarding/75.jpg'],
              theory:
                  'Được mệnh danh là "ông vua" của các bài tập chân, giúp phát triển sức mạnh toàn diện cho đùi trước, mông và lưng dưới.',
              steps: [
                'Đặt thanh đòn trên cơ cầu vai, đứng chân rộng bằng vai.',
                'Hạ hông xuống như đang ngồi ghế cho đến khi đùi song song với sàn.',
                'Giữ lưng thẳng, đẩy mạnh bằng gót chân để đứng dậy.',
              ],
            ),
            // 2. Barbell Front Squat
            ExerciseDetail(
              name: 'Barbell Front Squat',
              image: 'assets/onboarding/82.jpg',
              instructionImages: ['assets/onboarding/76.jpg'],
              theory:
                  'Đặt thanh đòn phía trước ngực giúp tập trung áp lực tối đa vào cơ đùi trước (Quads) và giảm tải cho cột sống.',
              steps: [
                'Đặt thanh đòn lên phần vai trước, giữ khuỷu tay cao.',
                'Hạ người xuống sâu trong khi giữ thân người thẳng đứng.',
                'Gồng chắc cơ trọng tâm (core) để giữ thăng bằng và đẩy lên.',
              ],
            ),
            // 3. Split Squat
            ExerciseDetail(
              name: 'Split Squat',
              image: 'assets/onboarding/83.jpg',
              instructionImages: ['assets/onboarding/77.jpg'],
              theory:
                  'Bài tập tác động từng chân một, giúp khắc phục lệch cơ và cải thiện khả năng thăng bằng.',
              steps: [
                'Đứng ở tư thế một chân trước một chân sau.',
                'Hạ đầu gối chân sau xuống gần chạm sàn, chân trước tạo góc 90 độ.',
                'Dùng lực chân trước đẩy người lên vị trí ban đầu.',
              ],
            ),
            // 4. Hack Squat
            ExerciseDetail(
              name: 'Hack Squat',
              image: 'assets/onboarding/84.jpg',
              instructionImages: ['assets/onboarding/78.jpg'],
              theory:
                  'Sử dụng máy tập giúp cố định lưng, cho phép bạn tập trung hoàn toàn vào việc cô lập cơ đùi trước một cách an toàn.',
              steps: [
                'Tựa lưng sát vào tấm đệm máy, chân đặt lên bàn đạp.',
                'Mở khóa an toàn, hạ người xuống cho đến khi đùi vuông góc với bắp chân.',
                'Đẩy mạnh bàn đạp lên nhưng không khóa khớp gối.',
              ],
            ),
            // 5. Leg Press
            ExerciseDetail(
              name: 'Leg Press',
              image: 'assets/onboarding/85.jpg',
              instructionImages: ['assets/onboarding/79.jpg'],
              theory:
                  'Bài tập đạp giá giúp xây dựng khối lượng cơ bắp chân cực lớn mà không gây áp lực lên lưng dưới.',
              steps: [
                'Ngồi vào máy, đặt chân lên bàn đạp rộng bằng vai.',
                'Hạ tạ xuống chậm rãi cho đến khi đầu gối gần ngực.',
                'Đẩy tạ lên mạnh mẽ nhưng chú ý không duỗi thẳng hoàn toàn đầu gối.',
              ],
            ),
            // 6. Leg Curl
            ExerciseDetail(
              name: 'Leg Curl',
              image: 'assets/onboarding/86.jpg',
              instructionImages: ['assets/onboarding/80.jpg'],
              theory:
                  'Bài tập cô lập tốt nhất cho cơ đùi sau (Hamstrings), giúp cân bằng sức mạnh với cơ đùi trước.',
              steps: [
                'Nằm hoặc ngồi vào máy tùy loại, đặt gót chân dưới thanh đệm.',
                'Cuốn chân lên tối đa về phía mông, giữ 1 giây để cảm nhận cơ co thắt.',
                'Duỗi chân ra chậm rãi để hoàn thành một lần lặp.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Cơ mông',
          imageUrl:
              'assets/onboarding/28.jpg', // Cập nhật lại đúng index ảnh chủ đề mông của bạn
          exercises: [
            // 1. Deadlift (biến thể tập trung mông)
            ExerciseDetail(
              name: 'Deadlift',
              image: 'assets/onboarding/90.jpg',
              instructionImages: ['assets/onboarding/87.jpg'],
              theory:
                  'Deadlift không chỉ là bài tập lưng mà còn là bài tập xây dựng cơ mông cực mạnh. Khi thực hiện đúng, sức mạnh bộc phát từ mông giúp bạn nâng được mức tạ lớn nhất.',
              steps: [
                'Đứng chân rộng bằng vai, thanh đòn sát ống chân.',
                'Hạ hông, nắm xà, giữ lưng thẳng và đẩy ngực lên.',
                'Dùng lực cơ mông và đùi đẩy người đứng thẳng dậy.',
                'Gồng chặt mông ở vị trí cao nhất trước khi hạ tạ xuống.',
              ],
            ),
            // 2. Lunge
            ExerciseDetail(
              name: 'Lunge',
              image: 'assets/onboarding/91.jpg',
              instructionImages: ['assets/onboarding/88.jpg'],
              theory:
                  'Lunge giúp định hình hình dáng cơ mông và cải thiện sự ổn định của khớp hông thông qua chuyển động bước đơn.',
              steps: [
                'Đứng thẳng, bước một chân về phía trước một khoảng lớn.',
                'Hạ trọng tâm sao cho cả hai đầu gối đều tạo góc 90 độ.',
                'Giữ thân người thẳng, dùng gót chân trước đẩy người trở lại vị trí cũ.',
              ],
            ),
            // 3. Romanian Deadlift (RDL)
            ExerciseDetail(
              name: 'Romanian Deadlift',
              image: 'assets/onboarding/92.jpg',
              instructionImages: ['assets/onboarding/89.jpg'],
              theory:
                  'RDL tập trung tối đa vào việc kéo giãn cơ mông và đùi sau dưới áp lực của tạ, giúp cơ bắp săn chắc và sắc nét.',
              steps: [
                'Đứng thẳng, tay cầm thanh đòn hoặc tạ đơn trước đùi.',
                'Đẩy hông ra sau tối đa, hạ tạ xuống dọc chân (đầu gối chỉ hơi trùng).',
                'Hạ đến khi cảm thấy cơ mông căng hết mức thì dừng lại.',
                'Dùng cơ mông kéo người đứng dậy và ép chặt mông ở đỉnh.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Cơ delta',
          imageUrl:
              'assets/onboarding/19.jpg', // Cập nhật đúng index ảnh chủ đề vai của bạn
          exercises: [
            // 1. Push-Press
            ExerciseDetail(
              name: 'Push-Press',
              image: 'assets/onboarding/102.jpg',
              instructionImages: ['assets/onboarding/93.jpg'],
              theory:
                  'Bài tập sức mạnh bùng nổ, kết hợp lực đẩy của chân để nâng mức tạ lớn hơn, giúp phát triển toàn bộ vùng vai và cơ tay sau.',
              steps: [
                'Đứng thẳng, thanh đòn đặt trên vai trước.',
                'Hơi chùng gối lấy đà rồi đẩy mạnh thanh đòn lên cao.',
                'Khóa tay ở đỉnh và hạ tạ xuống vai một cách kiểm soát.',
              ],
            ),
            // 2. Rear Delt Row
            ExerciseDetail(
              name: 'Rear Delt Row',
              image: 'assets/onboarding/103.jpg',
              instructionImages: ['assets/onboarding/94.jpg'],
              theory:
                  'Tập trung vào phần vai sau, giúp vai trông tròn trịa và cải thiện tư thế đứng, tránh tình trạng vai bị đổ về phía trước.',
              steps: [
                'Cúi người hoặc nằm úp trên ghế dốc, tay cầm tạ đơn.',
                'Kéo tạ lên sao cho khuỷu tay mở rộng sang hai bên.',
                'Ép chặt phần vai sau ở đỉnh động tác.',
              ],
            ),
            // 3. Seated Dumbbell Press
            ExerciseDetail(
              name: 'Seated Dumbbell Press',
              image: 'assets/onboarding/104.jpg',
              instructionImages: ['assets/onboarding/95.jpg'],
              theory:
                  'Bài tập cơ bản tốt nhất để xây dựng khối lượng cơ vai. Tập ngồi giúp cố định lưng và tập trung hoàn toàn vào vai.',
              steps: [
                'Ngồi thẳng lưng trên ghế, mỗi tay cầm một quả tạ đơn đặt ngang tai.',
                'Đẩy tạ lên cao theo đường vòng cung cho đến khi hai quả tạ gần chạm nhau.',
                'Hạ tạ xuống chậm rãi đến khi tay ngang vai.',
              ],
            ),
            // 4. Seated Barbell Press
            ExerciseDetail(
              name: 'Seated Barbell Press',
              image: 'assets/onboarding/105.jpg',
              instructionImages: ['assets/onboarding/96.jpg'],
              theory:
                  'Cho phép bạn sử dụng mức tạ nặng hơn so với tạ đơn, tác động mạnh mẽ vào phần vai trước và vai giữa.',
              steps: [
                'Ngồi vào giá đỡ, nắm thanh đòn rộng hơn vai.',
                'Hạ thanh đòn xuống sát ngực trên (phía trước mặt).',
                'Dùng lực vai đẩy thanh đòn lên thẳng đứng.',
              ],
            ),
            // 5. Upright Row
            ExerciseDetail(
              name: 'Upright Row',
              image: 'assets/onboarding/106.jpg',
              instructionImages: ['assets/onboarding/97.jpg'],
              theory:
                  'Bài tập tuyệt vời để phát triển cầu vai (Traps) và phần vai giữa, tạo độ rộng cho khung vai.',
              steps: [
                'Đứng thẳng, hai tay cầm thanh đòn hoặc tạ đơn đặt trước đùi.',
                'Kéo tạ lên thẳng đứng sát thân người đến khi tay ngang ngực.',
                'Giữ khuỷu tay luôn cao hơn cổ tay trong suốt chuyển động.',
              ],
            ),
            // 6. Arnold Press
            ExerciseDetail(
              name: 'Arnold Press',
              image: 'assets/onboarding/107.jpg',
              instructionImages: ['assets/onboarding/98.jpg'],
              theory:
                  'Biến thể nổi tiếng giúp tác động vào cả 3 đầu cơ vai (trước, giữa, sau) thông qua chuyển động xoay khớp vai.',
              steps: [
                'Ngồi thẳng, cầm tạ trước ngực với lòng bàn tay hướng về phía mình.',
                'Vừa đẩy tạ lên vừa xoay cổ tay ra ngoài.',
                'Khi ở đỉnh, lòng bàn tay hướng về phía trước.',
              ],
            ),
            // 7. Rear Delt Fly
            ExerciseDetail(
              name: 'Rear Delt Fly',
              image: 'assets/onboarding/108.jpg',
              instructionImages: ['assets/onboarding/99.jpg'],
              theory:
                  'Bài tập cô lập hoàn hảo cho vai sau, giúp "cắt nét" và tạo độ tách biệt giữa vai và lưng.',
              steps: [
                'Cúi người hoặc ngồi, hai tay cầm tạ đơn hạ thấp.',
                'Mở rộng tay sang hai bên như cánh chim, giữ khuỷu tay hơi cong.',
                'Hạ tạ xuống chậm rãi để duy trì áp lực lên cơ.',
              ],
            ),
            // 8. Lateral Raise
            ExerciseDetail(
              name: 'Lateral Raise',
              image: 'assets/onboarding/109.jpg',
              instructionImages: ['assets/onboarding/100.jpg'],
              theory:
                  'Bài tập "thần thánh" để tạo độ rộng cho vai, tác động trực tiếp vào bó cơ vai giữa.',
              steps: [
                'Đứng thẳng, tay cầm tạ đơn đặt hai bên hông.',
                'Nâng tay sang ngang cho đến khi tay song song với sàn.',
                'Hơi nghiêng tạ về phía trước (như đang rót nước) để tối ưu lực vào vai giữa.',
              ],
            ),
            // 9. Front Raise
            ExerciseDetail(
              name: 'Front Raise',
              image: 'assets/onboarding/110.jpg',
              instructionImages: ['assets/onboarding/101.jpg'],
              theory:
                  'Tập trung cô lập vào bó cơ vai trước, giúp phần trước vai trông đầy đặn và săn chắc.',
              steps: [
                'Đứng thẳng, tay cầm tạ đơn đặt trước đùi.',
                'Nâng tạ thẳng về phía trước cho đến khi tay ngang mắt.',
                'Hạ tạ xuống chậm rãi, không dùng đà của cơ thể.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Cơ tay trước',
          imageUrl: 'assets/onboarding/27.jpg',
          exercises: [
            // 1. Barbell Or EZ-Bar Curl
            ExerciseDetail(
              name: 'Barbell Or EZ-Bar Curl',
              image: 'assets/onboarding/138.jpg',
              instructionImages: ['assets/onboarding/128.jpg'],
              theory:
                  'Bài tập xây dựng khối lượng cơ bắp tay tốt nhất. Sử dụng thanh EZ giúp giảm áp lực lên cổ tay so với thanh đòn thẳng.',
              steps: [
                'Đứng thẳng, nắm thanh đòn lòng bàn tay hướng ra ngoài.',
                'Cuốn thanh đòn lên phía ngực, giữ khuỷu tay sát sườn.',
                'Hạ tạ xuống chậm rãi để cảm nhận cơ bắp bị kéo căng.',
              ],
            ),
            // 2. Cable Curl
            ExerciseDetail(
              name: 'Cable Curl',
              image: 'assets/onboarding/139.jpg',
              instructionImages: ['assets/onboarding/129.jpg'],
              theory:
                  'Máy kéo cáp cung cấp lực căng liên tục lên bắp tay trong suốt toàn bộ biên độ chuyển động.',
              steps: [
                'Đứng đối diện máy cáp, tay cầm thanh kéo ở vị trí thấp.',
                'Cuốn cáp lên tương tự như tập tạ đòn.',
                'Kiểm soát lực khi hạ cáp xuống, không để tạ va mạnh.',
              ],
            ),
            // 3. Dumbbell Curl
            ExerciseDetail(
              name: 'Dumbbell Curl',
              image: 'assets/onboarding/140.jpg',
              instructionImages: ['assets/onboarding/130.jpg'],
              theory:
                  'Tập tạ đơn giúp khắc phục lệch cơ và cho phép cổ tay xoay linh hoạt để tác động sâu hơn vào bắp tay.',
              steps: [
                'Đứng hoặc ngồi, mỗi tay cầm một quả tạ đơn.',
                'Vừa cuốn tạ lên vừa xoay lòng bàn tay hướng lên trên.',
                'Bóp chặt bắp tay ở đỉnh động tác.',
              ],
            ),
            // 4. Chin Up
            ExerciseDetail(
              name: 'Chin Up',
              image: 'assets/onboarding/141.jpg',
              instructionImages: ['assets/onboarding/131.jpg'],
              theory:
                  'Biến thể hít xà ngửa tay không chỉ tập lưng mà còn là bài tập phức hợp cực mạnh cho tay trước.',
              steps: [
                'Nắm xà đơn lòng bàn tay hướng về phía mình, rộng bằng vai.',
                'Dùng bắp tay và xô kéo người lên đến khi cằm vượt xà.',
                'Hạ người xuống từ từ để tận dụng áp lực.',
              ],
            ),
            // 5. Reverse-Grip Barbell Row
            ExerciseDetail(
              name: 'Reverse-Grip Barbell Row',
              image: 'assets/onboarding/142.jpg',
              instructionImages: ['assets/onboarding/132.jpg'],
              theory:
                  'Chèo tạ đòn ngược tay giúp tăng cường sự tham gia của bắp tay trong khi vẫn xây dựng được độ dày của lưng.',
              steps: [
                'Cúi người 45 độ, nắm thanh đòn lòng bàn tay hướng về trước.',
                'Kéo thanh đòn về phía bụng dưới.',
                'Ép bả vai và bóp chặt bắp tay khi tạ ở gần người.',
              ],
            ),
            // 6. Hammer Curl
            ExerciseDetail(
              name: 'Hammer Curl',
              image: 'assets/onboarding/143.jpg',
              instructionImages: ['assets/onboarding/133.jpg'],
              theory:
                  'Kiểu cuốn tạ "búa" tập trung vào cơ cánh tay (Brachialis), giúp bắp tay trông rộng và dày hơn khi nhìn ngang.',
              steps: [
                'Cầm tạ đơn dọc theo thân người, lòng bàn tay hướng vào nhau.',
                'Cuốn tạ lên như đang cầm búa, giữ cố định cổ tay.',
                'Hạ tạ xuống một cách kiểm soát.',
              ],
            ),
            // 7. Incline Curl
            ExerciseDetail(
              name: 'Incline Curl',
              image: 'assets/onboarding/144.jpg',
              instructionImages: ['assets/onboarding/134.jpg'],
              theory:
                  'Nằm trên ghế dốc giúp kéo giãn đầu dài của bắp tay, tạo độ dài và thẩm mỹ cho bắp tay.',
              steps: [
                'Nằm ngửa trên ghế dốc khoảng 45 độ, tay cầm tạ đơn buông thẳng.',
                'Giữ khuỷu tay phía sau thân người và cuốn tạ lên.',
                'Cảm nhận sự kéo căng cực đại ở phần dưới động tác.',
              ],
            ),
            // 8. Concentration Curl
            ExerciseDetail(
              name: 'Concentration Curl',
              image: 'assets/onboarding/145.jpg',
              instructionImages: ['assets/onboarding/135.jpg'],
              theory:
                  'Bài tập cô lập đỉnh cơ, giúp bắp tay có độ cao "nhọn" và tách biệt rõ rệt.',
              steps: [
                'Ngồi trên ghế, tỳ khuỷu tay vào mặt trong của đùi chân cùng bên.',
                'Cuốn tạ lên và xoay nhẹ cổ tay ra ngoài.',
                'Tập trung hoàn toàn ý nghĩ vào sự co bóp của bắp tay.',
              ],
            ),
            // 9. Preacher Curl
            ExerciseDetail(
              name: 'Preacher Curl',
              image: 'assets/onboarding/146.jpg',
              instructionImages: ['assets/onboarding/136.jpg'],
              theory:
                  'Tập trên ghế dốc (ghế Scott) loại bỏ hoàn toàn việc dùng đà, giúp cô lập bắp tay dưới cực tốt.',
              steps: [
                'Đặt cánh tay lên đệm ghế dốc, nắm thanh đòn hoặc tạ đơn.',
                'Cuốn tạ lên cao nhất có thể mà không nhấc tay khỏi đệm.',
                'Hạ tạ xuống thật chậm để cảm nhận độ căng bắp tay dưới.',
              ],
            ),
            // 10. Drag Curl
            ExerciseDetail(
              name: 'Drag Curl',
              image: 'assets/onboarding/147.jpg',
              instructionImages: ['assets/onboarding/137.jpg'],
              theory:
                  'Thay vì cuốn vòng cung, bạn kéo tạ trượt sát theo thân người để cô lập tối đa bắp tay và giảm lực vai.',
              steps: [
                'Đứng thẳng, nắm thanh đòn sát đùi.',
                'Kéo thanh đòn đi thẳng lên, đưa khuỷu tay ra phía sau.',
                'Giữ tạ luôn sát vào áo trong suốt chuyển động.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Cơ tay sau',
          imageUrl: 'assets/onboarding/26.jpg',
          exercises: [
            // 1. Skullcrusher
            ExerciseDetail(
              name: 'Skullcrusher',
              image: 'assets/onboarding/158.jpg',
              instructionImages: ['assets/onboarding/149.jpg'],
              theory:
                  'Bài tập cô lập tốt nhất để phát triển đầu dài (long head) của tay sau, giúp bắp tay trông dày hơn khi nhìn từ phía sau.',
              steps: [
                'Nằm trên ghế phẳng, hai tay cầm thanh EZ đưa thẳng lên trước mặt.',
                'Gập khuỷu tay hạ thanh đòn về phía trán (giữ bắp tay cố định).',
                'Dùng lực tay sau đẩy thanh đòn trở lại vị trí ban đầu.',
              ],
            ),
            // 2. Close-Grip Bench Press
            ExerciseDetail(
              name: 'Close-Grip Bench Press',
              image: 'assets/onboarding/159.jpg',
              instructionImages: ['assets/onboarding/150.jpg'],
              theory:
                  'Biến thể đẩy ngực hẹp tay giúp bạn tập được với mức tạ nặng, xây dựng sức mạnh cực đại cho toàn bộ tay sau.',
              steps: [
                'Nằm trên ghế, nắm thanh đòn với khoảng cách hai tay hẹp hơn vai.',
                'Hạ thanh đòn xuống ngực dưới, giữ khuỷu tay sát thân người.',
                'Đẩy mạnh thanh đòn lên và ép chặt cơ tay sau ở đỉnh.',
              ],
            ),
            // 3. Triceps Dip
            ExerciseDetail(
              name: 'Triceps Dip',
              image: 'assets/onboarding/160.jpg',
              instructionImages: ['assets/onboarding/151.jpg'],
              theory:
                  'Bài tập xà kép tập trung vào tay sau bằng cách giữ thân người thẳng đứng, giúp tăng khối lượng cơ bắp tay sau nhanh chóng.',
              steps: [
                'Chống người lên xà kép, thân người giữ thẳng (không nghiêng như tập ngực).',
                'Hạ người xuống cho đến khi cánh tay song song với mặt đất.',
                'Đẩy người lên mạnh mẽ và khóa nhẹ khuỷu tay ở đỉnh.',
              ],
            ),
            // 4. Bench Dip
            ExerciseDetail(
              name: 'Bench Dip',
              image: 'assets/onboarding/161.jpg',
              instructionImages: ['assets/onboarding/152.jpg'],
              theory:
                  'Bài tập đơn giản nhưng hiệu quả cao, có thể tập luyện ở bất cứ đâu với một chiếc ghế phẳng.',
              steps: [
                'Đặt hai tay lên mép ghế, chân duỗi thẳng trước mặt.',
                'Hạ hông xuống thấp cho đến khi tay sau căng ra.',
                'Dùng lực tay sau đẩy người lên cao nhất có thể.',
              ],
            ),
            // 5. Triceps Machine Dip
            ExerciseDetail(
              name: 'Triceps Machine Dip',
              image: 'assets/onboarding/162.jpg',
              instructionImages: ['assets/onboarding/153.jpg'],
              theory:
                  'Máy tập mô phỏng động tác xà kép nhưng cho phép kiểm soát mức tạ dễ dàng, phù hợp cho mọi cấp độ.',
              steps: [
                'Ngồi vào máy, nắm chặt tay cầm hai bên.',
                'Đẩy tay cầm xuống thẳng đứng cho đến khi tay duỗi thẳng hoàn toàn.',
                'Nhả tạ lên chậm rãi để duy trì áp lực lên cơ.',
              ],
            ),
            // 6. Dumbbell Overhead Triceps Extension
            ExerciseDetail(
              name: 'Dumbbell Overhead Extension',
              image: 'assets/onboarding/163.jpg',
              instructionImages: ['assets/onboarding/154.jpg'],
              theory:
                  'Nâng tạ qua đầu giúp kéo dãn đầu dài của tay sau một cách tối đa, tạo độ thẩm mỹ cho bắp tay.',
              steps: [
                'Ngồi hoặc đứng, hai tay cầm một quả tạ đơn đưa thẳng qua đầu.',
                'Gập khuỷu tay hạ tạ ra sau gáy cho đến khi cảm thấy cơ căng hết mức.',
                'Đẩy tạ ngược trở lại vị trí thẳng đứng.',
              ],
            ),
            // 7. Cable Overhead Extension With Rope
            ExerciseDetail(
              name: 'Cable Overhead Extension With Rope',
              image: 'assets/onboarding/164.jpg',
              instructionImages: ['assets/onboarding/155.jpg'],
              theory:
                  'Sử dụng dây thừng với máy cáp giúp duy trì lực căng liên tục và cho phép cổ tay xoay tự nhiên.',
              steps: [
                'Quay lưng lại với máy cáp, cầm dây thừng kéo qua đầu.',
                'Bước một chân về phía trước để tạo thế đứng vững chắc.',
                'Đẩy dây thừng về phía trước và mở rộng hai đầu dây ở đỉnh động tác.',
              ],
            ),
            // 8. Single-Arm Cable Kick-Back
            ExerciseDetail(
              name: 'Single-Arm Cable Kick-Back',
              image: 'assets/onboarding/165.jpg',
              instructionImages: ['assets/onboarding/156.jpg'],
              theory:
                  'Bài tập cô lập tuyệt vời để tạo độ nét và tách biệt rõ rệt giữa các đầu cơ tay sau.',
              steps: [
                'Cúi người song song với sàn, một tay cầm cáp (không dùng tay cầm).',
                'Giữ bắp tay sát sườn, chỉ chuyển động cẳng tay ra sau.',
                'Gồng chặt tay sau khi tay duỗi thẳng hoàn toàn.',
              ],
            ),
            // 9. Cable Push Down
            ExerciseDetail(
              name: 'Cable Push Down',
              image: 'assets/onboarding/166.jpg',
              instructionImages: ['assets/onboarding/157.jpg'],
              theory:
                  'Bài tập phổ biến nhất để làm "khô" cơ tay sau, tác động mạnh vào đầu ngoài (lateral head), tạo hình khối chữ V ngược.',
              steps: [
                'Đứng đối diện máy cáp, nắm thanh đòn hoặc dây thừng.',
                'Ép khuỷu tay vào sát sườn, đẩy tạ xuống cho đến khi tay thẳng.',
                'Thả tạ lên chậm rãi cho đến khi tay tạo góc 90 độ.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Cẳng tay',
          imageUrl: 'assets/onboarding/30.jpg',
          exercises: [
            // 1. Palms-up wrist curl
            ExerciseDetail(
              name: 'Palms-up Wrist Curl',
              image: 'assets/onboarding/167.jpg',
              instructionImages: ['assets/onboarding/170.jpg'],
              theory:
                  'Bài tập cô lập tốt nhất để phát triển phần cơ gập của cẳng tay, giúp cẳng tay trông dày và khỏe khoắn hơn.',
              steps: [
                'Đặt cẳng tay lên đùi hoặc ghế phẳng, lòng bàn tay hướng lên trên, cổ tay nằm ngoài mép ghế.',
                'Hạ tạ xuống từ từ để kéo giãn cơ cẳng tay.',
                'Chỉ dùng cổ tay cuộn tạ lên cao nhất có thể và ép chặt cơ.',
              ],
            ),
            // 2. Concentration Curls (Biến thể tập trung tay trước & cẳng tay)
            ExerciseDetail(
              name: 'Concentration Curls',
              image: 'assets/onboarding/168.jpg',
              instructionImages: ['assets/onboarding/171.jpg'],
              theory:
                  'Ngoài việc xây dựng đỉnh bắp tay, bài tập này khi giữ cổ tay ổn định sẽ tạo áp lực rất lớn lên cơ cánh tay quay (brachioradialis) ở cẳng tay.',
              steps: [
                'Ngồi trên ghế, tựa khuỷu tay vào mặt trong đùi.',
                'Cuốn tạ lên chậm rãi, tập trung cảm nhận sự co bóp của cả bắp tay và cẳng tay.',
                'Giữ cổ tay thẳng, không để tạ kéo gập cổ tay xuống.',
              ],
            ),
            // 3. Bicep Curls (Hammer Grip - Biến thể cho cẳng tay)
            ExerciseDetail(
              name: 'Bicep Curls (Hammer)',
              image: 'assets/onboarding/169.jpg',
              instructionImages: ['assets/onboarding/172.jpg'],
              theory:
                  'Biến thể cầm tạ dọc (Hammer) là cách hiệu quả nhất để kết nối sức mạnh giữa tay trước và cẳng tay, giúp cánh tay phát triển đồng đều.',
              steps: [
                'Đứng thẳng, tay cầm tạ đơn dọc theo thân người (lòng bàn tay hướng vào nhau).',
                'Cuốn tạ lên như đang đóng búa.',
                'Hạ tạ chậm để tận dụng lực kháng, giúp cẳng tay săn chắc hơn.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Cơ bụng',
          imageUrl: 'assets/onboarding/29.jpg',
          exercises: [
            // 1. Hanging Knee Raise
            ExerciseDetail(
              name: 'Hanging Knee Raise',
              image: 'assets/onboarding/111.jpg',
              instructionImages: ['assets/onboarding/127.jpg'],
              theory:
                  'Bài tập tuyệt vời để tác động vào phần bụng dưới và cơ gập hông, giúp làm phẳng vùng bụng dưới hiệu quả.',
              steps: [
                'Treo người trên xà đơn, tay duỗi thẳng.',
                'Dùng cơ bụng kéo đầu gối lên cao nhất có thể về phía ngực.',
                'Hạ chân xuống chậm rãi, tránh để người bị đung đưa.',
              ],
            ),
            // 2. Machine Crunch
            ExerciseDetail(
              name: 'Machine Crunch',
              image: 'assets/onboarding/116.jpg',
              instructionImages: ['assets/onboarding/125.jpg'],
              theory:
                  'Sử dụng máy giúp cô lập cơ bụng hoàn toàn và cho phép tăng thêm tạ để các múi bụng dày hơn.',
              steps: [
                'Ngồi vào máy, đặt chân vào giá đỡ và nắm lấy tay cầm.',
                'Thở ra, cuộn người về phía trước bằng cách ép chặt cơ bụng.',
                'Hít vào và trở lại vị trí cũ một cách kiểm soát.',
              ],
            ),
            // 3. Pallof Press
            ExerciseDetail(
              name: 'Pallof Press',
              image: 'assets/onboarding/115.jpg',
              instructionImages: ['assets/onboarding/124.jpg'],
              theory:
                  'Bài tập chống xoay người, cực kỳ tốt để xây dựng sự ổn định cho cơ trọng tâm (Core) và cơ bụng xiên.',
              steps: [
                'Đứng vuông góc với máy cáp, hai tay giữ tay cầm trước ngực.',
                'Đẩy tay cầm thẳng ra trước mặt và giữ cố định trong 2-3 giây.',
                'Chống lại lực kéo của cáp để không cho thân người bị xoay.',
              ],
            ),
            // 4. Cable Crunch
            ExerciseDetail(
              name: 'Cable Crunch',
              image: 'assets/onboarding/114.jpg',
              instructionImages: ['assets/onboarding/123.jpg'],
              theory:
                  'Bài tập "quỳ lạy" bằng cáp giúp duy trì lực căng liên tục lên toàn bộ nhóm cơ bụng.',
              steps: [
                'Quỳ dưới máy cáp, hai tay nắm dây thừng đặt hai bên đầu.',
                'Cuộn người xuống, đưa khuỷu tay về phía đầu gối.',
                'Ép chặt bụng ở vị trí thấp nhất và nhả ra chậm rãi.',
              ],
            ),
            // 5. Decline Crunch
            ExerciseDetail(
              name: 'Decline Crunch',
              image: 'assets/onboarding/122.jpg',
              instructionImages: ['assets/onboarding/122.jpg'],
              theory:
                  'Thực hiện trên ghế dốc xuống làm tăng biên độ chuyển động và độ khó cho cơ bụng trên.',
              steps: [
                'Nằm trên ghế dốc, móc chân vào giá đỡ.',
                'Gập người lên nhưng không cần lên quá cao để giữ lực vào bụng thay vì lưng.',
                'Hạ người xuống nhưng không để lưng chạm hẳn vào ghế.',
              ],
            ),
            // 6. Russian Twist
            ExerciseDetail(
              name: 'Russian Twist',
              image: 'assets/onboarding/113.jpg',
              instructionImages: ['assets/onboarding/121.jpg'],
              theory:
                  'Tập trung vào cơ bụng xiên (liên sườn), giúp vòng eo thon gọn và săn chắc hơn.',
              steps: [
                'Ngồi trên sàn, hơi ngả người ra sau, chân nhấc nhẹ khỏi mặt đất.',
                'Xoay thân người sang hai bên một cách nhịp nhàng.',
                'Có thể cầm thêm tạ đơn hoặc tạ ấm để tăng hiệu quả.',
              ],
            ),
            // 7. Ab Roll-Out
            ExerciseDetail(
              name: 'Ab Roll-Out',
              image: 'assets/onboarding/112.jpg',
              instructionImages: ['assets/onboarding/120.jpg'],
              theory:
                  'Bài tập thử thách cực đại cho cơ trọng tâm, giúp xây dựng sự liên kết giữa bụng, lưng và vai.',
              steps: [
                'Quỳ trên sàn, hai tay nắm con lăn.',
                'Lăn con lăn về phía trước xa nhất có thể mà không để lưng bị võng.',
                'Dùng cơ bụng kéo người trở lại vị trí ban đầu.',
              ],
            ),
            // 8. Exercise Ball Pike
            ExerciseDetail(
              name: 'Exercise Ball Pike',
              image: 'assets/onboarding/117.jpg',
              instructionImages: ['assets/onboarding/119.jpg'],
              theory:
                  'Kết hợp sự thăng bằng với bóng tập để tác động sâu vào vùng cơ bụng dưới.',
              steps: [
                'Chống tay như tư thế hít đất, đặt ống chân lên bóng tập.',
                'Đẩy hông lên cao, kéo bóng về phía tay để cơ thể tạo thành hình chữ V ngược.',
                'Từ từ hạ hông xuống về tư thế ban đầu.',
              ],
            ),
            // 9. Plank
            ExerciseDetail(
              name: 'Plank',
              image: 'assets/onboarding/118.jpg',
              instructionImages: ['assets/onboarding/118.jpg'],
              theory:
                  'Bài tập nền tảng giúp tăng sức bền cơ bụng và bảo vệ cột sống lưng dưới.',
              steps: [
                'Chống khuỷu tay và mũi chân xuống sàn.',
                'Giữ người thẳng từ đầu đến gót chân như một tấm ván.',
                'Gồng chặt bụng và mông, duy trì hơi thở đều.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Luyện tập chức năng',
          imageUrl: 'assets/onboarding/24.jpg',
          exercises: [
            // 1. TRX Arm row and extension
            ExerciseDetail(
              name: 'TRX Arm Row and Extension',
              image: 'assets/onboarding/177.jpg',
              instructionImages: ['assets/onboarding/177.jpg'],
              theory:
                  'Sử dụng dây kháng lực TRX giúp tăng cường sự ổn định của cơ trọng tâm và phối hợp nhịp nhàng giữa các nhóm cơ kéo.',
              steps: [
                'Nắm tay cầm TRX, ngả người ra sau giữ cơ thể thẳng đứng.',
                'Dùng lực tay và lưng kéo người về phía trước.',
                'Hạ người về vị trí cũ một cách chậm rãi để kiểm soát trọng lượng cơ thể.',
              ],
            ),
            // 2. Plyo box jump over
            ExerciseDetail(
              name: 'Plyo Box Jump Over',
              image: 'assets/onboarding/178.jpg',
              instructionImages: ['assets/onboarding/178.jpg'],
              theory:
                  'Bài tập bùng nổ giúp phát triển sức mạnh tốc độ, khả năng bật nhảy và sự linh hoạt của khớp hông.',
              steps: [
                'Đứng trước hộp Plyo, hơi trùng gối lấy đà.',
                'Bật nhảy mạnh mẽ lên trên hộp hoặc nhảy qua phía bên kia.',
                'Tiếp đất nhẹ nhàng bằng mũi chân để giảm chấn động lên khớp gối.',
              ],
            ),
            // 3. Alternating bird dog
            ExerciseDetail(
              name: 'Alternating Bird Dog',
              image: 'assets/onboarding/179.jpg',
              instructionImages: ['assets/onboarding/179.jpg'],
              theory:
                  'Bài tập nền tảng để cải thiện khả năng thăng bằng và sức khỏe cột sống, tác động sâu vào cơ bụng và lưng dưới.',
              steps: [
                'Chống hai tay và đầu gối trên sàn (tư thế bò).',
                'Nâng tay trái về phía trước và duỗi chân phải về phía sau cùng lúc.',
                'Giữ cơ thể không bị nghiêng lệch, sau đó đổi bên nhịp nhàng.',
              ],
            ),
            // 4. Alternating leg raise crunch - arms extended
            ExerciseDetail(
              name: 'Alternating Leg Raise Crunch',
              image: 'assets/onboarding/180.jpg',
              instructionImages: ['assets/onboarding/180.jpg'],
              theory:
                  'Sự kết hợp giữa gập bụng và nâng chân giúp tối ưu hóa sức mạnh của cơ bụng dưới và cơ gập hông.',
              steps: [
                'Nằm ngửa, hai tay duỗi thẳng qua đầu.',
                'Nâng một chân lên đồng thời gập người đưa tay về phía mũi chân.',
                'Hạ xuống chậm rãi và đổi chân liên tục.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Cardio',
          imageUrl: 'assets/onboarding/25.jpg',
          exercises: [
            // 1. Outdoor cycling
            ExerciseDetail(
              name: 'Outdoor Cycling',
              image: 'assets/onboarding/173.jpg',
              instructionImages: ['assets/onboarding/173.jpg'],
              theory:
                  'Đạp xe ngoài trời là hình thức Cardio tuyệt vời giúp đốt cháy calo hiệu quả, tăng cường sức khỏe tim mạch và cải thiện tâm trạng nhờ không gian mở.',
              steps: [
                'Chọn xe phù hợp và đội mũ bảo hiểm để đảm bảo an toàn.',
                'Duy trì tốc độ ổn định để giữ nhịp tim ở vùng đốt mỡ.',
                'Kết hợp các đoạn leo dốc để tăng cường sức mạnh cho đôi chân.',
              ],
            ),
            // 2. Exercise Bike Training
            ExerciseDetail(
              name: 'Exercise Bike Training',
              image: 'assets/onboarding/174.jpg',
              instructionImages: ['assets/onboarding/174.jpg'],
              theory:
                  'Tập luyện với xe đạp chuyên dụng trong nhà cho phép bạn thực hiện các bài tập cường độ cao (HIIT) mà không lo ngại về thời tiết.',
              steps: [
                'Điều chỉnh yên xe sao cho chân hơi trùng khi ở vị trí thấp nhất.',
                'Thay đổi mức kháng lực của máy để mô phỏng các địa hình khác nhau.',
                'Tập trung vào tốc độ vòng đạp để tối ưu hóa việc đốt cháy năng lượng.',
              ],
            ),
            // 3. Treadmill
            ExerciseDetail(
              name: 'Treadmill',
              image: 'assets/onboarding/175.jpg',
              instructionImages: ['assets/onboarding/175.jpg'],
              theory:
                  'Máy chạy bộ là thiết bị Cardio phổ biến nhất, giúp bạn kiểm soát chính xác tốc độ, quãng đường và độ dốc khi chạy hoặc đi bộ.',
              steps: [
                'Khởi động nhẹ nhàng bằng cách đi bộ trong 5 phút đầu tiên.',
                'Tăng dần độ dốc hoặc tốc độ để thử thách hệ tim mạch.',
                'Luôn sử dụng khóa an toàn của máy khi chạy ở tốc độ cao.',
              ],
            ),
            // 4. Exercise Bike
            ExerciseDetail(
              name: 'Exercise Bike',
              image: 'assets/onboarding/176.jpg',
              instructionImages: ['assets/onboarding/176.jpg'],
              theory:
                  'Đạp xe tại chỗ là lựa chọn Cardio tác động thấp (Low-impact), rất an toàn cho khớp gối trong khi vẫn mang lại hiệu quả giảm cân tốt.',
              steps: [
                'Ngồi thẳng lưng, nắm nhẹ tay cầm của máy.',
                'Duy trì nhịp thở đều đặn theo nhịp đạp chân.',
                'Tập luyện ít nhất 20-30 phút mỗi buổi để thấy hiệu quả rõ rệt.',
              ],
            ),
          ],
        ),
        ContentSection(
          title: 'Giãn cơ',
          imageUrl: 'assets/onboarding/22.jpg',
          exercises: [
            // 1. Abs and lumbar area muscle stretch
            ExerciseDetail(
              name: 'Abs and Lumbar Area Muscle Stretch',
              image: 'assets/onboarding/181.jpg',
              instructionImages: ['assets/onboarding/181.jpg'],
              theory:
                  'Tư thế này (thường gọi là tư thế Hổ mang) giúp kéo giãn toàn bộ cơ bụng và giải tỏa áp lực cho vùng lưng dưới sau các bài tập nặng.',
              steps: [
                'Nằm úp người trên sàn, hai tay chống cạnh ngực.',
                'Đẩy thẳng tay để nâng phần thân trên lên, giữ hông sát mặt đất.',
                'Ngửa đầu nhẹ ra sau và giữ trong 15-30 giây.',
              ],
            ),
            // 2. Butterfly stretch
            ExerciseDetail(
              name: 'Butterfly Stretch',
              image: 'assets/onboarding/182.jpg',
              instructionImages: ['assets/onboarding/182.jpg'],
              theory:
                  'Động tác "cánh bướm" giúp mở rộng khớp hông và kéo giãn các nhóm cơ đùi trong, cải thiện sự linh hoạt cho phần dưới cơ thể.',
              steps: [
                'Ngồi thẳng lưng, áp hai lòng bàn chân vào nhau.',
                'Dùng tay giữ bàn chân và nhẹ nhàng ép đầu gối xuống sát sàn.',
                'Hơi gập người về phía trước để tăng cảm giác căng giãn.',
              ],
            ),
            // 3. Gluteus maximus stretch
            ExerciseDetail(
              name: 'Gluteus Maximus Stretch',
              image: 'assets/onboarding/183.jpg',
              instructionImages: ['assets/onboarding/183.jpg'],
              theory:
                  'Giúp giảm căng thẳng cho cơ mông và hỗ trợ điều trị đau thần kinh tọa sau các bài tập chân như Squat hay Deadlift.',
              steps: [
                'Nằm ngửa, bắt chéo một chân lên đầu gối chân còn lại.',
                'Dùng hai tay ôm lấy đùi chân dưới và kéo về phía ngực.',
                'Giữ nguyên tư thế và cảm nhận vùng mông được kéo căng.',
              ],
            ),
            // 4. Oblique muscle and latissimus dorsi side reach stretch
            ExerciseDetail(
              name: 'Side Reach Stretch',
              image: 'assets/onboarding/184.jpg',
              instructionImages: ['assets/onboarding/184.jpg'],
              theory:
                  'Bài tập này kéo giãn đồng thời cơ liên sườn và cơ xô, giúp mở rộng lồng ngực và cải thiện hô hấp.',
              steps: [
                'Đứng thẳng, đưa một tay qua đầu và nghiêng người sang phía đối diện.',
                'Tay còn lại có thể chống hông hoặc thả lỏng theo chân.',
                'Cảm nhận sự căng giãn dọc suốt từ nách đến hông.',
              ],
            ),
            // 5. Standing Toe Touches
            ExerciseDetail(
              name: 'Standing Toe Touches',
              image: 'assets/onboarding/185.jpg',
              instructionImages: ['assets/onboarding/185.jpg'],
              theory:
                  'Động tác chạm mũi chân kinh điển giúp kéo giãn toàn bộ chuỗi cơ sau bao gồm lưng dưới, mông và đùi sau.',
              steps: [
                'Đứng thẳng, hai chân sát nhau hoặc rộng bằng vai.',
                'Từ từ gập người từ hông xuống, cố gắng chạm tay vào mũi chân.',
                'Giữ đầu gối thẳng nhưng không khóa khớp quá chặt.',
              ],
            ),
          ],
        ),
      ],
    ),
    HandbookTopic(
      id: '2',
      title: 'Dinh dưỡng thể thao',
      description: 'Sports nutrition and diet',
      imageUrl: 'assets/onboarding/17.jpg',
      sections: [
        // --- 31. PROTEIN ---
        ContentSection(
          title: 'Protein',
          isSupplement: true,
          imageUrl: 'assets/onboarding/31.jpg',
          foods: [
            ThucPham(
              id: 'w1',
              ten: 'Complex Protein',
              theLoai: 'Protein',
              hinhAnh: 'assets/onboarding/186.jpg',
              moTa:
                  'Complex Protein (Protein phức hợp) là sự kết hợp chiến lược giữa nhiều nguồn đạm có tốc độ hấp thụ khác nhau, từ siêu nhanh như Whey Isolate đến chậm như Micellar Casein và Protein trứng. Cơ chế này tạo ra một "biểu đồ giải phóng đa tầng", cung cấp axit amin cho cơ bắp ngay lập tức sau khi uống và duy trì nguồn dưỡng chất này ổn định trong suốt nhiều giờ sau đó.\n\n \n\nSản phẩm này cực kỳ linh hoạt, có thể sử dụng vào bất kỳ thời điểm nào trong ngày: sau tập để phục hồi nhanh, hoặc dùng như một bữa ăn phụ để duy trì trạng thái đồng hóa (nuôi cơ). Nó giúp duy trì cảm giác no lâu hơn, hỗ trợ đắc lực cho việc kiểm soát cân nặng trong khi vẫn bảo vệ khối lượng cơ nạc khỏi quá trình dị hóa do thiếu hụt dinh dưỡng.',
            ),
            ThucPham(
              id: 'w2',
              ten: 'Matrix Protein',
              theLoai: 'Protein',
              hinhAnh: 'assets/onboarding/187.jpg',
              moTa:
                  'Matrix Protein là sản phẩm đa nguồn đột phá, kết hợp giữa Whey Isolate hấp thụ tức thì và Micellar Casein hấp thụ chậm. Sự kết hợp này giúp cơ bắp được nuôi dưỡng liên tục trong suốt nhiều giờ liền.\n\nĐây là giải pháp dinh dưỡng hoàn hảo để dùng giữa các bữa ăn chính hoặc trước khi đi ngủ, giúp ngăn chặn triệt để quá trình dị hóa cơ bắp do thiếu hụt protein kéo dài.',
            ),
            ThucPham(
              id: 'w3',
              ten: 'Protein bò',
              theLoai: 'Protein',
              hinhAnh: 'assets/onboarding/188.jpg',
              moTa:
                  'Beef Protein được chiết xuất từ thịt bò nạc tươi thông qua công nghệ thủy phân, cung cấp hàm lượng axit amin cô đặc mà hoàn toàn không chứa lactose hay cholesterol xấu.\n\nSản phẩm này là lựa chọn thay thế hàng đầu cho người bị dị ứng sữa. Đặc biệt, Protein bò chứa hàm lượng Creatine tự nhiên cao, giúp tăng sức mạnh bộc phát và độ dày sợi cơ.',
            ),
            ThucPham(
              id: 'w4',
              ten: 'Protein casein',
              theLoai: 'Protein',
              hinhAnh: 'assets/onboarding/189.jpg',
              moTa:
                  'Casein được mệnh danh là "protein ban đêm" nhờ tốc độ tiêu hóa chậm kéo dài đến 8 giờ. Khi nạp vào, nó tạo thành một lớp gel trong dạ dày, giải phóng axit amin từ từ vào hệ thống tuần hoàn.\n\nĐiều này cực kỳ quan trọng để bảo vệ cơ bắp trong giấc ngủ dài hoặc những lúc không thể ăn uống, giúp tối ưu hóa khả năng tái tạo mô sợi cơ bị tổn thương.',
            ),
            ThucPham(
              id: 'w5',
              ten: 'Protein trứng',
              theLoai: 'Protein',
              hinhAnh: 'assets/onboarding/190.jpg',
              moTa:
                  'Protein từ lòng trắng trứng là "tiêu chuẩn vàng" nhờ giá trị sinh học cực cao. Nó chứa đầy đủ các axit amin thiết yếu với tỷ lệ hoàn hảo mà cơ thể không thể tự tổng hợp được.\n\nVì không chứa lactose và rất ít chất béo, protein trứng phù hợp cho giai đoạn siết cơ nghiêm ngặt (cutting) hoặc những người cần nguồn đạm sạch tuyệt đối để hệ tiêu hóa nhẹ nhàng.',
            ),
            ThucPham(
              id: 'w6',
              ten: 'Protein đậu nành',
              theLoai: 'Protein',
              hinhAnh: 'assets/onboarding/191.jpg',
              moTa:
                  'Protein đậu nành là nguồn đạm thực vật hoàn chỉnh nhất. Ngoài hỗ trợ phát triển cơ bắp, nó còn chứa hoạt chất isoflavone giúp hỗ trợ tim mạch và ổn định mức cholesterol.\n\nĐây là sự lựa chọn ưu tiên dành cho vận động viên ăn chay hoặc những người muốn đa dạng hóa nguồn đạm để giảm áp lực tiêu hóa từ đạm động vật.',
            ),
            ThucPham(
              id: 'w7',
              ten: 'Whey Protein Isolate',
              theLoai: 'Protein',
              hinhAnh: 'assets/onboarding/192.jpg',
              moTa:
                  'Whey Isolate là dạng protein tinh khiết nhất, loại bỏ gần như hoàn toàn đường lactose, chất béo và tạp chất thông qua quá trình lọc vi mô hiện đại.\n\nVới tốc độ hấp thụ siêu nhanh (chỉ 20-30 phút), đây là nguồn dưỡng chất vàng ngay sau buổi tập để kích thích tổng hợp protein mạnh mẽ, bù đắp năng lượng và phục hồi cơ bắp thần tốc.',
            ),
          ],
        ),
        // --- 32. GAINER ---
        ContentSection(
          title: 'Gainer',
          isSupplement: true,
          imageUrl: 'assets/onboarding/32.jpg',
          foods: [
            ThucPham(
              id: 'g1',
              ten: 'Gainer', // Đồng bộ với title
              theLoai: 'Gainer',
              hinhAnh: 'assets/onboarding/32.jpg',
              moTa:
                  'Gainer (hay Mass Gainer) là giải pháp tối ưu cho những người có cơ địa khó tăng cân (Ectomorph). Sản phẩm cung cấp sự kết hợp hoàn hảo giữa protein cao cấp và carbohydrate phức hợp.\n\nBên cạnh việc cung cấp calo dồi dào, các dòng Gainer hiện đại còn bổ sung vitamin, khoáng chất và enzyme tiêu hóa giúp cải thiện khả năng hấp thụ, phục hồi nguồn glycogen nhanh chóng sau tập luyện.',
            ),
          ],
        ),
        // --- 33. CREATINE ---
        ContentSection(
          title: 'Creatine',
          isSupplement: true,
          imageUrl: 'assets/onboarding/33.jpg',
          foods: [
            ThucPham(
              id: 'c1',
              ten: 'Creatine Monohydrate',
              theLoai: 'Creatine',
              hinhAnh: 'assets/onboarding/194.jpg',
              moTa:
                  'Creatine Monohydrate là dạng Creatine phổ biến nhất và được nghiên cứu khoa học kỹ lưỡng nhất về tính an toàn cũng như hiệu quả. Cơ chế chính của nó là tăng cường dự trữ phosphocreatine trong cơ bắp, giúp tái tạo năng lượng ATP tức thì cho các hoạt động bùng nổ như nâng tạ nặng hoặc chạy nước rút.\n\nSản phẩm này đặc biệt nổi tiếng với khả năng giữ nước nội bào, giúp tế bào cơ ngậm nước tốt hơn, tạo vẻ ngoài căng tròn và đầy đặn. Đây là nền tảng quan trọng giúp tăng sức mạnh thô, cải thiện khối lượng nạc và tăng tốc độ phục hồi cơ bắp sau các buổi tập cường độ cao.',
            ),
            ThucPham(
              id: 'c2',
              ten: 'Creatine Transport system',
              theLoai: 'Creatine',
              hinhAnh: 'assets/onboarding/193.jpg',
              moTa:
                  'Creatine Transport system là công thức nâng cao kết hợp Creatine với các hợp chất dẫn truyền như Carbohydrate chỉ số đường huyết cao (High-GI) và Alpha Lipoic Acid. Sự kết hợp này nhằm kích hoạt tối đa hormone Insulin – được mệnh danh là "chìa khóa" mở cửa tế bào, giúp đẩy toàn bộ lượng Creatine vào sâu trong mô cơ một cách nhanh chóng.\n\n \n\nCơ chế này không chỉ tối ưu hóa việc nạp Creatine mà còn đồng thời nạp lại nguồn Glycogen dự trữ bị cạn kiệt sau tập. Sản phẩm thường được bổ sung thêm các chất điện giải để cân bằng áp suất thẩm thấu, giúp vận động viên đạt được trạng thái phục hồi hoàn hảo và tăng khối lượng cơ bắp mà không cần trải qua giai đoạn nạp (loading phase) phức tạp.',
            ),
          ],
        ),
        // --- 34. AXIT AMIN ---
        ContentSection(
          title: 'Axit amin',
          isSupplement: true,
          imageUrl: 'assets/onboarding/34.jpg',
          foods: [
            ThucPham(
              id: 'a1',
              ten: 'Arginine',
              theLoai: 'Axit Amin',
              hinhAnh: 'assets/onboarding/195.jpg',
              moTa:
                  'Arginine là một axit amin thiết yếu đóng vai trò là tiền chất trực tiếp để tổng hợp Nitric Oxide (NO). Nitric Oxide giúp làm giãn nở các thành mạch máu, từ đó tăng cường lưu lượng máu mang oxy và chất dinh dưỡng đến các mô cơ bắp đang hoạt động.\n\nViệc bổ sung Arginine giúp tạo hiệu ứng "bơm" cơ mạnh mẽ (pump), tăng cường sức bền và hỗ trợ cơ thể đào thải các chất độc hại như amoniac sinh ra trong quá trình tập luyện cường độ cao, giúp vận động viên phục hồi nhanh hơn giữa các hiệp tập.',
            ),
            ThucPham(
              id: 'a2',
              ten: 'Arginine Alpha-Ketoglutarate',
              theLoai: 'Axit Amin',
              hinhAnh: 'assets/onboarding/196.jpg',
              moTa:
                  'AAKG là phiên bản nâng cấp của Arginine, giúp cơ thể sản sinh Nitric Oxide (NO) mạnh mẽ hơn. Nó hỗ trợ giãn nở mạch máu tối đa, đưa oxy và dinh dưỡng đến cơ bắp nhanh hơn.\n\nSử dụng AAKG giúp tăng cường độ bền, tạo cảm giác bơm cơ (pump) cực đại trong phòng tập và hỗ trợ quá trình thải độc tố amoniac ra khỏi cơ thể.',
            ),
            ThucPham(
              id: 'a3',
              ten: 'BCAA axit amin',
              theLoai: 'Axit Amin',
              hinhAnh: 'assets/onboarding/197.jpg',
              moTa:
                  'BCAA gồm Leucine, Isoleucine và Valine. Đây là các axit amin được chuyển hóa trực tiếp tại cơ bắp, cung cấp năng lượng tức thì và ngăn chặn quá trình phá hủy cơ khi tập nặng.\n\nLeucine trong BCAA đóng vai trò là ngòi nổ kích hoạt tín hiệu tổng hợp protein, giúp giảm cảm giác mệt mỏi hệ thần kinh và rút ngắn thời gian phục hồi sau các buổi tập cường độ cao.',
            ),
            ThucPham(
              id: 'a4',
              ten: 'Citrulline',
              theLoai: 'Axit Amin',
              hinhAnh: 'assets/onboarding/198.jpg',
              moTa:
                  'Citrulline là axit amin giúp gia tăng mức Arginine nội sinh, hỗ trợ sản sinh Nitric Oxide bền vững. Nó giúp loại bỏ axit lactic và amoniac - các tác nhân gây mỏi cơ và đau nhức.\n\nSử dụng Citrulline trước tập giúp cải thiện sức bền rõ rệt, tăng số lần lặp lại (reps) trong mỗi hiệp và duy trì trạng thái bơm cơ lâu dài sau khi buổi tập kết thúc.',
            ),
            ThucPham(
              id: 'a5',
              ten: 'Glutamine',
              theLoai: 'Axit Amin',
              hinhAnh: 'assets/onboarding/199.jpg',
              moTa:
                  'Glutamine chiếm phần lớn lượng axit amin tự do trong cơ bắp. Sau khi tập luyện, mức glutamine thường bị sụt giảm nghiêm trọng, gây suy yếu hệ miễn dịch và dễ mất cơ.\n\nBổ sung Glutamine giúp bảo vệ khối lượng cơ, hỗ trợ phục hồi glycogen và tăng cường sức khỏe đường ruột, giúp cơ thể luôn sẵn sàng cho các buổi tập luyện tiếp theo.',
            ),
          ],
        ),
        // --- 35. SẢN PHẨM GIẢM CÂN ---
        ContentSection(
          title: 'Sản phẩm giảm cân',
          isSupplement: true,
          imageUrl: 'assets/onboarding/35.jpg',
          foods: [
            ThucPham(
              id: 'lc1',
              ten: 'Thuốc giảm cân', // Đồng bộ với title
              theLoai: 'Sản phẩm giảm cân',
              hinhAnh: 'assets/onboarding/35.jpg',
              moTa:
                  'Thuốc giảm cân được thiết kế để kích thích trao đổi chất và sinh nhiệt, giúp cơ thể ưu tiên sử dụng mỡ thừa làm nguồn năng lượng cho hoạt động thể chất.\n\nChúng thường chứa các thành phần hỗ trợ sự tập trung và kiểm soát cơn thèm ăn. Hiệu quả đạt được cao nhất khi kết hợp với chế độ tập luyện đều đặn và dinh dưỡng thâm hụt calo hợp lý.',
            ),
          ],
        ),
        // --- 36. L-CARNITINE ---
        ContentSection(
          title: 'L-Carnitine',
          isSupplement: true,
          imageUrl: 'assets/onboarding/36.jpg',
          foods: [
            ThucPham(
              id: 'car1',
              ten: 'L-Carnitine', // Đồng bộ với title
              theLoai: 'L-Carnitine',
              hinhAnh: 'assets/onboarding/36.jpg',
              moTa:
                  'L-Carnitine đóng vai trò như một "phu xe" vận chuyển axit béo vào ty thể - nơi chúng được đốt cháy để tạo ra năng lượng ATP cho cơ thể hoạt động.\n\nSử dụng L-Carnitine trước khi tập Cardio hoặc tập tạ giúp tăng khả năng chịu đựng, giảm mệt mỏi và tối ưu hóa quá trình đốt mỡ, giúp cơ thể săn chắc và tràn đầy năng lượng hơn.',
            ),
          ],
        ),
      ],
    ),
    HandbookTopic(
      id: '3',
      title: 'Danh sách các nguyên liệu và lượng calo',
      description: 'Ingredients and calorie content',
      imageUrl: 'assets/onboarding/16.jpg',
      foodList: [], // Để trống cái này vì ta dùng sections
      sections: [
        // Ô số 1: Sữa và các sản phẩm từ sữa
        ContentSection(
          title: 'Sữa và các sản phẩm từ sữa,eggs,sữa chua, phô mai cottage',
          imageUrl: 'assets/onboarding/202.jpg', // Ảnh nền cho ô lớn
          foods: [
            ThucPham(
              id: 'eggs',
              ten: 'Trứng gà',
              theLoai: 'eggs',
              calorie: 165.0,
              protein: 31.0,
              carbs: 0.0,
              fat: 3.6,
              hinhAnh: 'assets/onboarding/10.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 165.0\nProtein, g: 31.0\nCarbohydrate, g: 0.0\nChất béo, g: 3.6\nBão hòa: 1.2\n\nNguyên tố\nVitamin A: 140.0\nVitamin B12: 1.1\nRiboflavin: 0.5',
            ),
            ThucPham(
              id: 'milk1',
              ten: 'Sữa tươi',
              theLoai: 'Dairy',
              calorie: 61.0,
              protein: 3.2,
              carbs: 4.8,
              fat: 3.3,
              hinhAnh: 'assets/onboarding/7.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 61.0\n'
                  'Protein, g: 3.2\n'
                  'Carbohydrate, g: 4.8\n'
                  'Chất béo, g: 3.3\n'
                  'Bão hòa: 1.9\n'
                  'Không bão hòa đa: 0.1\n'
                  'Axit béo chuyển hóa: 0.0\n\n'
                  'Nguyên tố\n'
                  'Beta caroten: 0.02\n'
                  'Vitamin A: 28.0\n'
                  'Vitamin B12: 0.45\n'
                  'Vitamin D: 0.1\n'
                  'Vitamin C: 1.0\n'
                  'Riboflavin: 0.18',
            ),
            // 2. Các loại Bánh bao
            ThucPham(
              id: 'bb_kimsa',
              ten: 'Bánh bao kim sa',
              theLoai: 'Bánh bao',
              calorie: 250.0,
              protein: 6.0,
              carbs: 45.0,
              fat: 8.0,
              hinhAnh: 'assets/onboarding/204.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 250.0\nProtein, g: 6.0\nCarbohydrate, g: 45.0\nChất béo, g: 8.0\nBão hòa: 4.2\n\nNguyên tố\nVitamin A: 12.0\nVitamin B12: 0.1\nRiboflavin: 0.12',
            ),
            ThucPham(
              id: 'bb_chay',
              ten: 'Bánh bao chay',
              theLoai: 'Bánh bao',
              calorie: 150.0,
              protein: 4.0,
              carbs: 30.0,
              fat: 1.0,
              hinhAnh: 'assets/onboarding/205.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 150.0\nProtein, g: 4.0\nCarbohydrate, g: 30.0\nChất béo, g: 1.0\n\nNguyên tố\nVitamin B6: 0.02\nRiboflavin: 0.05',
            ),
            ThucPham(
              id: 'bb_xaxiu',
              ten: 'Bánh bao xá xíu',
              theLoai: 'Bánh bao',
              calorie: 280.0,
              protein: 10.0,
              carbs: 40.0,
              fat: 9.0,
              hinhAnh: 'assets/onboarding/206.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 280.0\nProtein, g: 10.0\nCarbohydrate, g: 40.0\nChất béo, g: 9.0\n\nNguyên tố\nVitamin B12: 0.5\nRiboflavin: 0.08',
            ),
            ThucPham(
              id: 'bb_khongnhan',
              ten: 'Bánh bao không nhân',
              theLoai: 'Bánh bao',
              calorie: 120.0,
              protein: 3.0,
              carbs: 25.0,
              fat: 0.5,
              hinhAnh: 'assets/onboarding/207.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 120.0\nProtein, g: 3.0\nCarbohydrate, g: 25.0\nChất béo, g: 0.5\n\nNguyên tố\nRiboflavin: 0.04',
            ),
            ThucPham(
              id: 'bb_dauxanh',
              ten: 'Bánh bao đậu xanh',
              theLoai: 'Bánh bao',
              calorie: 230.0,
              protein: 7.0,
              carbs: 42.0,
              fat: 4.0,
              hinhAnh: 'assets/onboarding/208.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 230.0\nProtein, g: 7.0\nCarbohydrate, g: 42.0\nChất béo, g: 4.0\n\nNguyên tố\nVitamin B6: 0.1\nRiboflavin: 0.1',
            ),

            // 3. Các loại Sữa chua & Bột
            ThucPham(
              id: 'sc_hatchia',
              ten: 'Sữa chua trái cây hạt chia',
              theLoai: 'Sữa chua',
              calorie: 110.0,
              protein: 4.0,
              carbs: 15.0,
              fat: 3.0,
              hinhAnh: 'assets/onboarding/209.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 110.0\nProtein, g: 4.0\nCarbohydrate, g: 15.0\nChất béo, g: 3.0\nBão hòa: 1.5\n\nNguyên tố\nVitamin C: 5.0\nRiboflavin: 0.18',
            ),
            ThucPham(
              id: 'sc_thanhlong',
              ten: 'Sữa chua trái cây thanh long',
              theLoai: 'Sữa chua',
              calorie: 95.0,
              protein: 3.5,
              carbs: 18.0,
              fat: 1.0,
              hinhAnh: 'assets/onboarding/210.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 95.0\nProtein, g: 3.5\nCarbohydrate, g: 18.0\nChất béo, g: 1.0\n\nNguyên tố\nVitamin C: 8.0\nRiboflavin: 0.15',
            ),
            ThucPham(
              id: 'sc_kiwi',
              ten: 'Sữa chua kiwi',
              theLoai: 'Sữa chua',
              calorie: 100.0,
              protein: 3.5,
              carbs: 17.0,
              fat: 1.0,
              hinhAnh: 'assets/onboarding/211.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 100.0\nProtein, g: 3.5\nCarbohydrate, g: 17.0\nChất béo, g: 1.0\n\nNguyên tố\nVitamin C: 15.0\nRiboflavin: 0.15',
            ),

            // 4. Các loại Phô mai
            ThucPham(
              id: 'pm_mozzarella',
              ten: 'Phô mai mozzarella',
              theLoai: 'Phô mai',
              calorie: 280.0,
              protein: 22.0,
              carbs: 2.3,
              fat: 20.0,
              hinhAnh: 'assets/onboarding/212.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 280.0\nProtein, g: 22.0\nCarbohydrate, g: 2.3\nChất béo, g: 20.0\nBão hòa: 13.0\n\nNguyên tố\nVitamin A: 8.0\nVitamin B12: 2.3\nRiboflavin: 0.28',
            ),
            ThucPham(
              id: 'pm_parmesan',
              ten: 'Phô mai parmesan',
              theLoai: 'Phô mai',
              calorie: 431.0,
              protein: 38.0,
              carbs: 4.1,
              fat: 29.0,
              hinhAnh: 'assets/onboarding/213.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 431.0\nProtein, g: 38.0\nCarbohydrate, g: 4.1\nChất béo, g: 29.0\nBão hòa: 19.0\n\nNguyên tố\nVitamin B12: 1.2\nRiboflavin: 0.33',
            ),
          ],
        ),

        // Ô số 2: Ngũ cốc, cháo...
        ContentSection(
          title: 'Ngũ cốc, cháo, khoai tây chiên',
          imageUrl: 'assets/onboarding/200.jpg',
          foods: [
            ThucPham(
              id: 'potato1',
              ten: 'Khoai tây',
              theLoai: 'Staple',
              calorie: 77.0,
              protein: 2.0,
              carbs: 17.5,
              fat: 0.1,
              hinhAnh: 'assets/onboarding/11.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 77.0\n'
                  'Protein, g: 2.0\n'
                  'Carbohydrate, g: 17.5\n'
                  'Chất béo, g: 0.1\n'
                  'Bão hòa: 0.03\n'
                  'Chất xơ, g: 2.2\n'
                  'Đường, g: 0.8\n\n'
                  'Nguyên tố\n'
                  'Vitamin C: 19.7\n'
                  'Vitamin B6: 0.3\n'
                  'Kali: 421.0\n'
                  'Magie: 23.0\n'
                  'Sắt: 0.8\n'
                  'Riboflavin: 0.03',
            ),
            // 2. Yến mạch (214)
            ThucPham(
              id: 'oats',
              ten: 'Yến mạch',
              theLoai: 'Staple',
              calorie: 389.0,
              protein: 16.9,
              carbs: 66.3,
              fat: 6.9,
              hinhAnh: 'assets/onboarding/214.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 389.0\nProtein, g: 16.9\nCarbohydrate, g: 66.3\nChất béo, g: 6.9\nChất xơ: 10.6\n\nNguyên tố\nVitamin B1: 0.76\nVitamin B5: 1.3\nSắt: 4.7\nMagie: 177.0',
            ),

            // 3. Ngũ cốc Granola (215)
            ThucPham(
              id: 'granola',
              ten: 'Ngũ cốc Granola',
              theLoai: 'Staple',
              calorie: 471.0,
              protein: 10.0,
              carbs: 64.0,
              fat: 20.0,
              hinhAnh: 'assets/onboarding/215.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 471.0\nProtein, g: 10.0\nCarbohydrate, g: 64.0\nChất béo, g: 20.0\nĐường: 20.0\n\nNguyên tố\nVitamin E: 1.5\nCanxi: 60.0\nKali: 336.0\nRiboflavin: 0.1',
            ),

            // 4. Gạo lứt (216)
            ThucPham(
              id: 'brown_rice',
              ten: 'Gạo lứt',
              theLoai: 'Staple',
              calorie: 111.0,
              protein: 2.6,
              carbs: 23.0,
              fat: 0.9,
              hinhAnh: 'assets/onboarding/216.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 111.0\nProtein, g: 2.6\nCarbohydrate, g: 23.0\nChất béo, g: 0.9\nChất xơ: 1.8\n\nNguyên tố\nVitamin B6: 0.15\nMagie: 43.0\nPhốt pho: 83.0\nMangan: 0.9',
            ),

            // 5. Lúa mạch đen (217)
            ThucPham(
              id: 'rye',
              ten: 'Lúa mạch đen',
              theLoai: 'Staple',
              calorie: 338.0,
              protein: 10.3,
              carbs: 75.9,
              fat: 1.6,
              hinhAnh: 'assets/onboarding/217.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 338.0\nProtein, g: 10.3\nCarbohydrate, g: 75.9\nChất béo, g: 1.6\nChất xơ: 15.1\n\nNguyên tố\nVitamin B1: 0.3\nSắt: 2.6\nKẽm: 3.7\nRiboflavin: 0.25',
            ),

            // 6. Cháo gà (218)
            ThucPham(
              id: 'chicken_porridge',
              ten: 'Cháo gà',
              theLoai: 'Staple',
              calorie: 50.0,
              protein: 3.5,
              carbs: 7.0,
              fat: 1.2,
              hinhAnh: 'assets/onboarding/218.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 50.0\nProtein, g: 3.5\nCarbohydrate, g: 7.0\nChất béo, g: 1.2\nBão hòa: 0.3\n\nNguyên tố\nVitamin A: 15.0\nVitamin B12: 0.2\nKali: 80.0\nNatri: 250.0',
            ),

            // 7. Cháo cá lóc (219)
            ThucPham(
              id: 'fish_porridge',
              ten: 'Cháo cá lóc',
              theLoai: 'Staple',
              calorie: 45.0,
              protein: 4.0,
              carbs: 6.5,
              fat: 0.8,
              hinhAnh: 'assets/onboarding/219.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 45.0\nProtein, g: 4.0\nCarbohydrate, g: 6.5\nChất béo, g: 0.8\n\nNguyên tố\nVitamin D: 0.5\nCanxi: 20.0\nPhốt pho: 50.0\nRiboflavin: 0.05',
            ),

            // 8. Cháo hải sản (220)
            ThucPham(
              id: 'seafood_porridge',
              ten: 'Cháo hải sản',
              theLoai: 'Staple',
              calorie: 55.0,
              protein: 4.5,
              carbs: 7.2,
              fat: 1.0,
              hinhAnh: 'assets/onboarding/220.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 55.0\nProtein, g: 4.5\nCarbohydrate, g: 7.2\nChất béo, g: 1.0\n\nNguyên tố\nVitamin B12: 0.8\nKẽm: 1.2\nI-ốt: 15.0\nCanxi: 30.0',
            ),
          ],
        ),
        ContentSection(
          title: 'Hoa quả,rau xanh và củ quả',
          imageUrl: 'assets/onboarding/203.jpg',
          foods: [
            // 1. Táo (Apple)
            ThucPham(
              id: 'apple',
              ten: 'Táo',
              theLoai: 'Fruit',
              calorie: 52.0,
              protein: 0.3,
              carbs: 13.8,
              fat: 0.2,
              hinhAnh: 'assets/onboarding/221.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 52.0\n'
                  'Protein, g: 0.3\n'
                  'Carbohydrate, g: 13.8\n'
                  'Chất béo, g: 0.2\n'
                  'Chất xơ, g: 2.4\n'
                  'Đường, g: 10.4\n\n'
                  'Nguyên tố\n'
                  'Vitamin C: 4.6\n'
                  'Vitamin A: 3.0\n'
                  'Kali: 107.0\n'
                  'Magie: 5.0\n'
                  'Riboflavin: 0.03',
            ),

            // 2. Chuối (Banana)
            ThucPham(
              id: 'banana',
              ten: 'Chuối',
              theLoai: 'Fruit',
              calorie: 89.0,
              protein: 1.1,
              carbs: 22.8,
              fat: 0.3,
              hinhAnh: 'assets/onboarding/8.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 89.0\n'
                  'Protein, g: 1.1\n'
                  'Carbohydrate, g: 22.8\n'
                  'Chất béo, g: 0.3\n'
                  'Chất xơ, g: 2.6\n\n'
                  'Nguyên tố\n'
                  'Vitamin C: 8.7\n'
                  'Vitamin B6: 0.4\n'
                  'Kali: 358.0\n'
                  'Magie: 27.0\n'
                  'Riboflavin: 0.07',
            ),

            ThucPham(
              id: 'orange',
              ten: 'Cam',
              theLoai: 'Fruit',
              calorie: 47.0,
              protein: 0.9,
              carbs: 11.8,
              fat: 0.1,
              hinhAnh: 'assets/onboarding/222.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 47.0\nProtein, g: 0.9\nCarbohydrate, g: 11.8\nChất béo, g: 0.1\nChất xơ, g: 2.4\nĐường, g: 9.4\n\nNguyên tố\nVitamin C: 53.2\nVitamin A: 11.0\nKali: 181.0\nCanxi: 40.0\nRiboflavin: 0.04',
            ),
            ThucPham(
              id: 'avocado',
              ten: 'Quả Bơ',
              theLoai: 'Fruit',
              calorie: 160.0,
              protein: 2.0,
              carbs: 8.5,
              fat: 14.7,
              hinhAnh: 'assets/onboarding/223.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 160.0\nProtein, g: 2.0\nCarbohydrate, g: 8.5\nChất béo, g: 14.7\nBão hòa: 2.1\nKhông bão hòa đơn: 9.8\n\nNguyên tố\nVitamin K: 21.0\nVitamin E: 2.07\nKali: 485.0\nMagie: 29.0\nRiboflavin: 0.13',
            ),
            ThucPham(
              id: 'bell_pepper',
              ten: 'Ớt chuông',
              theLoai: 'Vegetable',
              calorie: 31.0,
              protein: 1.0,
              carbs: 6.0,
              fat: 0.3,
              hinhAnh: 'assets/onboarding/12.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\nKcal: 31.0\nProtein, g: 1.0\nCarbohydrate, g: 6.0\nChất béo, g: 0.3\nChất xơ, g: 2.1\n\nNguyên tố\nVitamin C: 127.7\nVitamin A: 157.0\nVitamin B6: 0.3\nKali: 211.0\nRiboflavin: 0.08',
            ),
            // 3. Súp lơ xanh (Broccoli)
            ThucPham(
              id: 'broccoli',
              ten: 'Súp lơ xanh',
              theLoai: 'Vegetable',
              calorie: 34.0,
              protein: 2.8,
              carbs: 6.6,
              fat: 0.4,
              hinhAnh: 'assets/onboarding/9.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 34.0\n'
                  'Protein, g: 2.8\n'
                  'Carbohydrate, g: 6.6\n'
                  'Chất béo, g: 0.4\n'
                  'Chất xơ, g: 2.6\n\n'
                  'Nguyên tố\n'
                  'Vitamin C: 89.2\n'
                  'Vitamin A: 31.0\n'
                  'Vitamin K: 101.6\n'
                  'Canxi: 47.0\n'
                  'Riboflavin: 0.11',
            ),

            // 4. Cà rốt (Carrot)
            ThucPham(
              id: 'carrot',
              ten: 'Cà rốt',
              theLoai: 'Vegetable',
              calorie: 41.0,
              protein: 0.9,
              carbs: 9.6,
              fat: 0.2,
              hinhAnh: 'assets/onboarding/224.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 41.0\n'
                  'Protein, g: 0.9\n'
                  'Carbohydrate, g: 9.6\n'
                  'Chất béo, g: 0.2\n\n'
                  'Nguyên tố\n'
                  'Beta caroten: 8285.0\n'
                  'Vitamin A: 835.0\n'
                  'Vitamin K: 13.2\n'
                  'Kali: 320.0\n'
                  'Riboflavin: 0.06',
            ),
          ],
        ),
        // Ô số 3: Thịt gà và gia cầm
        ContentSection(
          title: 'Thịt gà và thịt gia cầm khác, thịt gà xay, phụ phẩm',
          imageUrl: 'assets/onboarding/201.jpg',
          foods: [
            // 1. Ức gà (Cập nhật moTa)
            ThucPham(
              id: 'chicken_breast',
              ten: 'Ức gà',
              theLoai: 'Meat',
              calorie: 165.0,
              protein: 31.0,
              carbs: 0.0,
              fat: 3.6,
              hinhAnh: 'assets/onboarding/228.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 165.0\n'
                  'Protein, g: 31.0\n'
                  'Carbohydrate, g: 0.0\n'
                  'Chất béo, g: 3.6\n'
                  'Bão hòa: 1.0\n'
                  'Cholesterol: 85.0mg\n\n'
                  'Nguyên tố\n'
                  'Vitamin B6: 0.6\n'
                  'Vitamin B12: 0.3\n'
                  'Magie: 29.0\n'
                  'Sắt: 1.0\n'
                  'Riboflavin: 0.11',
            ),

            // 2. Đùi gà (226)
            ThucPham(
              id: 'chicken_leg',
              ten: 'Đùi gà',
              theLoai: 'Meat',
              calorie: 209.0,
              protein: 26.0,
              carbs: 0.0,
              fat: 10.9,
              hinhAnh: 'assets/onboarding/225.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 209.0\n'
                  'Protein, g: 26.0\n'
                  'Carbohydrate, g: 0.0\n'
                  'Chất béo, g: 10.9\n'
                  'Bão hòa: 3.1\n'
                  'Cholesterol: 93.0mg\n\n'
                  'Nguyên tố\n'
                  'Sắt: 1.3\n'
                  'Kẽm: 2.0\n'
                  'Kali: 223.0\n'
                  'Vitamin B12: 0.4\n'
                  'Riboflavin: 0.23',
            ),

            // 3. Má đùi gà (227)
            ThucPham(
              id: 'chicken_thigh',
              ten: 'Má đùi gà',
              theLoai: 'Meat',
              calorie: 179.0,
              protein: 24.8,
              carbs: 0.0,
              fat: 8.2,
              hinhAnh: 'assets/onboarding/226.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 179.0\n'
                  'Protein, g: 24.8\n'
                  'Carbohydrate, g: 0.0\n'
                  'Chất béo, g: 8.2\n'
                  'Bão hòa: 2.3\n\n'
                  'Nguyên tố\n'
                  'Vitamin B6: 0.4\n'
                  'Sắt: 1.1\n'
                  'Phốt pho: 188.0\n'
                  'Kali: 245.0\n'
                  'Riboflavin: 0.18',
            ),

            // 4. Cánh gà (228)
            ThucPham(
              id: 'chicken_wing',
              ten: 'Cánh gà',
              theLoai: 'Meat',
              calorie: 203.0,
              protein: 30.5,
              carbs: 0.0,
              fat: 8.1,
              hinhAnh: 'assets/onboarding/227.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 203.0\n'
                  'Protein, g: 30.5\n'
                  'Carbohydrate, g: 0.0\n'
                  'Chất béo, g: 8.1\n'
                  'Bão hòa: 2.3\n\n'
                  'Nguyên tố\n'
                  'Vitamin B12: 0.3\n'
                  'Sắt: 1.0\n'
                  'Kẽm: 1.5\n'
                  'Kali: 198.0\n'
                  'Riboflavin: 0.15',
            ),

            // 5. Thịt nạc heo (229)
            ThucPham(
              id: 'pork_lean',
              ten: 'Thịt nạc heo',
              theLoai: 'Meat',
              calorie: 145.0,
              protein: 21.0,
              carbs: 0.0,
              fat: 6.0,
              hinhAnh: 'assets/onboarding/229.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 145.0\n'
                  'Protein, g: 21.0\n'
                  'Carbohydrate, g: 0.0\n'
                  'Chất béo, g: 6.0\n'
                  'Bão hòa: 2.2\n'
                  'Cholesterol: 65.0mg\n\n'
                  'Nguyên tố\n'
                  'Vitamin B1: 0.9\n'
                  'Vitamin B6: 0.5\n'
                  'Kẽm: 2.5\n'
                  'Kali: 350.0\n'
                  'Riboflavin: 0.2',
            ),

            // 6. Thịt bò xay (230)
            ThucPham(
              id: 'ground_beef',
              ten: 'Thịt bò xay',
              theLoai: 'Meat',
              calorie: 250.0,
              protein: 26.0,
              carbs: 0.0,
              fat: 15.0,
              hinhAnh: 'assets/onboarding/230.jpg',
              moTa:
                  'Giá trị dinh dưỡng trong 100g\n\n'
                  'Kcal: 250.0\n'
                  'Protein, g: 26.0\n'
                  'Carbohydrate, g: 0.0\n'
                  'Chất béo, g: 15.0\n'
                  'Bão hòa: 6.0\n'
                  'Chất béo chuyển hóa: 1.1\n\n'
                  'Nguyên tố\n'
                  'Vitamin B12: 2.6\n'
                  'Sắt: 2.7\n'
                  'Kẽm: 6.3\n'
                  'Kali: 318.0\n'
                  'Riboflavin: 0.18',
            ),
          ],
        ),
      ],
    ),
    HandbookTopic(
      id: '4',
      title: 'Dược lý học',
      description: 'Health education and theory',
      imageUrl: 'assets/onboarding/6.jpg',
      sections: [
        // --- MỤC 1: HORMONE TĂNG TRƯỞNG ---
        ContentSection(
          title: 'Hormone tăng trưởng',
          isSupplement: true, // Đã thêm để ẩn Calo/Protein
          imageUrl: 'assets/onboarding/231.jpg',
          foods: [
            ThucPham(
              id: 'hgh_somatotropin',
              ten: 'Hormone tăng trưởng (Somatotropin)',
              theLoai: 'Hormone',
              hinhAnh: 'assets/onboarding/235.jpg',
              moTa:
                  'Somatotropin là hormone tăng trưởng tái tổ hợp (HGH) có cấu trúc tương tự như hormone tự nhiên do tuyến yên tiết ra. Trong thể thao và thể hình, nó được sử dụng rộng rãi nhờ khả năng kích thích tổng hợp protein mạnh mẽ, thúc đẩy quá trình tăng trưởng cơ bắp và phục hồi các mô bị tổn thương.\n\nĐiểm đặc biệt của Somatotropin là khả năng chuyển hóa chất béo bằng cách kích thích phân giải lipid, giúp vận động viên giảm mỡ trong khi vẫn duy trì được khối lượng cơ nạc. Ngoài ra, nó còn hỗ trợ tăng mật độ xương và củng cố các mô liên kết, giúp giảm thiểu rủi ro chấn thương khi tập luyện với cường độ cao.',
            ),
          ],
        ),

        // --- MỤC 2: PEPTIDE ---
        ContentSection(
          title: 'Peptide',
          isSupplement: true, // Đã thêm để ẩn Calo/Protein
          imageUrl: 'assets/onboarding/232.jpg',
          foods: [
            ThucPham(
              id: 'pep_peg_mgf',
              ten: 'Chất kích thích tăng trưởng Pegylated Mechanical',
              theLoai: 'Peptide',
              hinhAnh: 'assets/onboarding/236.jpg',
              moTa:
                  'Pegylated Mechanical Growth Factor (PEG-MGF) là một biến thể của IGF-1 có tác dụng kích thích sự phân chia tế bào cơ. Quá trình "Pegylated" giúp kéo dài thời gian bán thải của peptide từ vài phút lên vài ngày, cho phép nó tồn tại lâu hơn trong máu để thực hiện nhiệm vụ phục hồi mô cơ.\n\nSản phẩm này cực kỳ hiệu quả trong việc tái tạo các sợi cơ bị tổn thương sau khi tập luyện cường độ cao, thúc đẩy sự gia tăng kích thước cơ bắp thông qua việc kích hoạt các tế bào vệ tinh và tăng cường khả năng giữ nitơ trong mô cơ.',
            ),
            ThucPham(
              id: 'pep_ghrh_long',
              ten: 'GHRH tác dụng lâu dài',
              theLoai: 'Peptide',
              hinhAnh: 'assets/onboarding/237.jpg',
              moTa:
                  'GHRH (Growth Hormone Releasing Hormone) tác dụng lâu dài là các chất tương tự hormone giải phóng hormone tăng trưởng nội sinh. Thay vì đưa HGH ngoại sinh vào cơ thể, loại peptide này kích thích tuyến yên tự sản sinh và giải phóng hormone tăng trưởng theo các đợt tự nhiên.\n\nƯu điểm của nó là giúp duy trì mức độ hormone tăng trưởng ổn định mà không làm ức chế hoàn toàn chức năng tự nhiên của cơ thể. Nó giúp cải thiện chất lượng giấc ngủ, tăng cường quá trình trao đổi chất và hỗ trợ phục hồi cơ bắp một cách bền vững.',
            ),
            ThucPham(
              id: 'pep_hgh_frag',
              ten: 'HGH Fragment 176-191',
              theLoai: 'Peptide',
              hinhAnh: 'assets/onboarding/238.jpg',
              moTa:
                  'HGH Fragment 176-191 là một đoạn nhỏ của chuỗi hormone tăng trưởng được thiết kế chuyên biệt để kích thích quá trình phân giải lipid (đốt mỡ). Khác với hormone tăng trưởng toàn phần, đoạn Fragment này không ảnh hưởng đến mức độ insulin hay đường huyết trong máu.\n\nĐây là công cụ đắc lực cho những người muốn giảm mỡ ở các vùng khó giảm mà không lo ngại các tác dụng phụ về tăng trưởng cơ quan nội tạng. Nó có khả năng đốt cháy chất béo gấp 12.5 lần so với HGH thông thường khi xét về hiệu quả giảm mỡ cục bộ.',
            ),
            ThucPham(
              id: 'pep_igf1_r3',
              ten: 'IGF-1 long R3',
              theLoai: 'Peptide',
              hinhAnh: 'assets/onboarding/239.jpg',
              moTa:
                  'IGF-1 Long R3 là yếu tố tăng trưởng giống Insulin-1 mạnh mẽ nhất. Phiên bản này được sửa đổi để ngăn chặn sự liên kết với các protein vận chuyển, giúp nó hoạt động tự do và mạnh mẽ hơn gấp nhiều lần so với IGF-1 thông thường.\n\nCơ chế chính của nó là thúc đẩy quá trình tăng sản (hyperplasia), tạo ra các sợi cơ mới hoàn toàn thay vì chỉ làm phình to các tế bào sẵn có. Điều này giúp vận động viên vượt qua giới hạn di truyền về khối lượng cơ bắp và tạo ra mật độ cơ bắp dày đặc, săn chắc hơn.',
            ),
            ThucPham(
              id: 'pep_mt2',
              ten: 'Melanotan-2',
              theLoai: 'Peptide',
              hinhAnh: 'assets/onboarding/240.jpg',
              moTa:
                  'Melanotan-2 là một chất tương tự tổng hợp của hormone kích thích tế bào hắc tố. Trong giới thể hình, nó được biết đến với khả năng tạo ra một làn da sạm màu rám nắng mà không cần tiếp xúc quá nhiều với tia UV, giúp các khối cơ trông rõ nét và thẩm mỹ hơn trên sân khấu.\n\nNgoài tác dụng về sắc tố da, Melanotan-2 còn có tác động mạnh mẽ đến việc giảm cảm giác thèm ăn và tăng cường chuyển hóa chất béo, giúp vận động viên dễ dàng duy trì chế độ ăn kiêng khắt khe trong giai đoạn chuẩn bị thi đấu.',
            ),
            ThucPham(
              id: 'pep_pt141',
              ten: 'PT-141 (Bremelanotide)',
              theLoai: 'Peptide',
              hinhAnh: 'assets/onboarding/241.jpg',
              moTa:
                  'PT-141 là một dẫn xuất của Melanotan-2 nhưng tập trung hoàn toàn vào việc kích hoạt các thụ thể melanocortin trong hệ thần kinh trung ương. Khác với các sản phẩm hỗ trợ lưu thông máu, PT-141 tác động trực tiếp lên hệ thần kinh để cải thiện ham muốn và chức năng tình dục.\n\nTrong dược lý học thể thao, nó thường được sử dụng để cân bằng lại các vấn đề về hệ nội tiết và tâm lý thường gặp trong các chu kỳ sử dụng các chất hỗ trợ mạnh, giúp duy trì chất lượng cuộc sống và tinh thần ổn định cho vận động viên.',
            ),
          ],
        ),

        // --- MỤC 3: CÁC DẠNG THUỐC TIÊM ---
        ContentSection(
          title: 'Các dạng thuốc tiêm',
          isSupplement: true, // Đã thêm để ẩn Calo/Protein
          imageUrl: 'assets/onboarding/233.jpg',
          foods: [
            ThucPham(
              id: 'inj_boldenone',
              ten: 'Boldenone Undecylenate',
              theLoai: 'Injection',
              hinhAnh: 'assets/onboarding/242.jpg',
              moTa:
                  'Boldenone Undecylenate (Equipoise) nổi tiếng với khả năng cung cấp sự gia tăng cơ bắp ổn định, chất lượng và bền vững. Nó kích thích sự thèm ăn và tăng cường sản sinh hồng cầu, giúp cải thiện đáng kể lưu lượng oxy đến cơ bắp và tạo ra độ nổi mạch máu (vascularity) ấn tượng.\n\nĐây là một trong những hợp chất linh hoạt nhất, có thể sử dụng trong cả chu kỳ xả và siết. Nó không gây tích nước nhiều và có tỷ lệ chuyển đổi sang estrogen thấp, giúp người dùng tránh được các tác dụng phụ tiêu cực như giữ nước hay tích tụ mỡ dưới da.',
            ),
            ThucPham(
              id: 'inj_drosta',
              ten: 'Drostanolone Propionate',
              theLoai: 'Injection',
              hinhAnh: 'assets/onboarding/243.jpg',
              moTa:
                  'Drostanolone (Masteron) là "vũ khí bí mật" của các vận động viên trong giai đoạn cuối của chu kỳ siết mỡ. Nó có đặc tính chống estrogen tự nhiên, giúp cơ bắp trở nên khô, cứng và sắc nét tối đa. Masteron không giúp tăng khối lượng cơ khổng lồ nhưng lại mang lại độ tinh khiết tuyệt vời cho cơ bắp.\n\nNó hoạt động tốt nhất khi tỷ lệ mỡ cơ thể đã ở mức thấp, giúp loại bỏ lớp nước mỏng cuối cùng dưới da, để lộ ra những chi tiết cơ bắp nhỏ nhất. Nó cũng giúp tăng cường sức mạnh bùng nổ mà không làm tăng trọng lượng cơ thể không cần thiết.',
            ),
            ThucPham(
              id: 'inj_test_blend',
              ten: 'Hỗn hợp Este Testosterone',
              theLoai: 'Injection',
              hinhAnh: 'assets/onboarding/244.jpg',
              moTa:
                  'Hỗn hợp Este Testosterone (Sustanon) bao gồm các loại este khác nhau với tốc độ giải phóng từ nhanh đến chậm. Sự kết hợp này giúp duy trì nồng độ testosterone ổn định trong máu trong thời gian dài mà không cần phải tiêm quá thường xuyên, tạo ra môi trường đồng hóa liên tục.\n\nTestosterone là nền tảng của hầu hết các chu kỳ phát triển, giúp tăng cường tổng hợp protein, giữ nitơ và sản sinh IGF-1. Nó cung cấp sức mạnh thô, kích thước cơ bắp và khả năng phục hồi thần tốc, là thành phần thiết yếu cho bất kỳ mục tiêu phát triển hình thể nghiêm túc nào.',
            ),
            ThucPham(
              id: 'inj_primobolan',
              ten: 'Methenolone Enanthate',
              theLoai: 'Injection',
              hinhAnh: 'assets/onboarding/245.jpg',
              moTa:
                  'Methenolone (Primobolan) được coi là một trong những steroid an toàn và ít độc hại nhất. Nó có ái lực rất mạnh với thụ thể androgen, giúp đốt cháy chất béo trực tiếp và bảo vệ khối lượng cơ bắp quý giá ngay cả trong điều kiện thiếu hụt calo khắc nghiệt.\n\nPrimobolan không chuyển hóa thành estrogen, do đó không gây ra các tác dụng phụ như giữ nước hay tăng huyết áp. Đây là lựa chọn hàng đầu cho những ai ưu tiên sức khỏe lâu dài và muốn xây dựng một cơ thể săn chắc, nạc và cân đối hoàn hảo.',
            ),
            ThucPham(
              id: 'inj_deca',
              ten: 'Nandrolone Decanoate',
              theLoai: 'Injection',
              hinhAnh: 'assets/onboarding/246.jpg',
              moTa:
                  'Nandrolone Decanoate (Deca) là tiêu chuẩn vàng cho các chu kỳ tăng khối lượng. Nó thúc đẩy sự gia tăng đáng kể kích thước cơ bắp thông qua việc tăng cường giữ nitơ cực mạnh. Một đặc tính quý giá khác của Deca là khả năng bôi trơn khớp xương thông qua việc tăng lưu trữ nước trong các mô liên kết.\n\nĐiều này cực kỳ hữu ích cho các vận động viên nâng tạ nặng, giúp giảm thiểu các cơn đau khớp mãn tính. Deca có tốc độ giải phóng chậm, cung cấp tác động đồng hóa kéo dài và giúp cơ thể phục hồi tối đa sau những buổi tập phá hủy sợi cơ cường độ cao.',
            ),
            ThucPham(
              id: 'inj_npp',
              ten: 'Nandrolone Phenylpropionate',
              theLoai: 'Injection',
              hinhAnh: 'assets/onboarding/247.jpg',
              moTa:
                  'Nandrolone Phenylpropionate (NPP) mang lại những lợi ích tương tự như phiên bản Deca nhưng với tốc độ giải phóng nhanh hơn nhiều. Điều này cho phép nồng độ hoạt chất đạt đỉnh trong máu nhanh chóng và người dùng có thể nhận thấy kết quả về kích thước cơ bắp chỉ sau một thời gian ngắn.\n\nDo có este ngắn hơn, NPP ít gây giữ nước hơn so với Deca và có thể được kiểm soát dễ dàng hơn trong các chu kỳ ngắn. Nó hỗ trợ tổng hợp protein mạnh mẽ và phục hồi mô cơ, là lựa chọn tuyệt vời cho những ai muốn sức mạnh của Nandrolone mà không muốn thời gian chờ đợi lâu.',
            ),
          ],
        ),

        // --- MỤC 4: SẢN PHẨM DẠNG UỐNG ---
        ContentSection(
          title: 'Sản phẩm dạng uống',
          isSupplement: true, // Đã thêm để ẩn Calo/Protein
          imageUrl: 'assets/onboarding/234.jpg',
          foods: [
            ThucPham(
              id: 'oral_turinabol',
              ten: 'Chlordehydromethyltestosterone',
              theLoai: 'Oral',
              hinhAnh: 'assets/onboarding/248.jpg',
              moTa:
                  'Turinabol là một dạng dẫn xuất của Methandrostenolone được tinh chỉnh để giảm thiểu tác dụng phụ giữ nước. Nó mang lại sự gia tăng sức mạnh đáng kinh ngạc và khối lượng cơ nạc chất lượng cao mà không làm thay đổi vẻ ngoài của cơ thể theo hướng tích nước hay phù nề.\n\nNó giúp tăng cường sự bền bỉ của cơ bắp và giảm thời gian phục hồi giữa các hiệp tập. Do không thể chuyển hóa thành estrogen, Turinabol là lựa chọn an toàn để đạt được một vóc dáng cứng cáp, mạch máu và duy trì được phong độ lâu dài sau khi kết thúc chu kỳ.',
            ),
            ThucPham(
              id: 'oral_clomed',
              ten: 'Clomiphene Citrate',
              theLoai: 'Oral',
              hinhAnh: 'assets/onboarding/249.jpg',
              moTa:
                  'Clomiphene (Clomid) đóng vai trò then chốt trong giai đoạn hồi phục (PCT). Cơ chế của nó là ngăn chặn các tác động tiêu cực của estrogen lên tuyến yên, từ đó kích thích cơ thể bắt đầu tự sản sinh testosterone nội sinh trở lại sau một thời gian bị ức chế.\n\nViệc sử dụng Clomid giúp vận động viên duy trì được khối lượng cơ bắp đã đạt được trong chu kỳ, cân bằng lại hệ nội tiết và phục hồi chức năng tinh hoàn. Đây là bước không thể thiếu để đảm bảo sức khỏe sinh lý và tinh thần ổn định sau khi sử dụng các chất hỗ trợ.',
            ),
            ThucPham(
              id: 'oral_proviron',
              ten: 'Mesterolone',
              theLoai: 'Oral',
              hinhAnh: 'assets/onboarding/250.jpg',
              moTa:
                  'Mesterolone (Proviron) là một hợp chất độc đáo giúp tăng nồng độ testosterone tự do bằng cách liên kết mạnh mẽ với các globulin gắn kết hormone giới tính (SHBG). Điều này làm cho các steroid khác trong chu kỳ hoạt động hiệu quả hơn bằng cách giải phóng chúng vào máu.\n\nProviron cũng có khả năng chống estrogen nhẹ và mang lại độ cứng vượt trội cho cơ bắp. Nó thường được sử dụng để cải thiện độ nét, tăng cường ham muốn tình dục và tạo ra một trạng thái tinh thần tự tin, bùng nổ cho người sử dụng trong suốt quá trình tập luyện.',
            ),
            ThucPham(
              id: 'oral_dbol',
              ten: 'Methandienone',
              theLoai: 'Oral',
              hinhAnh: 'assets/onboarding/251.jpg',
              moTa:
                  'Methandienone (Dianabol) là huyền thoại trong giới thể hình về khả năng tăng kích thước và sức mạnh thần tốc. Nó hoạt động bằng cách tăng cường đáng kể quá trình tổng hợp protein và giữ nitơ trong tế bào cơ, tạo ra một sự thay đổi diện mạo rõ rệt chỉ sau vài tuần sử dụng.\n\nDianabol mang lại cảm giác hưng phấn và sức mạnh bùng nổ trong phòng tập, cho phép người dùng nâng những mức tạ kỷ lục. Dù có gây ra một chút giữ nước, nhưng khối lượng cơ bắp và sức mạnh mà nó mang lại là cực kỳ ấn tượng cho những ai muốn đạt được mục tiêu xả cơ lớn nhất có thể.',
            ),
            ThucPham(
              id: 'oral_anavar',
              ten: 'Oxandrolone',
              theLoai: 'Oral',
              hinhAnh: 'assets/onboarding/252.jpg',
              moTa:
                  'Oxandrolone (Anavar) được mệnh danh là "steroid cho phái đẹp" nhờ vào tính nhẹ nhàng và độ an toàn rất cao. Nó kích thích tổng hợp phosphocreatine trong tế bào cơ, cung cấp sức mạnh vượt trội mà không làm tăng trọng lượng cơ thể hay tích nước.\n\nAnavar cực kỳ hiệu quả trong việc đốt cháy mỡ thừa và làm săn chắc cơ bắp, mang lại vẻ ngoài khô và nét. Đây là lựa chọn hoàn hảo cho những ai muốn tăng hiệu suất tập luyện, cải thiện sức mạnh mà vẫn duy trì được vóc dáng cân đối, ít mỡ và không gặp phải các tác dụng phụ nghiêm trọng.',
            ),
            ThucPham(
              id: 'oral_anadrol',
              ten: 'Oxymetholone',
              theLoai: 'Oral',
              hinhAnh: 'assets/onboarding/253.jpg',
              moTa:
                  'Oxymetholone (Anadrol) là steroid dạng uống mạnh mẽ nhất từng được tạo ra. Nó có khả năng tăng trọng lượng cơ thể và sức mạnh một cách khủng khiếp chỉ trong thời gian cực ngắn. Anadrol kích thích sản sinh hồng cầu mạnh mẽ, mang lại sự bơm máu (pump) căng cứng đến mức khó tin khi tập luyện.\n\nNó giúp vận động viên vượt qua mọi giới hạn về sức mạnh và độ dày của cơ bắp. Dù đòi hỏi sự kiểm soát kỹ lưỡng về chế độ ăn uống và phục hồi, nhưng hiệu quả về kích thước cơ bắp mà Anadrol mang lại là không có đối thủ trong nhóm các sản phẩm dạng uống.',
            ),
          ],
        ),
      ],
    ),
    HandbookTopic(
      id: '5',
      title: 'Bách khoa toàn thư',
      description: 'Comprehensive health encyclopedia',
      imageUrl: 'assets/onboarding/5.jpg',
      sections: [
        // --- 254. Anabolic Steroid (Steroid đồng hóa) là gì? ---
        ContentSection(
          title: 'Anabolic Steroid (Steroid đồng hóa) là gì?',
          isSupplement: true,
          imageUrl: 'assets/onboarding/254.jpg',
          foods: [
            ThucPham(
              id: 'ency_254',
              ten:
                  'Anabolic Steroid (Steroid đồng hóa) là gì?', // Đồng bộ để vào thẳng chi tiết
              theLoai: 'Kiến thức',
              hinhAnh: 'assets/onboarding/254.jpg',
              moTa:
                  'Anabolic Steroids là các biến thể tổng hợp của hormone testosterone. Chúng thúc đẩy quá trình đồng hóa bằng cách tăng cường tổng hợp protein trong tế bào, dẫn đến sự phát triển nhanh chóng của các mô cơ bắp.\n\nTuy nhiên, việc sử dụng không có kiểm soát y tế có thể dẫn đến nhiều tác dụng phụ nghiêm trọng như tổn thương gan, biến đổi tâm sinh lý và gây mất cân bằng hệ thống nội tiết tự nhiên của cơ thể.',
            ),
          ],
        ),

        // --- 255. Bài tập khu cơ (Bài tập chuyên biệt) ---
        ContentSection(
          title: 'Bài tập khu cơ (Bài tập chuyên biệt)',
          isSupplement: true,
          imageUrl: 'assets/onboarding/255.jpg',
          foods: [
            ThucPham(
              id: 'ency_255',
              ten: 'Bài tập khu cơ (Bài tập chuyên biệt)',
              theLoai: 'Tập luyện',
              hinhAnh: 'assets/onboarding/255.jpg',
              moTa:
                  'Đây là các bài tập tập trung cô lập vào một nhóm cơ cụ thể (Isolation exercises). Thay vì tác động lên nhiều khớp, các bài tập này nhắm trực tiếp vào đích đến để cải thiện chi tiết, độ nét và khắc phục sự mất cân đối của cơ bắp.\n\nKết hợp bài tập khu cơ vào cuối buổi tập giúp tối ưu hóa sự bơm máu và tăng cường kết nối thần kinh-cơ cho nhóm cơ đó.',
            ),
          ],
        ),

        // --- 256. Béo bụng ---
        ContentSection(
          title: 'Béo bụng',
          isSupplement: true,
          imageUrl: 'assets/onboarding/256.jpg',
          foods: [
            ThucPham(
              id: 'ency_256',
              ten: 'Béo bụng',
              theLoai: 'Sức khỏe',
              hinhAnh: 'assets/onboarding/256.jpg',
              moTa:
                  'Béo bụng thường là biểu hiện của mỡ nội tạng tích tụ xung quanh các cơ quan quan trọng. Đây là loại mỡ nguy hiểm nhất, liên quan trực tiếp đến các bệnh lý về chuyển hóa.\n\nViệc giảm béo bụng đòi hỏi một chiến lược tổng thể từ dinh dưỡng thâm hụt calo, tập luyện kháng lực và đặc biệt là kiểm soát giấc ngủ cùng căng thẳng để điều chỉnh nồng độ hormone Cortisol.',
            ),
          ],
        ),

        // --- 257. Tạng người ---
        ContentSection(
          title:
              'Bạn thuộc tạng người nào: Ectomorph (gầy), Mesomorph (cơ bắp), Endomorph (béo)?',
          isSupplement: true,
          imageUrl: 'assets/onboarding/257.jpg',
          foods: [
            ThucPham(
              id: 'ency_257',
              ten:
                  'Bạn thuộc tạng người nào: Ectomorph (gầy), Mesomorph (cơ bắp), Endomorph (béo)?',
              theLoai: 'Sinh học',
              hinhAnh: 'assets/onboarding/257.jpg',
              moTa:
                  'Phân loại tạng người giúp bạn hiểu rõ xu hướng chuyển hóa của cơ thể:\n- Ectomorph: Khung xương nhỏ, khó tăng cân.\n- Mesomorph: Khung xương vừa, dễ tăng cơ và giữ dáng thể thao.\n- Endomorph: Khung xương lớn, dễ tích mỡ và tăng cân.\n\nViệc hiểu mình thuộc tạng người nào sẽ giúp bạn cá nhân hóa thực đơn và chương trình tập luyện để đạt hiệu quả nhanh nhất.',
            ),
          ],
        ),

        // --- 258. Carbohydrate đơn giản và carbohydrate phức tạp là gì? ---
        ContentSection(
          title: 'Carbohydrate đơn giản và carbohydrate phức tạp là gì?',
          isSupplement: true,
          imageUrl: 'assets/onboarding/258.jpg',
          foods: [
            ThucPham(
              id: 'ency_258',
              ten: 'Carbohydrate đơn giản và carbohydrate phức tạp là gì?',
              theLoai: 'Dinh dưỡng',
              hinhAnh: 'assets/onboarding/258.jpg',
              moTa:
                  'Carbohydrate là nhiên liệu chính cho mọi hoạt động thể chất. Carb đơn giản (đường, kẹo) cung cấp năng lượng tức thì nhưng nhanh cạn kiệt. Carb phức tạp (khoai, yến mạch) giải phóng năng lượng bền bỉ và giàu chất xơ.\n\nBiết cách lựa chọn loại Carb phù hợp cho từng thời điểm trong ngày giúp bạn duy trì mức năng lượng ổn định và kiểm soát cân nặng tốt hơn.',
            ),
          ],
        ),

        // --- 259. Cellulite ---
        ContentSection(
          title: 'Cellulite',
          isSupplement: true,
          imageUrl: 'assets/onboarding/259.jpg',
          foods: [
            ThucPham(
              id: 'ency_259',
              ten: 'Cellulite',
              theLoai: 'Thẩm mỹ',
              hinhAnh: 'assets/onboarding/259.jpg',
              moTa:
                  'Cellulite là tình trạng da sần sùi như vỏ cam do các mô mỡ dưới da đẩy lên qua lớp mô liên kết. Nó thường xuất hiện ở vùng đùi, mông và bụng.\n\nĐể cải thiện cellulite, bạn nên tập trung vào việc giảm tỷ lệ mỡ cơ thể tổng thể, tăng khối lượng cơ bắp bên dưới lớp da và đảm bảo cơ thể luôn đủ nước để duy trì độ đàn hồi của da.',
            ),
          ],
        ),

        // --- 260. Cheating là gì? ---
        ContentSection(
          title: 'Cheating là gì?',
          isSupplement: true,
          imageUrl: 'assets/onboarding/260.jpg',
          foods: [
            ThucPham(
              id: 'ency_260',
              ten: 'Cheating là gì?',
              theLoai: 'Kỹ thuật',
              hinhAnh: 'assets/onboarding/260.jpg',
              moTa:
                  'Cheating trong tập gym là việc sử dụng quán tính hoặc sự hỗ trợ từ các nhóm cơ khác để hoàn thành một lần lặp lại tạ. \n\nNếu được dùng đúng cách (controlled cheat) ở các reps cuối, nó giúp tăng cường áp lực lên cơ bắp. Tuy nhiên, nếu lạm dụng, nó sẽ làm mất hiệu quả bài tập và tăng nguy cơ chấn thương khớp nghiêm trọng.',
            ),
          ],
        ),

        // --- 261. Circuit training là gì? ---
        ContentSection(
          title: 'Circuit training là gì?',
          isSupplement: true,
          imageUrl: 'assets/onboarding/261.jpg',
          foods: [
            ThucPham(
              id: 'ency_261',
              ten: 'Circuit training là gì?',
              theLoai: 'Phương pháp',
              hinhAnh: 'assets/onboarding/261.jpg',
              moTa:
                  'Circuit training (Tập luyện xoay vòng) là phương pháp tập kết hợp 5-10 bài tập liên tục với thời gian nghỉ cực ngắn. \n\nĐây là cách hiệu quả nhất để cải thiện sức bền tim mạch và đốt cháy calo lớn trong thời gian ngắn. Phương pháp này rất phù hợp cho những người bận rộn muốn tối ưu hóa việc giảm mỡ và tăng sự dẻo dai.',
            ),
          ],
        ),
      ],
    ),
  ];
}
