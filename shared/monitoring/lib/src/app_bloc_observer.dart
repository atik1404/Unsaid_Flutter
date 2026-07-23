import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ---------------------------------------------------------------------------
/// Global Bloc/Cubit observer that funnels business-logic-layer failures into
/// the [CrashReporter].
///
/// In this app the Bloc/Cubit layer is the "ViewModel" equivalent. Most errors
/// there are handled explicitly (caught and turned into a `Result.failure`
/// state), so [onError] only fires for *unhandled* exceptions inside an event
/// handler — exactly the ones we want in Sentry. Because handled failures never
/// throw, they are NOT double-reported here (see also `RestClient._logError`).
///
/// [onChange] additionally drops a lightweight breadcrumb so a crash report
/// shows the sequence of state changes that led up to it.
/// ---------------------------------------------------------------------------
final class AppBlocObserver extends BlocObserver {
  const AppBlocObserver(this._crashReporter);

  final CrashReporter _crashReporter;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // Tag with the bloc runtime type so issues group by originating feature.
    _crashReporter.captureException(
      error,
      stackTrace: stackTrace,
      tags: {'bloc': bloc.runtimeType.toString()},
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    _crashReporter.addBreadcrumb(
      AppBreadcrumb(
        message: '${bloc.runtimeType}: ${change.nextState.runtimeType}',
        category: 'bloc',
        level: BreadcrumbLevel.debug,
      ),
    );
    super.onChange(bloc, change);
  }
}
