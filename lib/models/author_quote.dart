import 'dart:math';

class AuthorQuote {
  String? content;
  String? author;

  AuthorQuote({
    this.content,
    this.author,
  });

  factory AuthorQuote.fromJson(Map<String, dynamic> json, int? count) {
    if (count == null) {
      return AuthorQuote(
        content: json['content'],
        author: json['author'],
      );
    } else {
      int random = 0 + Random().nextInt(count - 0);
      return AuthorQuote(
        content: json["results"][random]["content"],
        author: json["results"][random]["author"],
      );
    }
  }

  Map<String, dynamic> toJsonForSP() => {
        'content': content,
        'author': author,
      };
}
