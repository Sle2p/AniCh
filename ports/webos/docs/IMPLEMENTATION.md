# webOS 移植实施说明

本文面向审阅者和后续维护者，说明 TV 1.0.11 独立 `ports/webos` 子项目的实现及验证边界。以下路径以该子项目为基准，验证结果统一列于文末。

## 范围与目录

本次移植以 AniCh 公开提交 `c5729a28af239aec78c7059ad122ff00f3f7c47a` 为基线。公开 README 将源码标为 1.0.0，因此这里没有把“对照后续发行版补充部分功能”描述成后续版本源码的完整移植。

```text
ports/webos/
├── README.md
├── pubspec.yaml / pubspec.lock
├── lib/                          # 电视版应用、页面、接口、播放器及弹幕
├── assets/                       # 原应用资源
├── fonts/                        # Noto Sans SC 及其 OFL/来源文件
├── webos/
│   ├── runner/                   # 原生启动、严格读取 DPR 偏好
│   ├── meta/                     # appinfo、flutter-conf、打包配置
│   └── LICENSE
├── third_party/video_player_webos/
│   ├── LICENSE
│   └── ANICH_PATCHES.md
├── test/                         # Flutter 回归与 native parser 测试
└── docs/IMPLEMENTATION.md
```

原仓库根目录继续承载上游多平台应用。本子项目有独立依赖图和电视专用播放器，避免直接把 webOS 后端替换到根应用的其他平台。根 README 只增加入口。移植没有完成跨平台统一抽象，也不宣称去掉 `ANICH_WEBOS` 参数就能构建成原来的桌面／手机应用。

## 平台与启动

`lib/src/utils/platform_info.dart` 使用编译常量 `ANICH_WEBOS`，因为 Dart 在 webOS 上也会报告 Linux；仅检查 `Platform.isLinux` 会误启用桌面窗口和插件逻辑。

TV 启动路径跳过桌面 MediaKit 初始化、桌面窗口管理及不适用的系统 UI 操作，使用 `/bangumi` 页面和固定电视导航。`package_info_plus_webos`、`path_provider_webos`、`url_launcher_webos`、`device_info_plus_webos` 固定到同一 LG 插件提交。

`webos/meta/appinfo.json` 使用 native 类型、`main: xs`、`transparent: true` 与 `resolution: 1920x1080`。透明表面是独立视频层显示的必要条件。原生入口在 LG SDK 的 `OnBuildViewProperties` 中固定逻辑宽高，不修改电视合成器或系统服务。

## 播放架构

```text
番剧详情 / 选集 / 选线
          ↓
BangumiVodController：来源、续播、自动连播与换线
          ↓
webos_player.dart：播放状态与生命周期适配
          ↓
video_player → 本地 LG video_player_webos
          ↓
LG 原生视频播放器 / 独立视频 plane

Flutter 界面：透明 Hole + 弹幕 + 播放控制层
```

`lib/src/widgets/player/webos_player.dart` 将现有页面使用的状态和事件接到 `video_player`，包括初始化、播放、暂停、进度、尺寸、缓冲、完成、错误和速度。初始化设置时限，释放控制器也设置有界等待；切源、切集和离页使用请求代次拒绝过时结果，避免旧请求覆盖当前播放状态。

`lib/src/pages/bangumi_vod/controller.dart` 负责上层策略：

- 单次播放失败最多自动切换 4 次，跟踪已尝试来源，允许从列表末尾环绕；用户手动选择或换集重置预算。
- 成功播放后按番剧保存来源标识，不用完整时效播放 URL 作为跨集匹配键。
- 仅在真实完成状态触发自动连播，避免暂停或初始化状态被误判为结束。
- 按集保存观看进度。换源／载入中、离页后或零进度采样不覆盖原有续播记录。
- 非 1 倍速度被播放器明确拒绝时回退 1 倍，并同步界面显示；不把网络或其他任意异常都伪装成倍速不支持。
- 适配层拒绝显式传入的自定义 HTTP 请求头；当前播放源接入未提供此能力，依赖特定请求头的线路可能播放失败，随后按配置换线。

