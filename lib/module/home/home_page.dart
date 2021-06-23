import 'package:blog/module/global/base/base_page.dart';
import 'package:blog/module/global/global_bloc.dart';
import 'package:blog/module/global/theme/theme_style.dart';
import 'package:blog/widget/adaptive_builder.dart';
import 'package:blog/widget/button.dart';
import 'package:blog/widget/fold_widget.dart';
import 'package:blog/widget/mouse_region_effect.dart';
import 'package:flutter/material.dart';

class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themeStyle.backgroundColor,
      body: FoldWidget(
        // displayPadding: const EdgeInsets.only(top: 52, right: 52),
        // initial: FoldStatus.fold,
        background: const HomeBackgroundWidget(),
        display: HomeDisplayWidget(themeStyle: context.themeStyle),
      ),
    );
  }
}

class HomeBackgroundWidget extends StatelessWidget {
  const HomeBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          const Spacer(),
          DayNightSwitcher(
            assets: [
              context.localImage.themeDay,
              context.localImage.themeNight,
            ],
            onTap: (index) {
              context.globalBloc.add(ChangeAppTheme(AppTheme.values[index]));
              // // 切换主题风格
              // context.globalBloc.add(SwitchAppTheme());
            },
          ),
          const SizedBox(width: 14),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class HomeDisplayWidget extends StatelessWidget {
  final ThemeStyle themeStyle;

  const HomeDisplayWidget({Key? key, required this.themeStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeStyle.primaryColor,
        borderRadius: 4.topRightCircular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox.shrink(),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              children: const [
                ArticleListWidget(),
                // Positioned(
                //   top: 30,
                //   right: 0,
                //   child: ClipRRect(
                //     borderRadius: const BorderRadius.only(
                //       bottomLeft: Radius.circular(4),
                //       topLeft: Radius.circular(4),
                //     ),
                //     child: SizedBox(
                //       width: 25,
                //       child: ListView.builder(
                //         shrinkWrap: true,
                //         itemBuilder: (context, index) {
                //           return Column(
                //             children: [
                //               if (index != 0)
                //                 Container(height: 1, color: Colors.white),
                //               ClipRect(
                //                 child: MouseScaleWidget(
                //                   scale: 1.8,
                //                   child: Container(
                //                     width: 25,
                //                     height: 25,
                //                     alignment: Alignment.center,
                //                     decoration: const BoxDecoration(
                //                       color: Colors.redAccent,
                //                     ),
                //                     child: Text(
                //                       '$index',
                //                       style: const TextStyle(
                //                         color: Colors.white,
                //                         fontSize: 11,
                //                         fontWeight: FontWeight.w500,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           );
                //         },
                //         itemCount: 5,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ArticleListWidget extends StatelessWidget {
  const ArticleListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(builder: (context, screenInfo, widgetSize) {
      return GridView.builder(
        padding: EdgeInsets.all(widgetSize.width * 0.05),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ScreenType.values.indexOf(screenInfo.screenType) + 1,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
        ),
        itemBuilder: (context, index) {
          return const ArticleItemWidget();
        },
        itemCount: 100,
      );
    });
  }
}

class ArticleItemWidget extends StatelessWidget {
  const ArticleItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseShadowWidget(
      shadowRadius: 8,
      translate: 7,
      shadowColor: const Color(0x33333333),
      child: Container(),
    );
  }
}
