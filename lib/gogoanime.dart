import 'package:dio/dio.dart';
import 'package:gogoanime/models/AnimeSearchResult.dart';
import 'package:html/parser.dart' as parser;

import 'models/AnimeDetail.dart';

class GogoAnimeScrapper {
  Dio scrapper;

  GogoAnimeScrapper() {
    scrapper = Dio(
      BaseOptions(baseUrl: 'https://www26.gogoanimes.tv'),
    );
  }

  Future<List<AnimeSearchResult>> searchAnime(String query) async {
    var res = await scrapper.get(
      '/search.html',
      queryParameters: {
        'keyword': query,
        'id': -1,
      },
      options: Options(
        headers: {'x-requested-with': 'XMLHttpRequest'},
      ),
    );
    var doc = parser.parse(res.data);
    var elements = doc.querySelectorAll('.list_search_ajax > a');
    var searchResults = elements
        .map<AnimeSearchResult>(
          (element) => AnimeSearchResult(
            title: element.attributes['title'],
            detailsUrl: element.attributes['href'],
          ),
        )
        .toList();

    return searchResults;
  }

  AnimeEpisodeStreamingInfo getStreamInfo(AnimeEpisode ep) {
    assert(ep.link != null, 'ep link should not be null');
  }

  Future<AnimeDetail> getAnimeDetail(AnimeSearchResult anime) async {
    assert(anime.detailsUrl != null, 'anime detial url doesnt exist');
    var res = await scrapper.get(
      anime.detailsUrl,
    );

    var doc = parser.parse(res.data);

    // Collect info
    var infoElement = doc.querySelector('div.anime_info_body_bg');

    var imgUrl = infoElement.querySelector('img').attributes['src'];
    var title = anime.title;

    var textElements = infoElement.querySelectorAll('p.type');
    var plotSummary = textElements[1].nodes.last.text;
    var otherName = textElements[2].nodes.last.text;
    var year = int.tryParse(textElements[4].nodes.last.text);

    var movieId = doc.querySelector('#movie_id')?.attributes['value'];
    var defaultEp = doc.querySelector('#default_ep').attributes['value'];

    // Collect episode links
    var epElement = doc.querySelector('div.anime_video_body');
    var pagesElement = epElement.querySelectorAll('#episode_page > li > a');

    var pages = <AnimeEpPage>[];

    for (final e in pagesElement) {
      var startEp = int.tryParse(e.attributes['ep_start']);
      var endEp = int.tryParse(e.attributes['ep_end']);
      var eps = await _getEpisodeList(
        startEp: startEp,
        endEp: endEp,
        movieId: movieId,
        defaultEp: defaultEp,
      );

      pages.add(
        AnimeEpPage(
          startEp: startEp,
          episodes: eps,
          endEp: endEp,
        ),
      );
    }

    return AnimeDetail(
      coverImageUrl: imgUrl,
      defaultEp: int.tryParse(defaultEp),
      movieId: int.tryParse(defaultEp),
      otherName: otherName,
      plotSummary: plotSummary,
      releaseYear: year,
      title: title,
      epPages: pages,
    );
  }

  Future<List<AnimeEpisode>> _getEpisodeList(
      {int startEp, int endEp, String movieId, String defaultEp}) async {
    var res = await scrapper.get('/load-list-episode', queryParameters: {
      'ep_start': startEp,
      'ep_end': endEp,
      'id': movieId,
      'default_ep': defaultEp
    });

    var epDoc = parser.parse(res.data);
    var eps =
        epDoc.querySelectorAll('#episode_related > li > a').map<AnimeEpisode>(
              (e) => AnimeEpisode(
                link: e.attributes['href'].toString().trim(),
                title: e.querySelector('.name')?.text.toString().trim(),
              ),
            );

    return eps.toList().reversed.toList();
  }
}
