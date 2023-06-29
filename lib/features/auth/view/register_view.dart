import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/common.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/core/utils/snackbar.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/auth/widgets/auth_field.dart';

class RegisterView extends HookConsumerWidget {
  const RegisterView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const RegisterView());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullnameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

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
                  AuthField(hintText: 'Fullname', controller: fullnameController),
                  const SizedBox(height: 10),
                  AuthField(hintText: 'Email', controller: emailController),
                  const SizedBox(height: 10),
                  AuthField(hintText: 'Password', controller: passwordController, obscureText: true),
                  const SizedBox(height: 10),
                  AuthField(hintText: 'Confirm Password', controller: confirmPasswordController, obscureText: true),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RoundedSmallButton(
                      isLoading: isLoading.value,
                      label: "Submit",
                      onTap: () async {
                        isLoading.value = true;
                        final result = await authController.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          confirmPassword: confirmPasswordController.text,
                          displayName: fullnameController.text,
                        );

                        result.fold((l) => showSnackbar(context, l.message), (r) {
                          showSnackbar(context, 'Sign Up Success, please login');
                          Navigator.of(context).maybePop();
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
                      text: "Already have an account? ",
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(
                          text: "Login",
                          style: AppTextStyles.body.primary,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.maybePop(context);
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
