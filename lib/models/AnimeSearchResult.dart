import 'package:gogoanime/gogoanime.dart';
import 'package:gogoanime/AnimeDetail.dart';

class AnimeSearchResult {
  final String title;
  final String detailsUrl;
  final String coverImageUrl;

  AnimeSearchResult({this.title, this.detailsUrl, this.coverImageUrl});

  Future<AnimeDetail> getDetailedInfo() {
    return GogoAnimeScrapper.getAnimeDetail(this);
  }
}
