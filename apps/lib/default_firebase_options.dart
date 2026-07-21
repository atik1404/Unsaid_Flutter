import 'package:app_env/environment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/services.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError("NOT_CONFIGURED");
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      default:
        throw UnsupportedError("NOT_CONFIGURED");
    }
  }

  static final FirebaseOptions _android = AppConfig.I.environment.isDev
      ? FirebaseOptions(
          apiKey: "AIzaSyCVhJT_TQA0Be8Cjnv8M5dk6OpJ6WZzres",
          appId: "1:120303265504:android:618e0fe3a9928852199285",
          messagingSenderId: "120303265504",
          projectId: "multi-mode-development",
          storageBucket: "multi-mode-development.firebasestorage.app",
        )
      : FirebaseOptions(
          apiKey: "AIzaSyDlu8Gem-GEvlIpOh1XN0Gf4LbreFzEaBw",
          appId: "1:641082680520:android:4faf6fc58164fea56771fd",
          messagingSenderId: "641082680520",
          projectId: "jatri-retail-platform-prod",
          storageBucket: "jatri-retail-platform-prod.firebasestorage.app",
        );

  static final FirebaseOptions _ios = AppConfig.I.environment.isDev
      ? FirebaseOptions(
          apiKey: "AIzaSyDdTdfXidrEEHpPx41FjWDg_uEVNjXWMfE",
          appId: "1:120303265504:ios:f7f6f3b0dbba1a78199285",
          messagingSenderId: "120303265504",
          projectId: "multi-mode-development",
          storageBucket: "multi-mode-development.firebasestorage.app",
          iosBundleId: "co.jatri.app.user",
        )
      : FirebaseOptions(
          apiKey: "AIzaSyAeW_Ctbpe__rXX-xh8hj0w6cN7yFAPAjU",
          appId: "1:641082680520:ios:94acaa36605c94236771fd",
          messagingSenderId: "641082680520",
          projectId: "jatri-retail-platform-prod",
          storageBucket: "jatri-retail-platform-prod.firebasestorage.app",
          iosBundleId: "co.jatri.app.user",
        );
}
