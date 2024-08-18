import 'dart:convert';

class Poetry {
  String? content;
  String? origin;
  String? author;
  String? category;
  int? fetchDate;

  Poetry({this.content, this.origin, this.author, this.category, this.fetchDate});

  @override
  String toString() {
    return 'Poetry(content: $content, origin: $origin, author: $author, category: $category)';
  }

  factory Poetry.fromMap(Map<String, dynamic> data) => Poetry(
        content: data['content'] as String?,
        origin: data['origin'] as String?,
        author: data['author'] as String?,
        category: data['category'] as String?,
        fetchDate: data['fetchDate'] == null ? null : int.parse(data['fetchDate']),
      );

  Map<String, dynamic> toMap() => {
        'content': content,
        'origin': origin,
        'author': author,
        'category': category,
        'fetchDate': '${fetchDate ?? ""}',
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Poetry].
  factory Poetry.fromJson(String data) {
    return Poetry.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Poetry] to a JSON string.
  String toJson() => json.encode(toMap());
}
