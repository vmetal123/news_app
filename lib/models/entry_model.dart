class Entry {
  final String id, title, link, imageUrl, previewHistory;

  Entry({
    this.id,
    this.title,
    this.link,
    this.imageUrl,
    this.previewHistory,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    id: json['id'],
    title: json['title'],
    link: json['link'],
    imageUrl: json['imageUrl'],
    previewHistory: json['previewHistory']
  );
}
