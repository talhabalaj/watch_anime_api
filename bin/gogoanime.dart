import 'dart:io';

import 'package:gogoanime/AnimeDetail.dart';
import 'package:gogoanime/gogoanime.dart';
import 'package:dart_inquirer/dart_inquirer.dart';

Future<void> main(List<String> arguments) async {
  final answer = await Prompt([InputQuestion('search', 'Search')]).execute();
  final results = await GogoAnimeScrapper.searchAnime(answer['search']);
  final name = (await Prompt(
    [
      ListQuestion(
        'name',
        'Which one?',
        results.map((e) => e.title).toList(),
      ),
    ],
  ).execute())['name'];
  final wanted = results.firstWhere((e) => e.title == name);
  final wantedInfo = await wanted.getDetailedInfo();
  final page = (await Prompt(
    [
      ListQuestion(
        'page',
        'Which page?',
        wantedInfo.epPages.map((e) => '${e.startEp}-${e.endEp}').toList(),
      ),
    ],
  ).execute())['page'];
  final pageInfo =
      wantedInfo.epPages.firstWhere((e) => '${e.startEp}-${e.endEp}' == page);
  final episode = (await Prompt(
    [
      ListQuestion(
        'episode',
        'Which Episode?',
        pageInfo.episodes.map((e) => e.title).toList(),
      ),
    ],
  ).execute())['episode'];
  final episodeInfo = (await pageInfo.episodes
      .firstWhere((element) => element.title == episode)
      .getStreamingInfo())[0];
  await Process.run(
      'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
      ['--app=${episodeInfo.streamLink}']);
}
