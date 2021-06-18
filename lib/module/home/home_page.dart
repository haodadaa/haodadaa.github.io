import 'package:blog/module/global/global_bloc.dart';
import 'package:blog/widget/button.dart';
import 'package:blog/widget/fold_widget.dart';
import 'package:blog/widget/mouse_region_effect.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? markdownString;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themeStyle.backgroundColor,
      body: FoldWidget(
        // displayPadding: const EdgeInsets.only(top: 52, right: 52),
        // initial: FoldStatus.fold,
        background: Container(
          height: 52,
          child: Row(
            children: [
              Spacer(),
              DayNightSwitcher(
                assets: [
                  context.localImage.themeDay,
                  context.localImage.themeNight,
                ],
                onTap: (index) {
                  context.globalBloc
                      .add(ChangeAppTheme(AppTheme.values[index]));
                  // // 切换主题风格
                  // context.globalBloc.add(SwitchAppTheme());
                },
              ),
              SizedBox(width: 14),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(width: 24),
            ],
          ),
        ),
        display: Container(
          decoration: BoxDecoration(
            color: context.themeStyle.primaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
            ),
          ),
          child: Stack(
            children: [
              GridView.builder(
                padding: EdgeInsets.all(30),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                ),
                itemBuilder: (context, index) {
                  return MouseShadowWidget(
                    translate: 7,
                    shadowColor: Color(0x33333333),
                    child: Container(),
                  );
                },
                itemCount: 20,
              ),
              Positioned(
                top: 30,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    topLeft: Radius.circular(4),
                  ),
                  child: Container(
                    width: 25,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (index != 0)
                              Container(height: 1, color: Colors.white),
                            ClipRect(
                              child: MouseScaleWidget(
                                scale: 1.8,
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                  ),
                                  child: Text(
                                    '$index',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: 5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
