import 'package:delete_account/src/delete_account_screen.dart';
import 'package:delete_account/src/state/delete_account_cubit.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

/// Router definition for the Delete Account screen.
///
/// Wraps [DeleteAccountScreen] in a [BlocProvider] so the cubit — with its
/// injected [DeleteAccountUseCase] — is scoped to this route's sub-tree and
/// torn down when the user leaves.
final class DeleteAccountScreenRouter implements BaseRouter {
  @override
  List<RouteBase> routes({List<RouteBase> children = const []}) {
    return [
      GoRoute(
        path: AppRouteName.deleteAccountPath,
        name: AppRouteName.deleteAccountScreen,
        pageBuilder: (_, state) => buildPageWithTransition(
          state: state,
          child: BlocProvider(
            create: (_) => DeleteAccountCubit(
              deleteAccountUseCase: GetIt.I<DeleteAccountUseCase>(),
            ),
            child: const DeleteAccountScreen(),
          ),
        ),
        routes: children,
      ),
    ];
  }
}
