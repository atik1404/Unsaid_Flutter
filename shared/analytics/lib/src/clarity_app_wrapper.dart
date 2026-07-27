import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/widgets.dart';

/// ---------------------------------------------------------------------------
/// Wraps the app's root widget in Clarity's [ClarityWidget] so Microsoft
/// Clarity can record the session (its core capability) and correlate the
/// custom events sent via [ClarityAnalyticsTracker].
///
/// When [projectId] is empty (secrets not configured) it returns [child]
/// unchanged, so the app renders identically with analytics disabled.
///
/// ## Lifecycle
///
/// This sits directly under `runApp`, so Clarity is initialised once per app
/// launch, before the first frame, and lives for the whole process. The SDK
/// itself owns session continuity across launches (resuming a recent session or
/// starting a new one) and pauses/resumes with the app lifecycle, so nothing
/// here needs to re-initialise it. Session identity is only forced to change on
/// logout, via `AnalyticsTracker.reset()`.
///
/// Clarity supports Android and iOS only; on any other target the SDK declines
/// to start and the app simply renders without recording.
///
/// Usage (in bootstrap):
/// ```dart
/// runApp(ClarityAppWrapper(projectId: config.clarityProjectId, child: const AppEntry()));
/// ```
/// ---------------------------------------------------------------------------
final class ClarityAppWrapper extends StatelessWidget {
  const ClarityAppWrapper({
    super.key,
    required this.projectId,
    required this.child,
  });

  final String projectId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Trim once here: the SDK rejects a project id with surrounding whitespace,
    // and an id read from a `.env` file can easily pick some up.
    final id = projectId.trim();
    if (id.isEmpty) return child; // analytics disabled

    return ClarityWidget(
      app: child,
      clarityConfig: ClarityConfig(
        projectId: id,
        // Keep the plugin quiet in logs; we drive everything via the tracker.
        logLevel: LogLevel.None,
      ),
    );
  }
}
