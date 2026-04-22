import 'package:flutter/material.dart';

/// Global route observer. Pass to GoRouter's [observers] list in the DI module.
final routeObserver = RouteObserver<ModalRoute<void>>();

/// Root navigator key. Pass to GoRouter's [navigatorKey] in the DI module.
final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
