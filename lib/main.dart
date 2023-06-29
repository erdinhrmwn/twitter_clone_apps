import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/app_loader.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/auth/view/login_view.dart';
import 'package:twitter_clone_apps/features/home/view/home_view.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      runApp(const ProviderScope(child: MyApp()));
    },
    // ignore: only_throw_errors
    (error, stackTrace) => throw error,
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: ref.watch(currentUserProvider).when(
            data: (user) {
              // return const LoginView();
              return user != null ? const HomeView() : const LoginView();
            },
            loading: () => const Scaffold(body: AppLoader()),
            error: (e, s) => const LoginView(),
          ),
    );
  }
}
