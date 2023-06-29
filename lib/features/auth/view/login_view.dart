import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/common.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/core/utils/snackbar.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/auth/view/register_view.dart';
import 'package:twitter_clone_apps/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone_apps/features/home/view/home_view.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const LoginView());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final authController = ref.read(authControllerProvider.notifier);

    final isLoading = useState(false);

    return Scaffold(
      appBar: const MyAppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AuthField(hintText: 'Email', controller: emailController),
                  const SizedBox(height: 10),
                  AuthField(hintText: 'Password', controller: passwordController, obscureText: true),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RoundedSmallButton(
                      isLoading: isLoading.value,
                      label: "Done",
                      onTap: () async {
                        isLoading.value = true;
                        final response = await authController.signIn(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        response.fold((failure) => showSnackbar(context, failure.message), (session) {
                          Navigator.of(context).pushReplacement(HomeView.route());
                        });

                        isLoading.value = false;
                      },
                      backgroundColor: Palette.whiteColor,
                      textColor: Palette.blackColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: "Doesn't have an account? ",
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: AppTextStyles.body.primary,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, RegisterView.route());
                            },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
