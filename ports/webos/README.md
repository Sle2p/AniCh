# AniCh TV · webOS 移植

基于 [AniCh 公开源码](https://github.com/Sle2p/AniCh/tree/c5729a28af239aec78c7059ad122ff00f3f7c47a) 的 LG webOS TV 原生 Flutter 移植。应用 ID 为 `com.anich.tv`，使用电视硬件播放器和遥控器操作。

本目录是独立的 `ports/webos` 子项目，包含自己的 `pubspec.yaml`、依赖锁文件、应用代码、资源、原生 runner 和测试。仓库根目录的 Android、iOS、macOS、Windows、Linux 应用保持上游实现；请在本目录构建电视版。这里的播放器适配不承诺可用于其他平台。

上游 README 标明公开源码对应 1.0.0。本移植补充了电视适配及部分接口兼容，不代表复现上游后续发行版的全部功能，也不是 LG 官方发行的应用。

当前版本为 **TV 1.0.12（20261105）**，修复左右移动焦点时页面意外纵向跳动的问题；验证结果与范围见下方[验证状态](#验证状态)。

## 支持范围

- LG 官方 Flutter SDK 的目标设备为 **webOS TV 26 Re:New 及之后版本**；官方视频插件要求 webOS 26 media 或更新平台。不能据此推断所有旧电视、模拟器或其他 webOS 设备均可运行。[LG SDK 要求](https://github.com/lg-flutter-webos/flutter-webos/blob/main/doc/getting-started.md#target-device)、[视频插件要求](https://github.com/lg-flutter-webos/plugins/blob/3a742bb86b04e261044f0864f9b1f71acf0bbad3/packages/video_player/README.md)
- 已在 LG C4、设备 SDK 11.2.0 上验证安装和播放；这是单台设备的验证结果，不是完整机型兼容表。各版本具体交互验证见下方说明。
- 当前构建目标为 **32 位 ARM native 应用**。电视内核为 64 位不意味着应该改用 arm64 包。
- 构建需要 Linux 环境、LG Flutter webOS SDK 和 NDK；安装通过电视的 Developer Mode 进行，不要求修改电视固件。

## 已实现的功能

| 范围 | 电视版实现 | 验证边界 |
| --- | --- | --- |
| 浏览与发现 | 番剧列表、详情、推荐、每日放送、热搜、搜索和本地搜索记录 | 推荐、排期、热搜使用真实接口；数据随服务变化 |
| 播放 | 原生硬件视频、播放／暂停、进度跳转、选集、选线、全屏、倍速、画面比例 | 已有实机播放和全屏确认；具体编码、倍速和线路仍受设备与源站限制 |
| 播放偏好 | 默认倍速、左右快进秒数、自动连播、自动换线、自动全屏、成功线路记忆 | 持久化与状态转换有自动回归；失败时最多自动尝试另外 4 条线路 |
| 观看记录 | 按番剧、分集保存进度，续播，避免换源零进度覆盖记录 | 自动回归覆盖分集合并、换集及续播门控 |
| 弹幕 | 本站及已有外部源开关、屏蔽设置、字体／描边／显示范围设置、暂停联动 | 已有实机显示与暂停确认；未新增弹弹Play接入 |
| 弹幕修复 | 视频可见区域内布局与裁剪、精确镜像记录合并、分页及迟到响应隔离 | 边界和数据管线有自动回归；重复弹幕与暂停后误开启问题已有用户实机确认 |
| 遥控操作 | 方向焦点、确认、返回、可滚动选集／线路面板、播放页四色快捷键 | 基础导航已用于实机；彩键修复状态见下文 |
| 我的与设置 | 观看记录、追番、图库、图片收藏、登录／账号、外观、弹幕和播放设置入口 | 真实账号登录、追番、收藏等服务操作仍需正常登录后验证；入口存在不等于服务端协议全部验证完成 |
| 字体与绘制 | 电视系统中文／Noto 中文字体切换；1080p 直绘／内部 4K 高采样切换 | 系统字体加载及两种实际 DPR 已在电视上确认；未证明最终面板 1:1 输出 4K UI |

搜索等接口可能要求登录。应用沿用正常账号鉴权，不提供绕过服务权限的方式。

## 遥控器操作

| 按键 | 行为 |
| --- | --- |
| 方向键 | 在页面、卡片和按钮间移动焦点 |
| 确认键 | 激活当前项目；视频区域获得焦点时播放／暂停 |
| 视频区域左／右 | 快退／快进，默认各 10 秒，可在播放设置修改 |
| 视频区域上／下 | 显示或进入播放控制区 |
| 返回键 | 先关闭当前面板或退出全屏，再返回上一页 |
| 红键 | 开关当前播放器的弹幕 |
| 绿键 | 打开播放线路列表 |
| 黄键 | 打开选集列表 |
| 蓝键 | 切换全屏 |

彩键只在播放页及其指定播放面板内生效，不作为全局应用快捷键。长按重复、抬起和合成事件不重复执行动作。播放控制栏显示四色功能提示。

再按同一个绿／黄键关闭当前对应面板；在线路面板按黄键直接切到选集，反向亦然。面板中按红／蓝键先关闭面板，再执行弹幕／全屏动作。播放页将番剧、集数和元数据绑定到自己的路由，面板切换不会改变正在播放的页面身份。

**1.0.12 焦点修复：** 保留 Flutter 默认方向遍历，焦点控件已可见时保持现有滚动位置；被裁切的控件仅按需进入视口，不再每次强制居中。屏幕外的初始焦点仍会显示出来。六处纵向滚动监听增加轴检查，横向子列表的通知不再更新纵向状态或触发纵向分页。完整回归与构建状态见下文。

常用设置入口：

- “我的与设置 → 播放设置”：倍速、比例、快进秒数和自动播放行为。
- “我的与设置 → 外观设置 → 电视字体”：系统中文／Noto 字体与预览。
- 外观设置中的绘制模式在**完全关闭并重新打开应用后**生效；当前模式以真实 Flutter View 数据显示。

## 字体与分辨率说明

默认尝试从电视本机读取 LG Smart UI SC 字体，再通过 `FontLoader` 注册。LG 字体没有放入仓库或安装包；本机加载失败时有随包的 Noto Sans SC Regular 备用字体。Noto 字体及其来源、OFL 1.1 许可见 [fonts/NotoSansSC-NOTICE.txt](fonts/NotoSansSC-NOTICE.txt) 和 [fonts/NotoSansSC-OFL.txt](fonts/NotoSansSC-OFL.txt)。

两种模式都使用 `1920×1080` 逻辑布局：

| 模式 | Flutter DPR | 请求的内部绘制尺寸 |
| --- | --- | --- |
| 1080p 直绘 | 1 | 1920×1080 |
| 内部 4K 高采样（默认） | 2 | 3840×2160 |

这些数值描述 Flutter 渲染缓冲区，**不证明电视合成器或面板最终按 1:1 呈现 4K 界面**，也不描述片源分辨率。实际观察中，字体与高采样模式仍未达到电视系统菜单的清晰程度，两种模式没有获得稳定、明显的清晰度优势。当前保留 Skia；没有把未经设备验证的 Impeller 切换作为修复。

## 构建

已使用的版本如下。最低依赖声明不是其他版本已经验证的承诺。

| 组件 | 固定版本／提交 |
| --- | --- |
| AniCh 公开源码基线 | `c5729a28af239aec78c7059ad122ff00f3f7c47a` |
| LG Flutter webOS SDK | `950398131830e9bd5dc91e588c3db8f5c42322be` |
| Flutter / Dart | `3.38.10` / `3.10.9` |
| Flutter 源码提交 | `c6f67dede3d4aa1aa7a69dd56a3494a5cde6cc80` |
| LG NDK | `11.2.0`，`ca9v1-webosmllib32-linux-gnueabi` |
| LG 插件基线 | `3a742bb86b04e261044f0864f9b1f71acf0bbad3` |
| 关键锁定依赖 | `video_player 2.11.1`、`video_player_platform_interface 6.9.0`、`package_info_plus 6.0.0` |
| webOS CLI / Node.js | 已验证 `3.2.6` / `22.16.0` |

先按 [LG 官方指南](https://github.com/lg-flutter-webos/flutter-webos/blob/main/doc/getting-started.md) 配置 Linux 主机、NDK、CLI 和 `WEBOS_FLUTTER_NDK_ENV`，再固定 SDK 提交。Node.js 以本表的 22.16.0 为准：CLI 3.2.6 的包声明要求 Node.js `>=20.0.0`，官方指南中可能仍出现的 14–16 建议不适用于此组合。完整步骤及主机测试说明见 [实施文档](docs/IMPLEMENTATION.md#构建与验证)。

在仓库根目录执行：

```sh
cd ports/webos
PUB_HOSTED_URL=https://pub.dev flutter-webos pub get --enforce-lockfile
flutter-webos analyze --no-pub --no-fatal-infos lib test
flutter-webos test --no-pub --dart-define=ANICH_WEBOS=true test
flutter-webos build webos --release --parallel 2 --dart-define=ANICH_WEBOS=true
```

`ANICH_WEBOS=true` 是本移植的必要构建参数。公共子项目的依赖锁文件使用规范 `pub.dev` 地址，已在干净副本中通过 `--enforce-lockfile` 解析验证，版本与包校验值保持锁定。依赖解析与应用测试、ARM 构建分别验证，结果见下文。发行包不启用用于开发冒烟导航的 `ANICH_TV_SMOKE_ID`。

输出位于 `build/webos/arm/release/ipk/`，文件名形如 `com.anich.tv_<version>_arm.ipk`。应用版本以本目录的 `pubspec.yaml` 和 `webos/meta/appinfo.json` 为准。

## 安装到电视

1. 在受支持的电视上安装并开启 LG Developer Mode，按应用提示完成登录、重启及 Key Server 设置；保持开发者会话有效。参见 [LG 设备设置指南](https://github.com/lg-flutter-webos/flutter-webos/blob/main/doc/getting-started.md#device-setup)。
2. 在电脑安装 webOS CLI。以下示例中的电视地址和包路径均需替换为自己的值。
3. 注册设备并通过交互提示取得开发者连接密钥；不要把密钥或口令写入仓库。

```sh
npm install --global @webos-tools/cli@3.2.6
ares-setup-device --add anich-tv \
  --info "host=<电视地址>" --info "port=9922" --info "username=prisoner"
ares-novacom --device anich-tv --getkey
ares-install --device anich-tv "/path/to/com.anich.tv_<version>_arm.ipk"
```

上述安装命令与启动分开；只做后台升级时执行到 `ares-install` 为止。需要立即打开应用时，再单独运行：

```sh
ares-launch --device anich-tv com.anich.tv
```

更新时直接安装新版 IPK，不需要先卸载。卸载可能删除本地观看记录和设置。用户主动切换绘制模式后，可以用下面的命令彻底关闭再启动：

```sh
ares-launch --device anich-tv --close com.anich.tv
ares-launch --device anich-tv com.anich.tv
```

## 已知限制

- 尚未实现离线下载、跨设备记录／屏蔽词同步、一起看、自动跳过片头片尾、外挂字幕和弹弹Play弹幕源。
- 旧评论页面不代表新版评论、评分协议已完成兼容；头像／用户名修改未实现，正常账号登录和相关服务操作的实机验证仍不完整。
- 当前 LG 硬件播放器不提供桌面 mpv 的应用内超分、音量增强、视频截图、画中画、桌面窗口及完整缓存／渲染参数。音量、亮度使用电视设置。
- 线路如果要求自定义 HTTP 请求头、使用不支持的编码或已经失效，可能无法播放。倍速支持取决于硬件和具体流；明确不支持时回退正常速度。
- 图形绘制清晰度仍有已知差距；内部 4K 缓冲区不是最终 4K UI 输出保证。
- 仅有上述单台 LG C4 的实机证据；其他机型、其他地区的系统字体及不同固件需要验证。

## 验证状态

- **1.0.12 自动验证：** 完整 Flutter 回归 97/97 通过，分析 0 error、0 warning、86 info。新增 5 项焦点和 2 项滚动通知回归，覆盖问题复现及既有行为保留；旧实现会使可见行纵向偏移，新实现保持原位。横向误分页回归场景由 2 次请求降为 0，正常纵向到底分页保留。
- **1.0.12 源码与构建：** 公开目录已同步相同实现，对比仅有空白规范化差异；ARM release 编译与 IPK 打包成功。没有将上一版公开目录的独立构建结果计为本版结果。
- **1.0.12 设备验证：** 设备连接暂不可用，后台安装和版本／载荷核验尚未完成，本版左右焦点交互未获实机确认。本轮未发送应用启动、设备唤醒或切换电视画面的命令。
- **1.0.11 自动验证基线：** 公开子项目完整 Flutter 回归 90/90 通过，分析 0 error、0 warning，保留 86 条 info 提示；干净副本通过 `pub.dev` 的 `pub get --enforce-lockfile` 和 ARM release IPK 构建。
- **1.0.11 构建与安装：** ARM release 已安装并启动，四项应用载荷与安装包一致；电视读取到 DPR2、逻辑 1920×1080、内部绘制 3840×2160，LG 系统字体加载成功。这些运行指标属于 1.0.11。
- **已有用户实机确认：** 弹幕边界与功能入口恢复、DPR 修复后视频全屏、精确重复弹幕修复、暂停／继续不再重置手动弹幕开关。
- **1.0.11 用户实机确认：** 首次蓝键切换全屏、再次按绿键关闭线路面板、绿／黄面板直接切换，以及面板内红／蓝键操作均正常。
- **其他尚未证明的范围：** 真实账号全流程、全部资源线路与编码、其他电视机型、最终面板 1:1 4K UI。

自动测试不能替代硬件解码、遥控器或在线服务的实机验证。详细覆盖及发布前检查见 [实施文档](docs/IMPLEMENTATION.md#测试与实机证据)。

## 来源与许可

AniCh 原项目的作者归属和原有声明保持不变。所依据的上游提交未提供仓库级 `LICENSE` 文件；本移植不擅自把上游全部代码重新标为 MIT、BSD 或其他许可证。

- LG 原生 runner 的版权和许可保留在 [webos/LICENSE](webos/LICENSE)。SDK 和 NDK 仍按 LG 各自的分发及使用条件取得。
- 本地视频插件来自 LG 官方固定提交，并包含兼容性补丁。原先带有专有标记的两个日志实现已完整替换为独立编写、按 BSD-3-Clause 分发的标准错误输出实现。请一起阅读 [插件许可](third_party/video_player_webos/LICENSE)、[补丁说明](third_party/video_player_webos/ANICH_PATCHES.md) 和各源文件版权头。
- Noto Sans SC 保留 OFL 1.1、原版权和来源说明；LG 系统字体仅在电视本机使用，不随包分发。
- 其他 Flutter、Dart 与原应用依赖各自保留原许可证；依赖版本记录在本子项目的 `pubspec.lock`。

实现、数据流与第三方修改边界见 [docs/IMPLEMENTATION.md](docs/IMPLEMENTATION.md)。
