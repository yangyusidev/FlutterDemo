import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/common/style/y_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// 通用上下刷新控件
class YPullLoadWidget extends StatefulWidget {
  final Key? refreshKey;

  final RefreshCallback? onLoadMore;
  final RefreshCallback? onRefresh;

  final YPullLoadWidgetControl? control;

  final IndexedWidgetBuilder itemBuilder;

  const YPullLoadWidget(
    this.refreshKey,
    this.onLoadMore,
    this.onRefresh,
    this.control,
    this.itemBuilder, {
    super.key,
  });

  @override
  State<YPullLoadWidget> createState() => _YPullLoadWidget();
}

class _YPullLoadWidget extends State<YPullLoadWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.control?.needLoadMore.addListener(() {
      try {
        Future.delayed(const Duration(seconds: 2), () {
          _scrollController.notifyListeners();
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (widget.control?.needLoadMore.value == true) {
          widget.onLoadMore?.call();
        }
      }
    });

    super.initState();
  }

  _getListCount() {
    if (widget.control!.needHeader == true) {
      return (widget.control!.dataList.isNotEmpty)
          ? widget.control!.dataList.length + 2
          : widget.control!.dataList.length + 1;
    } else {
      if (widget.control!.dataList.isEmpty) {
        return 1;
      }
      return (widget.control!.dataList.isNotEmpty)
          ? widget.control!.dataList.length + 1
          : widget.control!.dataList.length;
    }
  }

  _getItem(int indext) {
    if (!widget.control!.needHeader &&
        indext == widget.control!.dataList.length &&
        widget.control!.dataList.isNotEmpty) {
      return _buildProgressIndicator();
    } else if (widget.control!.needHeader &&
        indext == _getListCount() - 1 &&
        widget.control!.dataList.isNotEmpty) {
      return _buildProgressIndicator();
    } else if (!widget.control!.needHeader &&
        widget.control!.dataList.isEmpty) {
      return _buildEmpty();
    } else {
      return widget.itemBuilder(context, indext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: widget.refreshKey,
        onRefresh: widget.onRefresh ?? () async {},
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _getItem(index);
          },
          itemCount: _getListCount(),
          controller: _scrollController,
        ));
  }

  Widget _buildEmpty() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
              onPressed: () {},
              child: const Image(
                image: AssetImage(GSYICons.DEFAULT_USER_ICON),
                width: 70.0,
                height: 70.0,
              ))
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    Widget bottomWidget = (widget.control!.needLoadMore.value)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitRotatingCircle(color: Theme.of(context).primaryColor),
              Container(
                width: 5.0,
              ),
              const Text(
                "加载中",
                style: TextStyle(
                    color: Color(0xFF121917),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        : Container();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: bottomWidget,
      ),
    );
  }
}

class YPullLoadWidgetControl {
  List dataList = [];

  ValueNotifier<bool> needLoadMore = ValueNotifier(false);

  bool needHeader = false;
}
