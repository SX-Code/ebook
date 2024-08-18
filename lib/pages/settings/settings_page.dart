import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:e_book_clone/models/app_upgrade_Info.dart';
import 'package:e_book_clone/pages/settings/check_update.dart';
import 'package:e_book_clone/theme/theme_provider.dart';
import 'package:e_book_clone/user/user_provider.dart';
import 'package:e_book_clone/utils/dialog_utils.dart';
import 'package:e_book_clone/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ota_update/ota_update.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double? _progress;
  StateSetter? downloadDialogState;
  final String port = 'downloader_send_port';
  StreamSubscription? _streamSubscription;
  BuildContext? dialogContext;

  @override
  void initState() {
    super.initState();
    // 初始化下载器
    // FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    // 下载回调，更细dialog中的进度条
  }

  // void _bindBackgroundIsolate(DownloadCallback callback) async {
  //   final ReceivePort receivePort = ReceivePort();
  //   bool isSuccess =
  //       IsolateNameServer.registerPortWithName(receivePort.sendPort, port);
  //   if (!isSuccess) {
  //     _unbindBackgroundIsolate();
  //     _bindBackgroundIsolate(callback);
  //   }
  //   receivePort.listen((dynamic data) {
  //     callback(data[0], data[1], data[2]);
  //   });
  //   await FlutterDownloader.registerCallback(downloadCallback);
  // }

  // void _unbindBackgroundIsolate() {
  //   IsolateNameServer.removePortNameMapping(port);
  // }

  @pragma("vm:entry-point")
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    // _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _getAppBar(),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getBodyUI(),
    );
  }

  Widget _getAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 20.r,
        ),
      ),
      title: const Text('设置'),
    );
  }

  Widget _getBodyUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 夜间模式
          Text(
            '样式设置',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          15.verticalSpace,

          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            title: const Text('每日一诗'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            trailing: Switch.adaptive(
              value: Provider.of<ThemeProvider>(context, listen: false)
                  .showDialyPoetry,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleShowDailyPoetry();
              },
            ),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleShowDailyPoetry();
            },
          ),

          15.verticalSpace,
          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            title: const Text('主题跟随系统'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            trailing: Switch.adaptive(
              value: Provider.of<ThemeProvider>(context).isSystemTheme,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleIsSystemTheme(context);
              },
            ),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleIsSystemTheme(context);
            },
          ),

          30.verticalSpace,
          Text(
            '其他设置',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          15.verticalSpace,
          // 关于
          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            title: const Text('Github'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () async {
              final uri = Uri.parse('https://www.baidu.com');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ToastUtils.showErrorMsg('该链接无法打开');
              }
            },
            trailing: const Icon(LineIcons.github),
          ),

          15.verticalSpace,

          // 检查更新
          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            title: const Text('检查更新'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () async {
              _upgradeOperation();
            },
            trailing: const Icon(Icons.update_sharp),
          ),
          
          15.verticalSpace,
          // 关于
          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            title: const Text('关于软件'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {},
            trailing: const Icon(LineIcons.infoCircle),
          ),

          15.verticalSpace,
          Consumer<UserProvider>(
            builder: (context, vm, child) {
              if (Provider.of<UserProvider>(context, listen: false).userInfo ==
                  null) {
                return const SizedBox();
              }
              return InkWell(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '退出登录',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                onTap: () {
                  DialogUtils.showQuestionDialog(context,
                      title: '退出登录',
                      content: '确认退出登录？你将无法获取豆瓣登录用户数据', confirm: () {
                    vm.clearUserInfo();
                  });
                },
              );
            },
          )
        ],
      ),
    );
  }

  void _upgradeOperation() async {
    if (Platform.isIOS) {
      ToastUtils.showInfoMsg('不支持IOS更新');
      return;
    }
    // 权限检查
    final bool isGrand = await _checkPermission();
    if (isGrand) {
      final AppUprageInfo? info = await CheckUpdate.checkUpdate();
      if (info == null) {
        ToastUtils.showInfoMsg('无需更新');
        return;
      }
      // 显示下载弹窗
      _showDonwloadDialog(info, () async {
        _streamSubscription =
            OtaUpdate().execute(info.url ?? "").listen((OtaEvent event) {
          if (downloadDialogState != null) {
            downloadDialogState!(() {
              _progress = int.parse(event.value ?? "") / 100;
            });
          }
          if (event.status == OtaStatus.DOWNLOAD_ERROR ||
              event.status == OtaStatus.INTERNAL_ERROR) {
            ToastUtils.showErrorMsg('下载出错，请检查网络');
          }
        });
        // 点击确认按钮，开始下载
        // await FlutterDownloader.enqueue(
        //     url: info.url ?? "",
        //     savedDir: await _findLocalPath(),
        //     showNotification: true,
        //     openFileFromNotification: true);
        // 注册回调
        // _bindBackgroundIsolate((String id, int status, int progress) {
        //   if (DownloadTaskStatus.fromInt(status) == DownloadTaskStatus.failed) {
        //     ToastUtils.showErrorMsg('下载失败');
        //   }
        //   if (downloadDialogState != null) {
        //     downloadDialogState!(() {
        //       _progress = progress / 100;
        //     });
        //   }
        // });
      }, () async {
        // 取消下载
        // FlutterDownloader.cancelAll();
        _streamSubscription?.cancel();
        _progress = 0;
      });
    } else {
      // 引导进入权限设置页面
      if (!context.mounted) return;
      DialogUtils.showQuestionDialog(
        context,
        title: "权限申请",
        content: "当前应用缺少必要权限，该功能暂时无法使用。如若需要，请单击【确认】按钮千万设置中心进行权限授权。",
        confirm: () {
          openAppSettings();
        },
      );
    }
  }

  // Future<String> _findLocalPath() async {
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
  //     if (int.parse(androidInfo.version.release) >= 10) {
  //       // Android 10以上使用该目录
  //       // return await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  //       return (await getApplicationDocumentsDirectory()).absolute.path;
  //     } else {
  //       return ExternalPath.getExternalStoragePublicDirectory(
  //           ExternalPath.DIRECTORY_DOWNLOADS);
  //     }
  //   } else {
  //     return (await getApplicationSupportDirectory()).path;
  //   }
  // }

  void _showDonwloadDialog(
    AppUprageInfo info,
    VoidCallback confirm,
    VoidCallback cancel,
  ) async {
    _progress = null;
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('软件更新'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              dialogContext = context;
              downloadDialogState = setState;
              return IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.content ?? ""),
                    15.verticalSpace,
                    _progress == null
                        ? const SizedBox(height: 4)
                        : LinearProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            backgroundColor:
                                Theme.of(context).colorScheme.inverseSurface,
                            value: _progress,
                          )
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                cancel.call();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: confirm,
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  /// 权限检查
  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return false;
    } else if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status == PermissionStatus.granted;
    }
    return false;
  }
}
