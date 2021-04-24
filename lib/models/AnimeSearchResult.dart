class AnimeSearchResult {
  final String title;
  final String detailsUrl;
  final String coverImageUrl;

  AnimeSearchResult({this.title, this.detailsUrl, this.coverImageUrl});

  @override
  String toString() {
  return '$title - $detailsUrl';
   }
}

