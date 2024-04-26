import 'package:flutter/material.dart';

class YTabBarWidget extends StatefulWidget {

  final List<Widget>? tabItems;
  final List<Widget>? tabViews;
  final Widget? drawer;
  final Widget? title;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onDoublePress;
  final ValueChanged<int>? onSinglePress;

  const YTabBarWidget(
      {super.key,
      this.drawer,
      this.tabItems,
      this.floatingActionButton,
      this.backgroundColor,
      this.title,
      this.tabViews,
      this.onPageChanged,
      this.onDoublePress,
      this.onSinglePress,
      this.indicatorColor});

  @override
  State<YTabBarWidget> createState() => _YTabBarWidget();
}

class _YTabBarWidget extends State<YTabBarWidget>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final PageController _pageController = PageController();

  int _index = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        title: widget.title,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _navigationPageChanged,
        children: widget.tabViews!,
      ),
      bottomNavigationBar: Material(
        color: widget.backgroundColor,
        child: TabBar(
            controller: _tabController,
            tabs: widget.tabItems!,
            indicatorColor: widget.indicatorColor),
      ),
    );
  }
}