TV 播放设置在 `pages/settings/storage/playback_storage.dart` 保存。提供 0.5–2 倍的离散速度、原始／铺满／16:9／4:3 比例、左右独立 5／10／15／30／60 秒快进退，以及自动连播、自动换线、自动全屏和线路记忆。

## 本地 LG 视频插件补丁

基线为 `lg-flutter-webos/plugins` 的 `3a742bb86b04e261044f0864f9b1f71acf0bbad3`，目录 `packages/video_player`。保持可审阅的本地副本，通过 `path:` 依赖引用。最终修改清单以 [ANICH_PATCHES.md](../third_party/video_player_webos/ANICH_PATCHES.md) 为准。

已完成的行为修正：

1. **默认音量初始化。** 标准 `VideoPlayerController` 初始化会设置音量 1.0，而 LG 实现原本对任何音量都返回不支持。Dart 平台层只把默认 `1.0` 当成无操作，其他值继续返回不支持；这没有实现独立音量控制。
2. **生命周期。** 卸载视频 widget 时取消定时器、停止帧后更新并移除旧 state，避免切集／退出后对已卸载对象执行布局更新。
3. **视频目的矩形。** 使用真实 `View.devicePixelRatio` 将 RenderBox 的位置和尺寸转换为物理像素，再缓存并发送到 exported-window 接口。源视频矩形仍是视频像素，Flutter `Hole` 仍是逻辑坐标，避免重复缩放。纯 DPR 变化也会触发新矩形。

4. **独立日志实现。** 原 `webos/log.h` 和 `webos/log.cc` 带有文件级 `LicenseRef-LGE-Proprietary`，不能仅凭目录级 BSD 文件认定其授权。本移植完整替换这两个实现，采用独立编写的 BSD-3-Clause RAII 标准错误输出 logger，保留现有五个 `Log*(tag) << ...` 调用形式。它只依赖 C++ 标准库，支持普通流插入和格式控制，析构不抛异常；不改视频 API 或 CMake。插件 LICENSE 增加这两个新文件的贡献者版权，同时保留上游 BSD 全文。

## 弹幕绘制与数据管线

### 可见边界

弹幕视口取自播放器实际可见视频矩形，处理原始比例、拉伸、指定比例和黑边。描边宽度、字体缩放和行高采用一致测量；分配轨道时留安全边距，最后以裁剪限制在视频区域内。小视口不能产生负的可用范围。进入全屏、退出全屏及调整画面比例时重新使用当前视口。

LG 视频层依靠 Flutter 透明区域显示，因此 TV 布局避免把整个视频区放入不透明离屏淡出层。视频目的矩形和 Flutter 弹幕层共用相同的逻辑布局，但各自按正确坐标系呈现。

弹幕时间使用实际经过时间并遵守暂停语义，移除了每 1ms 回调只累加固定 0.001 的计时方式。隐藏和暂停时协调动画状态，暂停／继续不会重新覆盖用户在本次播放中手动选择的弹幕开关。

### 精确去重与迟到响应

重复弹幕修复针对明确的镜像导入模式：只有 Gamer 导入与空来源记录的**精确时间、文字、类型、颜色**都相同才成对合并，保留两侧数量的最大值。不会仅按文字做全局去重，同源不同 ID、不同时间或不同显示属性仍保留。

B 站优先采用完整 `idStr`，避免旧 32 位字段截断导致碰撞；相同 CID 在来源重叠时只发送一次。分页依据响应游标，游标不前进时停止。切集代次会在网络和后台处理后再次检查，阻止离页或 A→B→A 切换中的旧回包混入；快进退后的正常重播仍允许。

这些修复不依赖账号、发送者身份或设备私密数据，也不将“内容相同”推断为“同一用户发送”。

