import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyChoiceTile extends StatefulWidget {
  final Map<String, dynamic> types;
  final Function(dynamic value)? choiced;
  final int? defaultIndex;

  const MyChoiceTile(
      {super.key, required this.types, this.choiced, this.defaultIndex});

  @override
  State<MyChoiceTile> createState() => _MyChoiceTileState();
}

class _MyChoiceTileState extends State<MyChoiceTile> {
  late List names;
  late List values;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.defaultIndex ?? _index;
    names = widget.types.keys.toList();
    values = widget.types.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.types.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: ChoiceChip(
                label: Text(
                  names[index],
                  style: TextStyle(fontSize: 12.sp),
                ),
                selected: _index == index,
                onSelected: (select) {
                  if (_index == index) {
                    // 重复点击，不予相应
                    return;
                  }
                  setState(() {
                    _index = index;
                    widget.choiced?.call(values[index]);
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
