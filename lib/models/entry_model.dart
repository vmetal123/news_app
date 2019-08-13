class Entry {
  final String id, title, link;

  Entry({
    this.id,
    this.title,
    this.link,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    id: json['Id'],
    title: json['Title'],
    link: json['Link'],
  );
}
