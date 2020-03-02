import 'package:flutter/material.dart';

import '../pub/hlm_router.dart';

class DefaultAppBar extends AppBar {
  static const Color TITLE_BAR_COLOR = Color(0xFF446bFF);

  DefaultAppBar(
      {Widget leading,
      String titleName,
      List<Widget> actions,
      Color backgroundColor = TITLE_BAR_COLOR,
      double elevation = 0.0})
      : super(
            leading: leading ??
                Builder(
                  builder: (context) {
                    return IconButton(
                        highlightColor: TITLE_BAR_COLOR,
                        splashColor: TITLE_BAR_COLOR,
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 17),
                        onPressed: () {
                          HlmRouter.closeFlutterPage(context);
                        });
                  },
                ),
            title: Text(
              titleName,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            actions: actions,
            backgroundColor: backgroundColor,
            centerTitle: true,
            elevation: elevation);
}
