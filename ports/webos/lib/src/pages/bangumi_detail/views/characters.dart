import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:xs/src/pages/bangumi_detail/controller.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';

class BangumiDetailCharactersView extends StatelessWidget {
  const BangumiDetailCharactersView({super.key, this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/no_image.svg';
    final Widget noImage = SvgPicture.asset(assetName);
    if (!PlatformInfo.isWebOS) {
      Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
      // 设置状态栏图标的亮度
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: currentBrightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ));
    }
    return GetBuilder(
        id: Get.currentRoute,
        global: false,
        init: BangumiDetailCharactersController(),
        builder: (controller) {
          return SafeArea(
            top: false,
            bottom: false,
            maintainBottomViewPadding: true,
            child: Builder(builder: (context) {
              final parentController = PrimaryScrollController.of(context);
              final scrollController =
                  SubordinateScrollController(parentController);
              return KeepAliveWrapper(
                  child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  if (metrics.atEdge) {
                    bool isTop = metrics.pixels == 0;
                    if (isTop) {
                    } else {
                      // if (controller.isLoading.isFalse) {
                      //   controller.more();
                      // }
                    }
                  }
                  return false;
                },
                child: RefreshIndicator(
                  displacement: 40,
                  edgeOffset: 60,
                  onRefresh: () async {
                    await controller.reload();
                  },
                  child: controller.obx((state) {
                    return CustomScrollView(
                      key: const PageStorageKey('bangumi-detail-characters'),
                      controller:
                          active ? scrollController : ScrollController(),
                      shrinkWrap: true,
                      slivers: [
                        SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context)),
                        SliverPadding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          sliver: SliverGrid.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 150,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.7),
                              itemCount: state!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/character',
                                        arguments: {'id': state[index].id});
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                child: Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomCenter,
                                                  // fit: StackFit.expand,
                                                  children: [
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                        ),
                                                        child: Stack(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          children: [
                                                            state[index]
                                                                    .image
                                                                    .isEmpty
                                                                ? noImage
                                                                : Image.network(
                                                                    state[index]
                                                                        .image,
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return noImage;
                                                                    },
                                                                  ),
                                                            Positioned.fill(
                                                              child: Container(
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        minWidth:
                                                                            double.infinity),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .bottomCenter,
                                                                    end: Alignment
                                                                        .topCenter,
                                                                    stops: const [
                                                                      0,
                                                                      1
                                                                    ],
                                                                    colors: [
                                                                      Colors
                                                                          .black
                                                                          .withAlpha(
                                                                              5),
                                                                      Colors
                                                                          .black
                                                                          .withAlpha(
                                                                              10),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.toNamed(
                                                              '/character',
                                                              arguments: {
                                                                'id':
                                                                    state[index]
                                                                        .id
                                                              });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            state[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Opacity(
                                            opacity: 0.7,
                                            child: Text(
                                              state[index].role,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          Text.rich(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(children: [
                                              const TextSpan(text: 'CV: '),
                                              if (state[index].actors.isEmpty)
                                                const TextSpan(text: '未知'),
                                              ...state[index].actors.map((e) {
                                                return WidgetSpan(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed('/person',
                                                            arguments: {
                                                              'id': e.id
                                                            });
                                                      },
                                                      child: Text(
                                                        e.name,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ]),
                                            // 'CV: ${state[index].actors.isNotEmpty ? state[index].actors.map((e) => e.name).toList().join('、') : '未知'}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  }),
                ),
              ));
            }),
          );
        });
  }
}
