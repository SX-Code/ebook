import 'package:e_book_clone/components/book_tile/book_tile_horizon/my_book_tile_item_fixed.dart';
import 'package:e_book_clone/components/my_search_tile.dart';
import 'package:e_book_clone/json/store_json.dart';
import 'package:e_book_clone/pages/favourite/favourite_vm.dart';
import 'package:e_book_clone/utils/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late TextEditingController searchController;
  final FavouriteViewModel _viewModel = FavouriteViewModel();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _viewModel.getRecommend();
  }

  @override
  Widget build(BuildContext context) {
    final surf = Theme.of(context).colorScheme.surface;
    return ChangeNotifierProvider<FavouriteViewModel>(
      create: (context) => _viewModel,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: surf,
          surfaceTintColor: surf,
        ),
        backgroundColor: surf,
        body: _getBodyUI(),
      ),
    );
  }

  Widget _getBodyUI() {
    return SafeArea(
        child: SingleChildScrollView(
      padding: EdgeInsets.all(MyDesign.paddingPage),
      child: Column(
        children: [
          MyDesign.spaceTAppBar,
          _getSearchAndCartUI(),
          MyDesign.spaceVTile,
          _getFavoriteListUI(),
        ],
      ),
    ));
  }

  Widget _getSearchAndCartUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MySearchTile(
          hintText: '搜索..',
          textEditingController: searchController,
        ),
        Flexible(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Badge(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Text(
                '3',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: Icon(LineIcons.shoppingBag, size: 25.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getFavoriteListUI() {
    var width = MediaQuery.of(context).size.width;
    return Wrap(
      spacing: MyDesign.widthFavouriteItem,
      runSpacing: MyDesign.heightFavouriteItem,
      children: List.generate(recommendationsList.length, (index) {
        if (_viewModel.recommend == null) return const SizedBox();
        return MyBookTileItemFixed(
          book: _viewModel.recommend![index],
          width: (width - 60.w) / 2,
          height: (width + 60.h) / 2,
          showFav: false,
        );
      }),
    );
  }
}
