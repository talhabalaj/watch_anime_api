import 'package:gogoanime/gogoanime.dart';

Future<void> main(List<String> arguments) async {
  final obj = GogoAnimeScrapper();

  final result = await obj.searchAnime('Dragon Ball Super (Dub)');
  final detail = await obj.getAnimeDetail(result[0]);
  print(detail);
}
