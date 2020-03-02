import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:hlm_flutter/pub/hlm_plugin.dart';

class HlmRouter {
  static const String key_Route = "route";
  static const String key_Query = "query";
  static const String key_RequestCode = "requestCode";
  static openFlutterPage(String pageName,
      {bool needResponse = false, Map<dynamic, dynamic> params}) {
    Map route = Map();
    Map urlParams = Map();

    route.putIfAbsent("flutterPage", () => pageName);
    if (needResponse) {
      route.putIfAbsent(key_RequestCode, () => 1);
    }
    urlParams.putIfAbsent(key_Route, () => route);

    if (params != null) {
      urlParams.putIfAbsent(key_Query, () => params);
    }

    return FlutterBoost.singleton.open("/hybrid/flutter", urlParams: urlParams);
  }

  static openNativePage(String nativePath,
      {bool needResponse = false, Map<dynamic, dynamic> params}) {
    Map urlParams = Map();
    if (needResponse) {
      urlParams.putIfAbsent(key_Route, () => {key_RequestCode: 1});
    }

    if (params != null) {
      urlParams.putIfAbsent(key_Query, () => params);
    }

    return FlutterBoost.singleton.open(nativePath, urlParams: urlParams);
  }

  static openWebPage(String url,
      {bool needResponse = false, Map<dynamic, dynamic> params}) {
    Map urlParams = Map();
    Map route = Map();

    route.putIfAbsent("url", () => url);
    if (needResponse) {
      route.putIfAbsent(key_RequestCode, () => 1);
    }
    urlParams.putIfAbsent(key_Route, () => route);

    if (params != null) {
      urlParams.putIfAbsent(key_Query, () => params);
    }

    return FlutterBoost.singleton.open("/hybrid/webView", urlParams: urlParams);
  }

  static closeFlutterPage(BuildContext context, {Map<dynamic, dynamic> result}) {
    BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(settings.uniqueId, result: result);
  }
}

class IOSRouterObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (Platform.isIOS) {
      BoostContainerState state = route.navigator as BoostContainerState;
      if (state.routerHistory.length == 1) {
        HlmPlugin().disableNavigatorPop();
      }
    }
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (Platform.isIOS) {
      BoostContainerState state = route.navigator as BoostContainerState;
      if (state.routerHistory.length >= 1) {
        HlmPlugin().disableNavigatorPop();
      }
    }
  }
}