import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAuthorTileSkeleton extends StatelessWidget {
  const MyAuthorTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 作者信息
          Row(
            children: [
              Container(
                height: 40.r,
                width: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                  3.verticalSpace,
                  Container(
                    width: 40,
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              )
            ],
          ),

          // 了解作者
          Row(
            children: [
              Text(
                '了解作者',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              3.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios,
                size: 14.r,
              )
            ],
          )
        ],
      ),
    );
  }
}
