class AnimeDetail {
  final String title;
  final String coverImageUrl;
  final String plotSummary;
  final String otherName;
  final int releaseYear;
  final int movieId;
  final int defaultEp;
  final List<AnimeEpPage> epPages;

  AnimeDetail(
      {this.epPages,
      this.title,
      this.coverImageUrl,
      this.plotSummary,
      this.otherName,
      this.releaseYear,
      this.movieId,
      this.defaultEp});
}

class AnimeEpPage {
  final int startEp;
  final int endEp;
  final List<AnimeEpisode> episodes;

  AnimeEpPage({this.startEp, this.endEp, this.episodes});
}

class AnimeEpisode {
  final String link;
  final String title;

  AnimeEpisode({this.link, this.title});
}

class AnimeEpisodeStreamingInfo {
  final String serverName;
  final String streamLink;

  AnimeEpisodeStreamingInfo({
    this.serverName,
    this.streamLink,
  });
}
