import 'package:flutter/material.dart';
import 'package:flutter_application/widget/y_tabs.dart' as y_tab;
import 'package:flutter_application/common/style/y_style.dart';

// 支持顶部和顶部的TabBar控件
// 配合AutomaticKeepAliveClientMixin可以keep住

class YTabBarWidget extends StatefulWidget {
  final TabType type;

  final bool resizeToAvoidBottomPadding;

  final Color? indicatorColor;
  final Color? backgroundColor;

  final Widget? title;
  final Widget? drawer;
  final Widget? bottomBar;
  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final List<Widget>? tabItems;
  final List<Widget>? tabViews;
  final List<Widget>? footerButtons;

  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onDoublePress;
  final ValueChanged<int>? onSinglePress;

  const YTabBarWidget(
      {super.key,
      this.type = TabType.bottom,
      this.resizeToAvoidBottomPadding = true,
      this.indicatorColor,
      this.backgroundColor,
      this.title,
      this.drawer,
      this.bottomBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.tabItems,
      this.tabViews,
      this.footerButtons,
      this.onPageChanged,
      this.onDoublePress,
      this.onSinglePress});

  @override
  State<YTabBarWidget> createState() => _YTabBarWidget();
}

class _YTabBarWidget extends State<YTabBarWidget>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  TabController? _tabController;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _tabController =
        TabController(length: widget.tabItems!.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _navigationPageChanged(index) {
    if (_index == index) {
      return;
    }
    _index = index;
    _tabController!.animateTo(index);
    widget.onPageChanged?.call(index);
  }

  _navigationTapClick(index) {
    if (_index == index) {
      return;
    }
    _index = index;
    widget.onPageChanged?.call(index);

    _pageController.jumpTo(MediaQuery.sizeOf(context).width * index);
    widget.onSinglePress?.call(index);
  }

  _navigationDoubleTapClick(index) {
    _navigationTapClick(index);
    widget.onDoublePress?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == TabType.top) {
      // 顶部tab bar
      return Scaffold(
        backgroundColor: GSYColors.mainBackgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomPadding,
        floatingActionButton: SafeArea(
          child: widget.floatingActionButton ?? Container(),
        ),
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        persistentFooterButtons: widget.footerButtons,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: widget.title,
          bottom: TabBar(
              controller: _tabController,
              tabs: widget.tabItems!,
              indicatorColor: widget.indicatorColor,
              onTap: _navigationTapClick),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _navigationPageChanged,
          children: widget.tabViews!,
        ),
        bottomNavigationBar: widget.bottomBar,
      );
    }

    // 底部tab bar
    return Scaffold(
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: widget.title,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _navigationPageChanged,
        children: widget.tabViews!,
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: y_tab.TabBar(
              controller: _tabController,
              tabs: widget.tabItems!,
              indicatorColor: widget.indicatorColor,
              onDoubleTap: _navigationDoubleTapClick,
              onTap: _navigationTapClick),
        ),
      ),
    );
  }
}

enum TabType { top, bottom }
