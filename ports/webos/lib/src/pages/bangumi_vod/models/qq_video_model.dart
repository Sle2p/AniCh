// https://jsontodart.zariman.dev/

class QqVideoModel {
  List<BarrageList>? barrageList;

  QqVideoModel({this.barrageList});

  QqVideoModel.fromJson(Map<String, dynamic> json) {
    barrageList = json['barrage_list'] == null
        ? null
        : (json['barrage_list'] as List)
            .map((e) => BarrageList.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (barrageList != null) {
      data['barrage_list'] = barrageList?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class BarrageList {
  String? id;
  int? isOp;
  String? headUrl;
  String? timeOffset;
  String? upCount;
  String? bubbleHead;
  String? bubbleLevel;
  String? bubbleId;
  int? rickType;
  String? contentStyle;
  int? userVipDegree;
  String? createTime;
  String? content;
  int? hotType;
  dynamic giftInfo;
  dynamic shareItem;
  String? vuid;
  String? nick;
  String? dataKey;
  num? contentScore;
  int? showWeight;
  int? trackType;
  int? showLikeType;
  int? reportLikeScore;
  List<dynamic>? relateSkuInfo;

  BarrageList(
      {this.id,
      this.isOp,
      this.headUrl,
      this.timeOffset,
      this.upCount,
      this.bubbleHead,
      this.bubbleLevel,
      this.bubbleId,
      this.rickType,
      this.contentStyle,
      this.userVipDegree,
      this.createTime,
      this.content,
      this.hotType,
      this.giftInfo,
      this.shareItem,
      this.vuid,
      this.nick,
      this.dataKey,
      this.contentScore,
      this.showWeight,
      this.trackType,
      this.showLikeType,
      this.reportLikeScore,
      this.relateSkuInfo});

  BarrageList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isOp = json['is_op'];
    headUrl = json['head_url'];
    timeOffset = json['time_offset'];
    upCount = json['up_count'];
    bubbleHead = json['bubble_head'];
    bubbleLevel = json['bubble_level'];
    bubbleId = json['bubble_id'];
    rickType = json['rick_type'];
    contentStyle = json['content_style'];
    userVipDegree = json['user_vip_degree'];
    createTime = json['create_time'];
    content = json['content'];
    hotType = json['hot_type'];
    giftInfo = json['gift_info'];
    shareItem = json['share_item'];
    vuid = json['vuid'];
    nick = json['nick'];
    dataKey = json['data_key'];
    contentScore = json['content_score'];
    showWeight = json['show_weight'];
    trackType = json['track_type'];
    showLikeType = json['show_like_type'];
    reportLikeScore = json['report_like_score'];
    relateSkuInfo = json['relate_sku_info'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_op'] = isOp;
    data['head_url'] = headUrl;
    data['time_offset'] = timeOffset;
    data['up_count'] = upCount;
    data['bubble_head'] = bubbleHead;
    data['bubble_level'] = bubbleLevel;
    data['bubble_id'] = bubbleId;
    data['rick_type'] = rickType;
    data['content_style'] = contentStyle;
    data['user_vip_degree'] = userVipDegree;
    data['create_time'] = createTime;
    data['content'] = content;
    data['hot_type'] = hotType;
    data['gift_info'] = giftInfo;
    data['share_item'] = shareItem;
    data['vuid'] = vuid;
    data['nick'] = nick;
    data['data_key'] = dataKey;
    data['content_score'] = contentScore;
    data['show_weight'] = showWeight;
    data['track_type'] = trackType;
    data['show_like_type'] = showLikeType;
    data['report_like_score'] = reportLikeScore;
    if (relateSkuInfo != null) {
      data['relate_sku_info'] = relateSkuInfo;
    }
    return data;
  }
}
