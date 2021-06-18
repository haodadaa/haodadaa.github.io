import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:blog/core/extension/num.dart';

enum FoldStatus {
  fold, // 折叠
  expanded, // 展开
}

class FoldWidget extends StatefulWidget {
  final EdgeInsets? displayPadding;
  final Widget? background;
  final Widget? display;
  final FoldStatus initial;

  const FoldWidget({
    Key? key,
    this.background,
    this.display,
    this.displayPadding = const EdgeInsets.only(top: 52, right: 52),
    this.initial = FoldStatus.fold,
  }) : super(key: key);

  @override
  _FoldWidgetState createState() => _FoldWidgetState();
}

class _FoldWidgetState extends State<FoldWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<EdgeInsets> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: 500.milliseconds,
    );
    animation = EdgeInsetsTween(
      begin: EdgeInsets.zero,
      end: widget.displayPadding,
    ).animate(CurvedAnimation(
      parent: animController,
      curve: Curves.easeInOutQuart,
    ));
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void toggleAnim() {
    if (animController.status == AnimationStatus.completed) {
      animController.reverse();
    } else if (animController.status == AnimationStatus.dismissed) {
      animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.background != null) widget.background!,
        if (widget.display != null)
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                padding: animation.value,
                child: Stack(
                  children: [
                    widget.display!,
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          toggleAnim();
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                            ),
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
