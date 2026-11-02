import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/pages/bangumi_collection/controller.dart' as bangumi;
import 'package:xs/src/pages/bangumi_collection/models/bangumi_collection_model.dart'
    as bangumi_model;
import 'package:xs/src/pages/thread_collection/controller.dart' as thread;
import 'package:xs/src/pages/thread_collection/models/thread_collection_model.dart'
    as thread_model;

typedef JsonPageLoader = Future<Map<String, dynamic>> Function(
    String type, int page);

void main() {
  _paginationCases(
      'wish',
      (load) => bangumi.BangumiWishCollectionController(
          loadPage: (type, page) async =>
              bangumi_model.BangumiCollection.fromJson(
                  await load(type, page))));
  _paginationCases(
      'watch',
      (load) => bangumi.BangumiWatchCollectionController(
          loadPage: (type, page) async =>
              bangumi_model.BangumiCollection.fromJson(
                  await load(type, page))));
  _paginationCases(
      'watched',
      (load) => bangumi.BangumiWatchedCollectionController(
          loadPage: (type, page) async =>
              bangumi_model.BangumiCollection.fromJson(
                  await load(type, page))));
  _paginationCases(
      '',
      (load) => thread.ThreadAllCollectionController(
          loadPage: (type, page) async =>
              thread_model.ThreadCollection.fromJson(await load(type, page))));
  _paginationCases(
      'artwork',
      (load) => thread.ThreadArtworkCollectionController(
          loadPage: (type, page) async =>
              thread_model.ThreadCollection.fromJson(await load(type, page))));
  _paginationCases(
      'cosplay',
      (load) => thread.ThreadCosplayCollectionController(
          loadPage: (type, page) async =>
              thread_model.ThreadCollection.fromJson(await load(type, page))));
}

Map<String, dynamic> _response(int page, int id, {required bool next}) => {
      'error': false,
      'body': {
        'data': [
          {'id': id}
        ],
        'page': page,
        'prev': page > 1,
        'next': next,
        'total': 2,
      },
    };

List<int> _ids(dynamic controller) =>
    (controller.result as List).map((item) => item.id as int).toList();

void _paginationCases(
    String type, dynamic Function(JsonPageLoader) createController) {
  final label = type.isEmpty ? 'all pictures' : type;
  test('$label loads page 2 for next=true and replaces results on refresh',
      () async {
    final requests = <int>[];
    var refreshed = false;
    final controller = createController((requestedType, page) async {
      expect(requestedType, type);
      requests.add(page);
      return _response(page, refreshed ? 10 : page,
          next: !refreshed && page == 1);
    });
    addTearDown(controller.onClose);

    await controller.get();
    expect(_ids(controller), [1]);
    expect(controller.page.value, 1);
    expect(controller.hasMore.value, isTrue);
    await controller.more();
    expect(_ids(controller), [1, 2]);
    expect(controller.hasMore.value, isFalse);
    await controller.more();
    expect(requests, [1, 2]);

    refreshed = true;
    expect(await controller.reload(), isTrue);
    expect(_ids(controller), [10]);
    expect(controller.page.value, 1);
    expect(requests, [1, 2, 1]);
  });

  test('$label retries the failed next page without duplicating data',
      () async {
    final requests = <int>[];
    var failNext = true;
    final controller = createController((requestedType, page) async {
      requests.add(page);
      if (page == 2 && failNext) {
        failNext = false;
        throw StateError('temporary failure');
      }
      return _response(page, page, next: page == 1);
    });
    addTearDown(controller.onClose);

    await controller.get();
    await controller.more();
    expect(_ids(controller), [1]);
    expect(controller.page.value, 1);
    expect(controller.isLoading.value, isFalse);
    await controller.more();
    expect(_ids(controller), [1, 2]);
    expect(requests, [1, 2, 2]);
  });

  test('$label refresh ignores an older next-page request', () async {
    final pending = Completer<Map<String, dynamic>>();
    final requests = <int>[];
    var firstPages = 0;
    final controller = createController((requestedType, page) async {
      requests.add(page);
      if (page == 2) return pending.future;
      firstPages++;
      return _response(1, firstPages == 1 ? 1 : 10, next: firstPages == 1);
    });
    addTearDown(controller.onClose);

    await controller.get();
    final nextPage = controller.more();
    await controller.more();
    expect(await controller.reload(), isTrue);
    pending.complete(_response(2, 2, next: false));
    await nextPage;
    expect(_ids(controller), [10]);
    expect(controller.page.value, 1);
    expect(controller.isLoading.value, isFalse);
    expect(requests, [1, 2, 1]);
  });
}
