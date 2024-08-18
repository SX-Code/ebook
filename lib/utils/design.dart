import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 设计尺寸
class MyDesign {

  /* 
  
    F O N T S I Z E
  
  */
  static final double fontSizeAppBarTitle = 18.sp;
  static final double fontSizeTileTitle = 18.sp;
  static final double fontSizeBookTitle = 14.sp;
  static final double fontSizeBookTitleM = 15.sp;
  static final double fontSizeBookSubtitle = 12.sp;

  /* 
  
    S P A C E,  S I Z E
  
  */

  static final paddingPage = 15.r;
  static final widthPageMargin = 15.w;
  static final heightPageMargin = 15.h;
  static final heightTileMargin = 30.h;
  static final heightFavouriteItem = 20.h;
  static final widthFavouriteItem = 20.w;

  /* 
  
    S P A C E,  W I D G E T
  
  */

  static final spaceVTile = 30.verticalSpace;
  static final spaceVTileTitle = 15.verticalSpace;
  static final spaceVImageText= 10.verticalSpace;
  static final spaceTAppBar = spaceVImageText;
  static final spaceVTextText = 5.verticalSpace;
  static final spaceHitem = spaceVImageText;

  static final spaceHImageText = 12.horizontalSpace;

  static final styleTileTile = TextStyle(fontSize: fontSizeTileTitle, fontWeight: FontWeight.w600);
  static final styleBookTitle = TextStyle(fontSize: fontSizeBookTitle, fontWeight: FontWeight.w600);
  static final styleBookTitleM = TextStyle(fontSize: fontSizeBookTitleM, fontWeight: FontWeight.bold);
}