## 遥控与面板

`tv_focusable_action.dart` 提供单一焦点、方向移动、确认激活、焦点可视反馈及滚动确保可见。TV 固定导航补齐搜索、每日放送、追番、观看记录和我的与设置。播放器隐藏控制层前归还焦点，隐藏按钮不会继续接收确认键。

`tv_player_shortcuts.dart` 使用 Flutter 标准 `colorF0Red`、`colorF1Green`、`colorF2Yellow`、`colorF3Blue`，分别控制弹幕、线路、选集与全屏。快捷键处理属于播放页面，不注册全局监听。仅非合成 `KeyDownEvent` 执行动作，重复和抬起事件被消耗；普通方向、确认和播放键交给原有处理。

`TvPlayerPanelCoordinator` 统一管理播放页和线路／选集面板的归属，在对应面板内保留局部按键处理：同键关闭，绿／黄键切换到另一面板；红／蓝键先关闭面板再执行动作，避免重复事件叠加多个面板。返回、标题关闭或选中项目都会清理面板归属。其他系统对话框仍阻止底层播放快捷键。面板测试与以下真实页面集成测试分别覆盖局部交互和路由生命周期。

### 播放页参数生命周期

1.0.10 的 `BangumiVodPage.build` 每次重建都读取 `Get.arguments`。线路／选集面板成为顶部路由时，Get 的全局当前参数变成面板的空参数；底层播放页随路由状态重建，继续把该值当作番剧参数读取，导致异常和白屏。该错误发生在页面与路由的集成处，单独测试面板切换并不足以发现。

1.0.11 在页面的 `didChangeDependencies` 中，首次从 `ModalRoute.of(context).settings` 取得**属于该播放页**的参数和路由名称，并保存 id、集数、番剧元数据及剧集列表。后续 `build` 使用已绑定的数据；弹窗打开、互换或关闭不会改写播放页身份，也不会因为顶部路由变动重复执行页面初始化／数据绑定。该修复针对现有合法播放路由，不等于新增了任意缺失或错误参数的深链接容错。

新增 `bangumi_vod_route_arguments_test.dart` 的 2 项回归使用真实 `GetMaterialApp`、命名路由和 `BangumiVodPage`，以本地控制器替身隔离网络与硬件：

- 在线路→选集→线路切换期间，明确断言全局 `Get.arguments` 已为 null，但播放页、视频 widget、番剧和集数保持有效，初始化与数据绑定只执行一次。
- 验证初次蓝键切换全屏，以及打开选集后再按蓝键关闭面板并切换全屏，不替换播放页或产生异常。小窗路径使用真实 `NestedScrollView` 成功布局，检查 Video widget 挂载及小于全屏的高度；回到全屏后检查其尺寸为 1920×1080。

已做旧／新实现对照：将播放页替换回 1.0.10 实现时，两项测试均因 `Get.arguments` 为 null 失败；使用 1.0.11 实现时两项均通过。此前的 88 项自动回归未覆盖这个集成场景，安装成功也不能证明该交互正确。

测试保留真实页面、面板路由、控制层及成功状态下的小窗布局，替换网络、播放监听及原生媒体后端，并关闭无关的弹幕绘制；它们验证页面路由和布局稳定性，不代表真实解码、弹幕或实体遥控器已通过硬件验证。

## 字体、DPR 与诊断

`tv_typography.dart` 从电视安装的系统字体读取字节，通过 `FontLoader` 注册 `AniChWebOSChinese`。它不导出或打包 LG 字体。Noto Sans SC Regular 是备用且可手动选择的字体，随包保留 OFL 1.1、版权和固定来源提交说明。电视子项目不需要上游 Ubuntu 字体。

`tv_render_settings.dart` 将下次启动比例原子写到应用 support directory 内的 `anich-render-scale.txt`；先写临时文件、flush，再 rename，保存失败不更新界面选择。`webos/runner/render_scale.h` 在 Flutter View 创建前读取同一文件：

