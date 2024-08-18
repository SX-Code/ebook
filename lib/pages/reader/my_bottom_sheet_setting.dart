import 'package:e_book_clone/pages/reader/reader_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SettingSheetController {
  void Function(bool is2Dark, Color color)? _changeTheme;
  VoidCallback? _startAnimation;

  void changeTheme(bool is2Dark, Color color) {
    _changeTheme?.call(is2Dark, color);
  }

  void startAnimation() {
    _startAnimation?.call();
  }
  
}

class MyBottomSheetSetting extends StatefulWidget {
  final Function(int index, bool isToDark)? bgItemTap;
  final Function(int size, int lineHeight)? fontSizeTap;
  final Function(double brightness)? brightnessSlid;
  final SettingSheetController? controller;

  const MyBottomSheetSetting(
      {super.key,
      this.bgItemTap,
      this.fontSizeTap,
      this.brightnessSlid,
      this.controller});

  @override
  State<MyBottomSheetSetting> createState() => _MyBottomSheetSettingState();
}

class _MyBottomSheetSettingState extends State<MyBottomSheetSetting>
    with SingleTickerProviderStateMixin {
  double _currentBrightness = 0;
  Color? _fromColor;
  Color? _toColor;
  late AnimationController _controller;
  late Animation<Color?> _colors;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    CurvedAnimation(parent: _controller, curve: Curves.bounceIn);
    _colors =
        ColorTween(begin: Colors.white, end: Colors.white).animate(_controller);

    // 切换主题控制器
    widget.controller?._changeTheme = (bool is2Dark, Color color) {
      setState(() {
        _controller.reset();
        if (is2Dark) {
          _colors = ColorTween(
                  begin: color,
                  end: ReaderViewModel.themes[ReaderViewModel.lastIndex])
              .animate(_controller);
          _controller.forward();
        } else {
           _colors = ColorTween(
                  begin: ReaderViewModel.themes[ReaderViewModel.lastIndex],
                  end: color)
              .animate(_controller);
          _controller.forward();
        }
      });
    };
    // 切换主题控制器
    widget.controller?._startAnimation = () {
      setState(() {
        _controller.reset();
        _controller.forward();
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderViewModel>(builder: (context, vm, child) {
      return AnimatedBuilder(
        animation: _colors,
        builder: (context, child) {
          return SingleChildScrollView(
            child: IntrinsicHeight(
              child: Container(
                color: _fromColor == null ? vm.currColor : _colors.value,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
                  child: Column(
                    children: [
                      // 第一行亮度
                      _getBrightnessUI(vm),

                      15.verticalSpace,

                      // 第二行
                      _getBackgroundUI(vm),

                      15.verticalSpace,

                      // 第三行字体大小
                      _getFontSizeUI(vm),
                      // 第二行
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _getBrightnessUI(ReaderViewModel vm) {
    return Row(
      children: [
        Text('亮度', style: TextStyle(fontSize: 12.sp)),
        // 左边颜色主题
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
                trackHeight: 20.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13.h),
                thumbColor: vm.currIndex == ReaderViewModel.themes.length - 1
                    ? Colors.grey
                    : vm.currColor,
                activeTrackColor: Colors.grey.withOpacity(0.3),
                inactiveTrackColor: Colors.grey.withOpacity(0.15),
                overlayColor: Colors.transparent),
            child: Slider(
              value: _currentBrightness,
              onChanged: (double value) {
                setState(() {
                  _currentBrightness = value;
                  widget.brightnessSlid?.call(_currentBrightness);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _getBackgroundUI(ReaderViewModel vm) {
    return // 第二行背景主题
        Row(
      children: [
        Text('背景', style: TextStyle(fontSize: 12.sp)),
        12.horizontalSpace,
        // 左边颜色主题
        Row(
          children: List.generate(ReaderViewModel.themes.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: GestureDetector(
                onTap: () {
                  widget.bgItemTap
                      ?.call(index, index == ReaderViewModel.themes.length - 1);
                  _fromColor = ReaderViewModel.themes[vm.currIndex];
                  // 保存当前主题
                  vm.currIndex = index;
                  _toColor = ReaderViewModel.themes[index];
                  _colors = ColorTween(begin: _fromColor, end: _toColor)
                      .animate(_controller);
                  // 动画先不执行，交给控制器
                },
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                      border: vm.currIndex == index
                          ? Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.onSurface)
                          : Border.all(width: 1, color: Colors.transparent),
                      color: ReaderViewModel.themes[index],
                      shape: BoxShape.circle),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _getFontSizeUI(ReaderViewModel vm) {
    return Row(
      children: [
        Text('字号', style: TextStyle(fontSize: 12.sp)),
        15.horizontalSpace,
        // 左边颜色主题
        Row(
          children: [
            FilledButton.tonal(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.grey.withOpacity(0.15))),
              onPressed: () {
                if (vm.currFontSize < 15) {
                  return;
                }
                setState(() {
                  vm.currFontSize--;
                  vm.currLineHeight--;
                });
                widget.fontSizeTap?.call(vm.currFontSize, vm.currLineHeight);
              },
              child: Icon(
                color: vm.currFontSize == 15
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.onSurface,
                Icons.text_increase_sharp,
                size: 20.r,
              ),
            ),
            15.horizontalSpace,
            Text(vm.currFontSize.toString()),
            15.horizontalSpace,
            FilledButton.tonal(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.grey.withOpacity(0.15))),
              onPressed: () {
                if (vm.currFontSize > 42) {
                  return;
                }
                setState(() {
                  vm.currFontSize++;
                  vm.currLineHeight++;
                });
                widget.fontSizeTap?.call(vm.currFontSize, vm.currLineHeight);
              },
              child: Icon(
                Icons.text_increase_sharp,
                color: vm.currFontSize == 42
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.onSurface,
                size: 20.r,
              ),
            ),
          ],
        )
      ],
    );
  }
}
