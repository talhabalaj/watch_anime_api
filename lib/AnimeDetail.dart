import 'package:gogoanime/gogoanime.dart';

class AnimeDetail {
  final String title;
  final String coverImageUrl;
  final String plotSummary;
  final String otherName;
  final int releaseYear;
  final int movieId;
  final int defaultEp;
  final List<AnimeEpPage> epPages;

  AnimeDetail({
    this.epPages,
    this.title,
    this.coverImageUrl,
    this.plotSummary,
    this.otherName,
    this.releaseYear,
    this.movieId,
    this.defaultEp,
  });
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

  Future<List<AnimeEpisodeStreamInfo>> getStreamingInfo() {
    return GogoAnimeScrapper.getStreamInfo(this);
  }
}

abstract class AnimeEpisodeStreamInfo {
  String serverName;
  String streamLink;

  AnimeEpisodeStreamInfo({
    this.serverName,
    this.streamLink,
  });

  factory AnimeEpisodeStreamInfo.factory(
      {String serverName, String streamLink}) {
    if (serverName == VidStreamingStreamInfo.ServerName) {
      return VidStreamingStreamInfo(streamLink: streamLink);
    }

    return DefaultStreamInfo(streamLink: streamLink);
  }
}

class DefaultStreamInfo extends AnimeEpisodeStreamInfo {
  static String ServerName = 'DEFAULT';

  DefaultStreamInfo({String streamLink})
      : super(serverName: ServerName, streamLink: streamLink);
}

class VidStreamingStreamInfo extends AnimeEpisodeStreamInfo {
  static String ServerName = 'VIDSTREAMING';

  VidStreamingStreamInfo({String streamLink})
      : super(serverName: ServerName, streamLink: streamLink);
}