```text
FLUTTER_APPDATA_HOME / FLUTTER_APP_ID / anich-render-scale.txt
```

两端只接受 `1`、`2` 及各自单个 LF／CRLF 尾换行，共六种形式；不接受 `1.5`、多 token、额外空白或尾随垃圾。原生读取最多 4 字节，缺失、无效或不可读时默认 2。runner 始终设置逻辑尺寸 `1920×1080`，强制 DPR 1 或 2，不把 `3840` 再作为逻辑宽乘 2。

`display_diagnostics.dart` 单独保存真实 Flutter View 的 physical size、DPR、逻辑尺寸、下次比例以及字体加载结果。它与账号存储分开，不记录账号或播放 URL。设置页不会把“下次比例”冒充为当前引擎实际比例。

DPR2 的 `3840×2160` 只表示内部高采样缓冲区。已有设备反馈仍存在文字不如电视系统菜单清晰的问题；没有确认最终 compositor／面板输出为 1:1 4K。当前没有修改 Wayland buffer scale、电视合成器或系统设置，也没有启用 Impeller。

## 接口、登录与状态

发现页新增推荐、每日放送和热搜的 JSON 解析；剧集和播放地址沿用实际可用服务协议。主 API 和哔哩弹幕域根据公开配置更新，代码默认地址仍需随服务变动维护，并非已经实现运行时无限制自动发现。

搜索请求在存在有效会话时携带正常账号 token，匿名或登录过期被拒绝时给出相应提示。登录处理区分网络错误、失败响应和有效会话；空 token 不会标记为已登录。登录测试通过本地模拟响应覆盖网络错误、失败响应及有效／空会话，不包含或提取真实用户凭据；它不代表搜索鉴权已完成实机验证。

追番、图片收藏、账号管理和旧评论入口的存在不代表所有线上服务操作已验证。头像／用户名修改尚未实现。离线下载、同步、一起看、自动片头片尾跳过、外挂字幕、弹弹Play源和新版评论／评分适配仍在范围之外。

## 构建与验证

### 固定工具链

