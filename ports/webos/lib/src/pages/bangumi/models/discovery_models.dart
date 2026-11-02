import 'package:xs/protobuf/bangumi.pb.dart';

List<dynamic> discoveryList(Object? value) {
  if (value is! List) throw const FormatException('列表数据格式不正确');
  return value;
}

Map<String, dynamic> discoveryObject(Object? value) {
  if (value is! Map) throw const FormatException('数据格式不正确');
  return Map<String, dynamic>.from(value);
}

int _number(Object? value) => value is num ? value.toInt() : 0;
String _text(Object? value) => value is String ? value : '';

int _id(Map<String, dynamic> value) {
  final id = _number(value['id']);
  if (id <= 0) throw const FormatException('番剧编号缺失');
  return id;
}

class DiscoveryBangumi {
  const DiscoveryBangumi({
    required this.id,
    required this.title,
    required this.image,
    required this.tagline,
    required this.episode,
    required this.episodesTotal,
    required this.status,
    required this.date,
    required this.overview,
  });

  factory DiscoveryBangumi.fromJson(Object? value) {
    final json = discoveryObject(value);
    return DiscoveryBangumi(
      id: _id(json),
      title: _text(json['title']),
      image: _text(json['image']),
      tagline: _text(json['tagline']),
      episode: _number(json['episode']),
      episodesTotal: _number(json['episodes_total']),
      status: _text(json['status']),
      date: _number(json['date']),
      overview: _text(json['overview']),
    );
  }

  final int id;
  final String title;
  final String image;
  final String tagline;
  final int episode;
  final int episodesTotal;
  final String status;
  final int date;
  final String overview;

  bangumi_list_item_ toListItem() => bangumi_list_item_(
        id: id,
        title: title,
        image: image,
        tagline: tagline,
        episode: episode,
        episodesTotal: episodesTotal,
        status: status,
        date: date.toDouble(),
      );
}

class RecommendationSection {
  const RecommendationSection(this.title, this.items);

  factory RecommendationSection.fromJson(Object? value) {
    final json = discoveryObject(value);
    return RecommendationSection(_text(json['title']),
        discoveryList(json['list']).map(DiscoveryBangumi.fromJson).toList());
  }

  final String title;
  final List<DiscoveryBangumi> items;
}

class BangumiRecommendations {
  const BangumiRecommendations(this.carousel, this.sections);

  factory BangumiRecommendations.fromJson(Object? value) {
    final json = discoveryObject(value);
    return BangumiRecommendations(
      discoveryList(json['carousel']).map(DiscoveryBangumi.fromJson).toList(),
      discoveryList(json['data']).map(RecommendationSection.fromJson).toList(),
    );
  }

  final List<DiscoveryBangumi> carousel;
  final List<RecommendationSection> sections;

  bool get isEmpty =>
      carousel.isEmpty && sections.every((section) => section.items.isEmpty);
}

class BangumiCalendarEpisode {
  const BangumiCalendarEpisode(this.sort, this.date, this.name, this.future);

  factory BangumiCalendarEpisode.fromJson(Object? value) {
    final json = discoveryObject(value);
    return BangumiCalendarEpisode(
      json['sort'] is num ? json['sort'] as num : 0,
      _number(json['date']),
      _text(json['name']),
      json['future'] == true,
    );
  }

  final num sort;
  final int date;
  final String name;
  final bool future;
}

class BangumiCalendarItem {
  const BangumiCalendarItem({
    required this.id,
    required this.title,
    required this.image,
    required this.lang,
    required this.region,
    required this.genres,
    required this.episodes,
  });

  factory BangumiCalendarItem.fromJson(Object? value) {
    final json = discoveryObject(value);
    return BangumiCalendarItem(
      id: _id(json),
      title: _text(json['title']),
      image: _text(json['image']),
      lang: _text(json['lang']),
      region: discoveryList(json['region']).whereType<String>().toList(),
      genres: discoveryList(json['genres']).whereType<String>().toList(),
      episodes: discoveryList(json['episodes'])
          .map(BangumiCalendarEpisode.fromJson)
          .toList(),
    );
  }

  final int id;
  final String title;
  final String image;
  final String lang;
  final List<String> region;
  final List<String> genres;
  final List<BangumiCalendarEpisode> episodes;

  bangumi_list_item_ toListItem() => bangumi_list_item_(
        id: id,
        title: title,
        image: image,
        tagline: [lang, ...region, ...genres].join('/'),
      );
}

class BangumiCalendarDay {
  const BangumiCalendarDay(this.weekday, this.items);

  factory BangumiCalendarDay.fromJson(Object? value) {
    final json = discoveryObject(value);
    final weekday = json['sort'];
    if (weekday is! int || weekday < 0 || weekday > 6) {
      throw const FormatException('排期日期格式不正确');
    }
    return BangumiCalendarDay(weekday,
        discoveryList(json['list']).map(BangumiCalendarItem.fromJson).toList());
  }

  final int weekday;
  final List<BangumiCalendarItem> items;
}

class SearchTrend {
  const SearchTrend(this.value, this.count, this.date);

  factory SearchTrend.fromJson(Object? value) {
    final json = discoveryObject(value);
    return SearchTrend(
        _text(json['value']), _number(json['count']), _number(json['date']));
  }

  final String value;
  final int count;
  final int date;
}
