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
    if (projectId.trim().isEmpty) return child; // analytics disabled
    return ClarityWidget(
      app: child,
      clarityConfig: ClarityConfig(
        projectId: projectId,
        // Keep the plugin quiet in logs; we drive everything via custom events.
        logLevel: LogLevel.None,
      ),
    );
  }
}
