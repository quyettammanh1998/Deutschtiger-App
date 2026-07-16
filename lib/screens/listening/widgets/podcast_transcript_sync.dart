import 'package:deutschtiger/data/listening/podcast_models.dart';

/// Hàm thuần tính đồng bộ transcript-theo-thời-gian cho podcast player —
/// tách khỏi `EasyGermanPodcastPlayerPage` để giữ file trang chính dưới 200
/// dòng (không có state, chỉ tính toán từ vị trí phát hiện tại).

/// Từ đang phát (highlight) trong 1 câu, dựa trên vị trí phát hiện tại
/// [positionSeconds]. Trả về -1 nếu chưa từ nào bắt đầu.
int activeWordIndexAt(double positionSeconds, PodcastSentence sentence) {
  var idx = -1;
  for (var i = 0; i < sentence.words.length; i++) {
    if (sentence.words[i].start <= positionSeconds) idx = i;
  }
  return idx;
}

/// Câu đang phát (index) trong danh sách [sentences], dựa trên vị trí phát
/// hiện tại [positionSeconds].
int activeSentenceIndexAt(double positionSeconds, List<PodcastSentence> sentences) {
  var found = 0;
  for (var i = 0; i < sentences.length; i++) {
    if (sentences[i].start <= positionSeconds) {
      found = i;
    } else {
      break;
    }
  }
  return found;
}
