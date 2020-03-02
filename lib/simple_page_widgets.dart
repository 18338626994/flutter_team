import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hlm_flut/widgets/default_app_bar.dart';
import './platform_view.dart';
import './pub/hlm_router.dart';
import './pub/hlm_plugin.dart';
import './pub/hlm_network.dart';

class FirstRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(titleName: "First Route"),
      body: Center(
        child: RaisedButton(
          child: Text('Open the 2nd Page'),
          onPressed: () {
            print("open second page!");
            HlmRouter.openFlutterPage("second", needResponse: true)
                .then((Map value) {
              Fluttertoast.showToast(msg: value.toString());
            });
          },
        ),
      ),
    );
  }
}

class SecondRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(titleName: "Second Route"),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.

            HlmRouter.closeFlutterPage(context,
                result: {"result": "data from second"});
          },
          child: Text('Go back with flutter result!'),
        ),
      ),
    );
  }
}

class TabRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(titleName: "Tab Route"),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            HlmRouter.openFlutterPage("second");
          },
          child: Text('Open second route'),
        ),
      ),
    );
  }
}

class PlatformRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Platform Route"),
      ),
      body: Center(
        child: RaisedButton(
          child: TextView(),
          onPressed: () {
            print("open second page!");
            HlmRouter.openFlutterPage("second", needResponse: true)
                .then((Map value) {
              print(
                  "call me when page is finished. did recieve second route result $value");
            });
          },
        ),
      ),
    );
  }
}

class FlutterRouteWidget extends StatefulWidget {
  FlutterRouteWidget({this.params, this.message});

  final Map params;
  final String message;

  @override
  _FlutterRouteWidgetState createState() => _FlutterRouteWidgetState();
}

class _FlutterRouteWidgetState extends State<FlutterRouteWidget> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String message = widget.message;
    return Scaffold(
      appBar: DefaultAppBar(titleName: "Flutter DEMO"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text(
                  message ??
                      "This is a flutter activity \n params:${widget.params}",
                  style: TextStyle(fontSize: 28.0, color: Colors.blue),
                ),
                alignment: AlignmentDirectional.center,
              ),
//                Expanded(child: Container()),
              const CupertinoTextField(
                prefix: Icon(
                  CupertinoIcons.person_solid,
                  color: CupertinoColors.lightBackgroundGray,
                  size: 28.0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                clearButtonMode: OverlayVisibilityMode.editing,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.0, color: CupertinoColors.inactiveGray)),
                ),
                placeholder: 'Name',
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      '调用本地方法',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => HlmPlugin().getAppInfo(),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      '获取登录用户信息',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () {
                  HlmNetwork.shareInstance()
                      .request("/appRequest/v1/loginuser/achieveLoginUserInfo")
                      .then((value) {
                    Fluttertoast.showToast(msg: value.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open native page',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),

                ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                ///例如：sample://nativePage?aaa=bbb
                onTap: () {
                  HlmRouter.openNativePage("/native/testNative",
                      needResponse: true,
                      params: {
                        "query": {"aaa": "bbb2dsdsd"}
                      }).then((Map value) {
                    Fluttertoast.showToast(msg: value.toString());
                  });
                },
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open first',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),

                ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                ///例如：sample://nativePage?aaa=bbb
                onTap: () =>
                    HlmRouter.openFlutterPage("first", params: {"aaa": "bbb"}),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open second',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),

                ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                ///例如：sample://nativePage?aaa=bbb
                onTap: () => HlmRouter.openFlutterPage("second",
                    params: {"requestCode": 1, "aaa": "bbb"}),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open tab',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),

                ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                ///例如：sample://nativePage?aaa=bbb
                onTap: () =>
                    HlmRouter.openFlutterPage("tab", params: {"aaa": "bbb"}),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open flutter page',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),

                ///后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                ///例如：sample://nativePage?aaa=bbb
                onTap: () => HlmRouter.openFlutterPage("rootPage",
                    params: {"aaa": "bbb"}),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'push flutter widget',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => PushWidget()));
                },
              ),

              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'push Platform demo',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PlatformRouteWidget()));
                },
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open web page',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => HlmRouter.openWebPage(
                    "https://mp.weixin.qq.com/s/mEwJE5mXwpmuWgVNL9O42g",
                    needResponse: true,
                    params: {"title": "百度一下"}).then((Map value) {
                  Fluttertoast.showToast(msg: value.toString());
                }),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open flutter fragment page',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => HlmRouter.openNativePage(
                        "/native/flutterFragment?flutterPage=flutterFragment",
                        needResponse: true)
                    .then((Map value) {
                  Fluttertoast.showToast(msg: value.toString());
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FragmentRouteWidget extends StatelessWidget {
  final Map params;

  FragmentRouteWidget(this.params);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(titleName: "Flutter FRAGMENT"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80.0),
            child: Text(
              "This is a flutter fragment",
              style: TextStyle(fontSize: 28.0, color: Colors.blue),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: Text(
              params['tag'] ?? '',
              style: TextStyle(fontSize: 28.0, color: Colors.red),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Expanded(child: Container()),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'Close page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () {
              HlmRouter.closeFlutterPage(context,
                  result: {"result": "data from fragment futter page"});
            },
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open native page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () {
              HlmRouter.openNativePage("/native/testNative",
                  needResponse: true,
                  params: {
                    "query": {"aaa": "bbbsgggg"}
                  }).then((Map value) {
                Fluttertoast.showToast(msg: value.toString());
              });
            },
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () => HlmRouter.openFlutterPage("rootPage"),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter fragment page',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () => HlmRouter.openNativePage("/native/flutterFragment",
                params: {"flutterPage": "flutterFragment"}),
          )
        ],
      ),
    );
  }
}

class PushWidget extends StatefulWidget {
  @override
  _PushWidgetState createState() => _PushWidgetState();
}

class _PushWidgetState extends State<PushWidget> {
  VoidCallback _backPressedListenerUnsub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _backPressedListenerUnsub?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterRouteWidget(message: "Pushed Widget");
  }
}
