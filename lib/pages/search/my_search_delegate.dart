import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<T?> showMySearch<T>({
  required BuildContext context,
  required MySearchDelegate<T> delegate,
  String? query = '',
  bool useRootNavigator = false,
}) {
  delegate.query = query ?? delegate.query;
  delegate._currentBody = _SearchBody.suggestions;
  return Navigator.of(context, rootNavigator: useRootNavigator)
      .push(_SearchPageRoute<T>(
    delegate: delegate,
  ));
}

/// https://juejin.cn/post/7090374603951833118
abstract class MySearchDelegate<T> {
  MySearchDelegate({
    this.searchFieldLabel,
    this.searchFieldStyle,
    this.searchFieldDecorationTheme,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
  }) : assert(searchFieldStyle == null || searchFieldDecorationTheme == null);

  Widget buildSuggestions(BuildContext context);

  Widget buildResults(BuildContext context);

  Widget? buildLeading(BuildContext context);

  bool? automaticallyImplyLeading;

  double? leadingWidth;

  List<Widget>? buildActions(BuildContext context);

  PreferredSizeWidget? buildBottom(BuildContext context) => null;

  Widget? buildFlexibleSpace(BuildContext context) => null;

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: colorScheme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  String get query => _queryTextController.completeText;

  set query(String value) {
    _queryTextController.completeText = value; // 更新实际搜索内容
    _queryTextController.text = value; // 更新输入框内容
    if (_queryTextController.text.isNotEmpty) {
      _queryTextController.selection = TextSelection.fromPosition(
          TextPosition(offset: _queryTextController.text.length));
    }
  }

  void showResults(BuildContext context) {
    _focusNode?.unfocus();
    _currentBody = _SearchBody.results;
  }

  void showSuggestions(BuildContext context) {
    assert(_focusNode != null,
        '_focusNode must be set by route before showSuggestions is called.');
    _focusNode!.requestFocus();
    _currentBody = _SearchBody.suggestions;
  }

  void close(BuildContext context, T result) {
    _currentBody = null;
    _focusNode?.unfocus();
    Navigator.of(context)
      ..popUntil((Route<dynamic> route) => route == _route)
      ..pop(result);
  }

  final String? searchFieldLabel;

  final TextStyle? searchFieldStyle;

  final InputDecorationTheme? searchFieldDecorationTheme;

  final TextInputType? keyboardType;

  final TextInputAction textInputAction;

  Animation<double> get transitionAnimation => _proxyAnimation;

  FocusNode? _focusNode;

  final ChinaTextEditController _queryTextController = ChinaTextEditController();

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);

  final ValueNotifier<_SearchBody?> _currentBodyNotifier =
      ValueNotifier<_SearchBody?>(null);

  _SearchBody? get _currentBody => _currentBodyNotifier.value;
  set _currentBody(_SearchBody? value) {
    _currentBodyNotifier.value = value;
  }

  _SearchPageRoute<T>? _route;

  /// Releases the resources.
  @mustCallSuper
  void dispose() {
    _currentBodyNotifier.dispose();
    _focusNode?.dispose();
    _queryTextController.dispose();
    _proxyAnimation.parent = null;
  }
}

/// search page.
enum _SearchBody {
  suggestions,

  results,
}

class _SearchPageRoute<T> extends PageRoute<T> {
  _SearchPageRoute({
    required this.delegate,
  }) {
    assert(
      delegate._route == null,
      'The ${delegate.runtimeType} instance is currently used by another active '
      'search. Please close that search by calling close() on the MySearchDelegate '
      'before opening another search with the same delegate instance.',
    );
    delegate._route = this;
  }

  final MySearchDelegate<T> delegate;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    delegate._proxyAnimation.parent = animation;
    return animation;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _SearchPage<T>(
      delegate: delegate,
      animation: animation,
    );
  }

  @override
  void didComplete(T? result) {
    super.didComplete(result);
    assert(delegate._route == this);
    delegate._route = null;
    delegate._currentBody = null;
  }
}

class _SearchPage<T> extends StatefulWidget {
  const _SearchPage({
    required this.delegate,
    required this.animation,
  });

  final MySearchDelegate<T> delegate;
  final Animation<double> animation;

  @override
  State<StatefulWidget> createState() => _SearchPageState<T>();
}

class _SearchPageState<T> extends State<_SearchPage<T>> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.delegate._queryTextController.addListener(_onQueryChanged);
    widget.animation.addStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    widget.delegate._focusNode = focusNode;
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate._queryTextController.removeListener(_onQueryChanged);
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.removeListener(_onSearchBodyChanged);
    widget.delegate._focusNode = null;
    focusNode.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    if (widget.delegate._currentBody == _SearchBody.suggestions) {
      focusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(_SearchPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      oldWidget.delegate._queryTextController.removeListener(_onQueryChanged);
      widget.delegate._queryTextController.addListener(_onQueryChanged);
      oldWidget.delegate._currentBodyNotifier
          .removeListener(_onSearchBodyChanged);
      widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
      oldWidget.delegate._focusNode = null;
      widget.delegate._focusNode = focusNode;
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus &&
        widget.delegate._currentBody != _SearchBody.suggestions) {
      widget.delegate.showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = widget.delegate.appBarTheme(context);
    final String searchFieldLabel = widget.delegate.searchFieldLabel ??
        MaterialLocalizations.of(context).searchFieldLabel;
    Widget? body;
    switch (widget.delegate._currentBody) {
      case _SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.suggestions),
          child: widget.delegate.buildSuggestions(context),
        );
      case _SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: widget.delegate.buildResults(context),
        );
      case null:
        break;
    }

    late final String routeName;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        routeName = '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        routeName = searchFieldLabel;
    }

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: widget.delegate.leadingWidth,
            automaticallyImplyLeading:
                widget.delegate.automaticallyImplyLeading ?? true,
            leading: widget.delegate.buildLeading(context),
            title: TextField(
              controller: widget.delegate._queryTextController,
              focusNode: focusNode,
              style: widget.delegate.searchFieldStyle ??
                  theme.textTheme.titleLarge,
              textInputAction: widget.delegate.textInputAction,
              keyboardType: widget.delegate.keyboardType,
              onSubmitted: (String _) => widget.delegate.showResults(context),
              decoration: InputDecoration(hintText: searchFieldLabel),
            ),
            flexibleSpace: widget.delegate.buildFlexibleSpace(context),
            actions: widget.delegate.buildActions(context),
            bottom: widget.delegate.buildBottom(context),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: body,
          ),
        ),
      ),
    );
  }
}

class ChinaTextEditController extends TextEditingController {
  ///拼音输入完成后的文字
  var completeText = '';

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    ///拼音输入完成
    if (!value.composing.isValid || !withComposing) {
      if (completeText != value.text) {
        completeText = value.text;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
      return TextSpan(style: style, text: text);
    }

    ///返回输入样式，可自定义样式
    final TextStyle composingStyle = style?.merge(
      const TextStyle(decoration: TextDecoration.underline),
    ) ?? const TextStyle(decoration: TextDecoration.underline);
    return TextSpan(style: style, children: <TextSpan>[
      TextSpan(text: value.composing.textBefore(value.text)),
      TextSpan(
        style: composingStyle,
        text: value.composing.isValid && !value.composing.isCollapsed
            ? value.composing.textInside(value.text)
            : "",
      ),
      TextSpan(text: value.composing.textAfter(value.text)),
    ]);
  }
}
