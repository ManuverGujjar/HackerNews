class NewsItem {
  final int id;
  final String title;
  final String? text;
  final DateTime time;
  final String? by;
  final List<int>? kids;
  final String? url;
  bool? isFavorite;
  final int score;

  NewsItem({
    required this.id,
    required this.title,
    required this.by,
    this.text,
    required this.time,
    required this.score,
    this.url,
    this.isFavorite = false,
  }) : kids = List.empty();

  static Map<String, Object> toJson(NewsItem newsItem) {
    return {
      "id": newsItem.id,
      "title": newsItem.title,
      "text": newsItem.text ?? "",
      "time": newsItem.time.toIso8601String(),
      "url": newsItem.url ?? "",
      "score": newsItem.score,
      "by": newsItem.by ?? "",
      "isFavorite": newsItem.isFavorite ?? false,
    };
  }

  static NewsItem fromJson(Map<String, dynamic> json) {
    return NewsItem(
        id: json['id'],
        title: json['title'],
        text: json['text'],
        time: DateTime.fromMillisecondsSinceEpoch((json['time'] * 1000)),
        score: json['score'],
        url: json['url'] == '' ? null : json['url'],
        by: json['by'] ?? "_",
        isFavorite: json['isFavorite'] ?? false);
  }
}
