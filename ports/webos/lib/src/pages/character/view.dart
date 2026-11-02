import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/character/controller.dart';
import 'package:xs/src/pages/character/views/index.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/navbar.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/no_image.svg';
    final Widget noImage = SvgPicture.asset(assetName);
    RxDouble appBarHeight = 1.0.obs;
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    return GetBuilder(
        id: Get.arguments['id'],
        global: false,
        init: CharacterController(),
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            body: controller.obx((state) {
              return SafeArea(
                top: false,
                bottom: false,
                maintainBottomViewPadding: false,
                child: Obx(() {
                  return DefaultTabController(
                    length: controller.tabs.length,
                    child: NestedScrollView(
                      floatHeaderSlivers: false,
                      body: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          final pixels = notification.metrics.pixels.toInt();
                          if ((pixels - scrollHeight.value).abs() >= 50) {
                            final lastScrollStatus = scrollStatus.value;
                            if (pixels > scrollHeight.value) {
                              if (notification.depth > 0 &&
                                  lastScrollStatus != false) {
                                scrollStatus(false);
                                controller.animationController.forward();
                                debugPrint('向下');
                              }
                            } else if (pixels < scrollHeight.value) {
                              if (lastScrollStatus != true) {
                                scrollStatus(true);
                                controller.animationController.reverse();
                                debugPrint('向上');
                              }
                            }
                            scrollHeight(pixels);
                          }
                          return false;
                        },
                        child: TabBarView(
                          controller: controller.tabController,
                          children: [
                            CharacterIndexView(
                              active: controller.tabIndex.value == 0,
                            )
                          ],
                        ),
                      ),
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverOverlapAbsorber(
                            sliver: SliverAppBar(
                              title: Obx(() {
                                return CustomDragToMoveArea(
                                    child: Opacity(
                                  opacity: min(appBarHeight.value.abs(), 1.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text('${state.name}')),
                                    ],
                                  ),
                                ));
                              }),
                              actions: [closeWindowButton(positioned: false)],
                              pinned: true,
                              automaticallyImplyLeading: false,
                              floating: true,
                              snap: false,
                              expandedHeight: 230, //180,
                              collapsedHeight: 50,
                              toolbarHeight: 50,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              surfaceTintColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                              flexibleSpace: LayoutBuilder(
                                builder: (context, constraints) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    appBarHeight(1 -
                                        max(
                                                0,
                                                constraints.biggest.height -
                                                    130 -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top) /
                                            100);
                                  });
                                  return Obx(() {
                                    return Opacity(
                                      opacity: min(
                                          1.0,
                                          max((appBarHeight.value - 1).abs(),
                                              0.0)),
                                      child: CustomDragToMoveArea(
                                        child: FlexibleSpaceBar(
                                          background: Stack(
                                            children: [
                                              ShaderMask(
                                                shaderCallback: (rect) {
                                                  return LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.black
                                                            .withAlpha(100),
                                                        Colors.transparent
                                                      ]).createShader(
                                                      Rect.fromLTRB(
                                                          0,
                                                          0,
                                                          rect.width,
                                                          rect.height));
                                                },
                                                blendMode: BlendMode.dstIn,
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    state.image.isNotEmpty
                                                        ? Image.network(
                                                            '${state.image}',
                                                            fit: BoxFit.cover,
                                                          )
                                                        : noImage,
                                                    BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 10,
                                                          sigmaY: 10),
                                                      child: Container(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .padding
                                                            .top +
                                                        10,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 120,
                                                          child: AspectRatio(
                                                            aspectRatio: 1 / 1,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .bottomCenter,
                                                                children: [
                                                                  SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                    child: state
                                                                            .image
                                                                            .isNotEmpty
                                                                        ? Image
                                                                            .network(
                                                                            '${state.image}',
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : noImage,
                                                                  ),
                                                                  Positioned
                                                                      .fill(
                                                                    child:
                                                                        Container(
                                                                      constraints:
                                                                          const BoxConstraints(
                                                                              minWidth: double.infinity),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          begin:
                                                                              Alignment.bottomCenter,
                                                                          end: Alignment
                                                                              .topCenter,
                                                                          stops: const [
                                                                            0,
                                                                            1
                                                                          ],
                                                                          colors: [
                                                                            Colors.black.withAlpha(5),
                                                                            Colors.black.withAlpha(10),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${state.name}',
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    const TextStyle(
                                                                  height: 0,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              state.aka
                                                                      .isNotEmpty
                                                                  ? Text(
                                                                      state.aka
                                                                          .join(
                                                                              '、'),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: const TextStyle(
                                                                          height:
                                                                              0,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  : Container(),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              SizedBox(
                                                                height: 60,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  child: Text(
                                                                    '简介: ${state.summary.isNotEmpty ? state.summary : "暂无"}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Offstage(
                                                      offstage:
                                                          appBarHeight.value >
                                                              0.7,
                                                      child: SizedBox(
                                                        height: 50,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (itemBuilder,
                                                                  index) {
                                                            return Container(
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      minWidth:
                                                                          100),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10,
                                                                      right: 5),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                child: Material(
                                                                  color: Colors
                                                                      .black
                                                                      .withAlpha(
                                                                          20),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Get.toNamed(
                                                                          '/person',
                                                                          arguments: {
                                                                            'id':
                                                                                state.actors[index].id
                                                                          });
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(50),
                                                                            child:
                                                                                Container(
                                                                              width: 30,
                                                                              height: 30,
                                                                              color: Colors.black.withAlpha(20),
                                                                              child: state.actors[index].image != null
                                                                                  ? Image.network(
                                                                                      state.actors[index].image,
                                                                                      fit: BoxFit.cover,
                                                                                      errorBuilder: (context, error, stackTrace) {
                                                                                        return noImage;
                                                                                      },
                                                                                    )
                                                                                  : Center(
                                                                                      child: Text(
                                                                                        state.actors[index].name.substring(0, 1),
                                                                                        style: const TextStyle(color: Colors.white, fontSize: 25),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                          Text(
                                                                              state.actors[index].name,
                                                                              maxLines: 1,
                                                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          itemCount: state
                                                              .actors.length,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          // centerTitle: true,
                                          collapseMode: CollapseMode.pin,
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                              bottom: PreferredSize(
                                preferredSize: const Size.fromHeight(50),
                                child: Material(
                                  color: Colors.transparent,
                                  // color: Theme.of(context).scaffoldBackgroundColor,
                                  child: TabBar(
                                    controller: controller.tabController,
                                    tabAlignment: TabAlignment.start,
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    dividerColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    tabs: controller.tabs,
                                  ),
                                ),
                              ),
                            ),
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                        ];
                      },
                    ),
                  );
                }),
              );
            }),
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SlideTransition(
                  position: Tween(begin: Offset.zero, end: const Offset(0, 1.0))
                      .animate(controller.animationController),
                  child: NavBar(
                    children: [
                      NavItem(
                          icon: Icons.arrow_back,
                          title: '返回',
                          onTap: () => Get.back()),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