LG 官方支持 Linux 构建。可使用受支持的 Ubuntu x86_64 主机、虚拟机或容器；macOS/Windows 只作为宿主不能替代该交叉工具链。参考 [官方 Getting Started](https://github.com/lg-flutter-webos/flutter-webos/blob/main/doc/getting-started.md)。

在自行选择的工具链目录中获取固定 SDK：

```sh
git clone https://github.com/lg-flutter-webos/flutter-webos.git
git -C flutter-webos checkout 950398131830e9bd5dc91e588c3db8f5c42322be
export WEBOS_FLUTTER_SDK="$(pwd)/flutter-webos"
export PATH="$WEBOS_FLUTTER_SDK/bin:$PATH"
```

使用 LG 官方 NDK 11.2.0 安装器按其说明安装，不把 NDK 二进制提交到应用仓库。将下面的占位路径替换为 NDK 实际安装目录：

```sh
export WEBOS_FLUTTER_NDK_ENV="/path/to/ndk/environment-setup-ca9v1-webosmllib32-linux-gnueabi"
. "$WEBOS_FLUTTER_NDK_ENV"
flutter-webos --version
flutter-webos doctor -v
flutter-webos precache
```

核对输出为 Flutter 3.38.10、Dart 3.10.9、NDK 11.2.0，并使用 SDK 固定的 Flutter 提交。这里使用 webOS CLI 3.2.6 和 Node.js 22.16.0 的已验证组合；该 CLI 包的 `engines.node` 为 `>=20.0.0`。即使旧 LG 指南仍列出 Node.js 14–16，也应按本移植的固定版本表配置。这不是对所有 LG 工具版本或主机环境的通用最低版本声明。

### 依赖、分析、测试、打包

在仓库根目录进入电视子项目：

```sh
cd ports/webos
PUB_HOSTED_URL=https://pub.dev flutter-webos pub get --enforce-lockfile
flutter-webos analyze --no-pub --no-fatal-infos lib test
flutter-webos test --no-pub --dart-define=ANICH_WEBOS=true test
flutter-webos build webos --release --parallel 2 --dart-define=ANICH_WEBOS=true
```

提交并保留本子项目的 `pubspec.lock`。公共副本的 hosted 地址已规范为 `https://pub.dev`，保留全部已锁定版本与 SHA；已在干净副本中使用该源通过 `pub get --enforce-lockfile`。这一结果验证依赖可复现，应用测试与 ARM 构建结果另外记录。首次安装仍需联网获取依赖与 LG 引擎缓存；不要用 `pub upgrade` 代替按照锁文件复现。最低声明为 Dart `>=3.10.3 <4.0.0`、Flutter `>=3.38.4`，实际验证工具链保持 README 中的固定版本。当前锁定 `video_player 2.11.1`、`video_player_platform_interface 6.9.0` 和 `package_info_plus 6.0.0`；依赖声明中的 `^2.9.0` 等不是已解析版本。

`--no-fatal-infos` 保留上游 info 提示，不能隐藏 error／warning。发行构建不设置 `ANICH_TV_SMOKE_ID`；该开发参数会自动进入指定播放页面并输出不含 URL/token 的播放诊断，不能作为默认用户启动流程。

### 原生严格解析测试

此测试用主机 C++17 编译器运行，不需要电视。应在**没有 source ARM 交叉环境的单独主机 shell**中执行，避免误生成 ARM 程序后尝试在构建机运行：

```sh
cd ports/webos
ANICH_NATIVE_TEST_DIR="$(mktemp -d)"
c++ -std=c++17 -Wall -Wextra -Werror \
  test/native/render_scale_test.cc \
  -o "$ANICH_NATIVE_TEST_DIR/render_scale_test"
"$ANICH_NATIVE_TEST_DIR/render_scale_test" "$ANICH_NATIVE_TEST_DIR/fixture"
```

测试自行创建并移除 `fixture` 子目录，覆盖六种合法文本、非法值、大文件、损坏流、缺失环境／文件和 app-id 子目录定位。宿主编译器通过不等于 ARM runner 构建或实机验证通过。

### 安装

使用 README 中的 Developer Mode 与 `ares-setup-device`、`ares-novacom --getkey`、`ares-install`、`ares-launch` 流程。正常开发者升级不需要 root，也不需要写入系统分区。不得将个人设备配置、开发者密钥、账号数据、原始调试日志或家庭场景截图提交到此仓库。

## 测试与实机证据

### 自动测试覆盖

| 测试文件 | 主要风险 |
| --- | --- |
| `webos_video_player_test.dart` | 初始化默认音量、初始化挂起后的换源恢复、播放／跳转／释放、倍速回退及拒绝非默认音量 |
| `webos_video_rect_test.dart` | DPR1／2、偏移和尺寸、全屏、纯 DPR 变化、避免源矩形／Hole 重复缩放 |
| `danmaku_bounds_test.dart` | 实际绘制边界、字体／描边、安全边距、小视口、调整尺寸和暂停 |
| `danmaku_merge_test.dart`、`danmaku_pipeline_test.dart` | 精确镜像配对、同源保留、完整 ID、分页游标、迟到回包、重播 |
| `playback_danmaku_toggle_test.dart` | 暂停／继续、隐藏／显示和用户手动开关状态 |
| `playback_preferences_test.dart` | 偏好持久化、换线预算与环绕、线路记忆、自动全屏、分集观看记录 |
| `tv_focusable_action_test.dart`、`tv_navigation_test.dart` | 焦点遍历、单次激活和电视入口 |
| `tv_player_shortcuts_test.dart`、`tv_player_panels_test.dart` | 彩键与子焦点、重复／合成事件、弹窗与页面隔离、同键关闭、绿／黄互换、红／蓝关闭后执行、返回／选中后的归属清理 |
| `bangumi_vod_route_arguments_test.dart` | 真实 Get 路由与播放页集成；顶部面板参数为空时页面身份保留；蓝键、面板与全屏交替；成功小窗布局与 Video 重挂载；初始化／数据绑定不重复 |
| `collection_pagination_test.dart`、`search_history_test.dart` | 分页边界、本地搜索记录去重和上限 |
| `login_controller_test.dart` | 网络异常、失败登录、有效与空会话 |
| `tv_font_settings_test.dart`、`tv_render_settings_test.dart` | 字体偏好、严格文本协议、保存失败、当前／下次模式分离 |
| `native/render_scale_test.cc` | runner 侧路径和严格解析，与 Dart 协议一致 |

公开的 1.0.11 子项目已在干净副本中使用规范 `pub.dev` 锁文件通过 `pub get --enforce-lockfile`；按本文命令分析为 **0 error、0 warning、86 info**，完整 Flutter 回归 **90/90** 通过，ARM release 编译及 IPK 打包成功。独立公开目录验证与此前电视开发目录结果一致。

### 实机和用户确认

1.0.11 ARM release 已构建、安装并启动，电视上的 `libapp.so`、`appinfo.json`、`xs` 和视频插件四项载荷哈希与打包文件一致。启动指标确认版本 1.0.11、DPR2、逻辑 1920×1080、physical size 3840×2160，LG 系统字体已加载。

既有实机验证还包括真实视频解码及进度增长、DPR2 与 DPR1 切换后的真实 View 指标变化；DPR 变化不是通过伪造 `MediaQuery` 得到的。这些结果与实体遥控器交互验证分别记录。

已有用户反馈确认弹幕边界和功能入口正常、视频在 DPR 修复后全屏正常，以及重复弹幕和暂停／继续误开启弹幕的问题解决。用户仍反馈文字不如系统菜单清晰；不能在发布说明中写为已解决。

1.0.11 已获用户实体遥控器确认：首次蓝键切换全屏、绿键打开后再按绿键关闭、绿／黄面板互换，以及面板内红／蓝键操作均正常。该结果与上面的自动回归及载荷检查共同记录，不把模拟媒体后端测试当成硬件解码测试。

仍需区分以下未验证项目：

- 正常用户登录后的追番、收藏、评论等完整线上流程。
- 其他电视、固件、地区字体和所有编码／网络线路。
- 1080p 与内部 4K 模式下的最终面板合成尺寸和稳定清晰度收益。

后续发布应核对源码版本、`pubspec.yaml`、`appinfo.json`、最新测试结果与文档状态，并从干净的 `ports/webos` 目录完成依赖解析、测试和 ARM release 构建。自动回归不替代物理遥控器、视频 plane 和线上服务验证。

## 许可与第三方边界

- AniCh 基线提交没有仓库级 LICENSE；保留作者和原文件声明，不自行替上游追加统一授权。此说明只记录当前来源状态。
- LG SDK、NDK、引擎缓存由各自官方渠道取得，不随应用源目录复制完整工具链。
- 原生 runner 保留 `webos/LICENSE` 和对应文件版权头。
- 本地 LG 视频插件保留源提交、适用许可和补丁清单；原先有专有标记的两个日志实现已替换为独立 BSD-3-Clause 实现，版权声明限定于这两个新文件，不把替换行为描述为给上游专有实现重新授权。
- Noto Sans SC Regular 为未修改的上游字体，来源提交、校验值和 OFL 1.1 在 `fonts/` 中保留。LG Smart UI SC 仅运行时从设备读取，源码和 IPK 不携带该字体。
- 其他依赖按各自的 LICENSE／NOTICE 处理；此移植没有把依赖代码的版权转移到 AniCh 或重新许可。
