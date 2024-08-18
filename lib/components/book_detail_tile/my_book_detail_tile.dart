import 'package:e_book_clone/components/book_detail_tile/my_book_detail_tile_skeletion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookDetailTile extends StatelessWidget {
  final List<String>? data;
  final List<String> labels;
  const MyBookDetailTile({super.key, this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(labels.length, (index) {
        if (data == null) {
          return MyBookDetailTileSkeleton(label: labels[index]);
        }
        return SizedBox(
          width: 100.w,
          child: Column(
            children: [
              Text(
                data![index],
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
              ),
              3.verticalSpace,
              Text(
                labels[index],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
