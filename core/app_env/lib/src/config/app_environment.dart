enum AppEnvironment {
  dev,
  prod;

  bool get isDev => this == AppEnvironment.dev;
  bool get isProd => this == AppEnvironment.prod;
  String get label {
    switch (this) {
      case AppEnvironment.dev:
        return 'DEV';
      case AppEnvironment.prod:
        return 'PROD';
    }
  }
}
