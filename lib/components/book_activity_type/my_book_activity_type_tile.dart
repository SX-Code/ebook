import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookActivityTypeTile extends StatefulWidget {
  final String title;
  final List<String> labels;
  final Function(int index)? itemTap;

  const MyBookActivityTypeTile(
      {super.key, required this.labels, this.title = '活动类型', this.itemTap});

  @override
  State<MyBookActivityTypeTile> createState() => _MyBookActivityTypeTileState();
}

class _MyBookActivityTypeTileState extends State<MyBookActivityTypeTile> {
  
  int? _value = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          5.verticalSpace,
          Wrap(
            children: List.generate(widget.labels.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: ChoiceChip(
                  selected: _value == index,
                  onSelected: (selected) {
                    if (_value == index) return;
                    widget.itemTap?.call(index);
                    setState(() {
                      _value = index;
                    });
                  },
                  label: Text(widget.labels[index]),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
