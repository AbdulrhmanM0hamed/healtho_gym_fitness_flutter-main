import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/custom_text_field.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/routes/app_routes.dart';
import 'package:healtho_gym/core/utils/validation_util.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_state.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.isEmpty) {
      final locale = AppLocalizations.of(context);
      ToastHelper.showAuthError(
        context: context,
        message: locale.fillAllFields,
      );
      return;
    }
    
    context.read<AuthCubit>().resetPassword(_emailController.text.trim()).then((success) {
      if (success && mounted) {
        final locale = AppLocalizations.of(context);
        ToastHelper.showSuccess(
          context: context,
          title: locale.success,
          message: locale.passwordResetSent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.hasError) {
          ToastHelper.showAuthError(
            context: context,
            message: state.errorMessage,
            onRetry: () {
              _handleSignIn();
            },
          );
        } else if (state.isAuthenticated) {
          // Show success message and navigate to home screen
          ToastHelper.showFlushbar(
            context: context,
            title: locale.success,
            message: locale.loginSuccess,
            type: ToastType.success,
            duration: const Duration(seconds: 2),
          );
          
          // Navigate to home screen after showing the toast
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              AppRoutes.navigateAndClearStack(context, AppRoutes.home);
            }
          });
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                "assets/img/app_logo.png",
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              const SizedBox(height: 40),
              Text(
                locale.welcomeBack,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                locale.signInToContinue,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              
              // Email Field
              CustomTextField(
                hintText: locale.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: ValidationUtil.validateEmail,
              ),
              const SizedBox(height: 20),
              
              // Password Field
              CustomTextField(
                hintText: locale.password,
                controller: _passwordController,
                isPassword: !_isPasswordVisible,
                prefixIcon: Icons.lock_outline,
                suffix: InkWell(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible 
                        ? Icons.visibility_outlined 
                        : Icons.visibility_off_outlined,
                    color: Theme.of(context).hintColor,
                    size: 20,
                  ),
                ),
                validator: ValidationUtil.validatePassword,
              ),
              
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: state.isLoading ? null : _handleForgotPassword,
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    locale.forgotPassword,
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Sign In Button
              state.isLoading
                  ? const CircularProgressIndicator()
                  : RoundButton(
                      title: locale.signIn,
                      onPressed: _handleSignIn,
                    ),
              
              const SizedBox(height: 30),
              
              // Or continue with
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: TColor.board,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      locale.orContinueWith,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: TColor.board,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Social login buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: state.isLoading ? null : () {
                        // Implement Facebook login
                        ToastHelper.showToast(
                          message: "Facebook login coming soon!",
                          type: ToastType.info,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xff3A91F7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img/fb_logo.png",
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Facebook",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: state.isLoading ? null : () {
                        // Implement Google login
                        ToastHelper.showToast(
                          message: "Google login coming soon!",
                          type: ToastType.info,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: TColor.board.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img/google_logo.png",
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Google",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Don't have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locale.dontHaveAccount,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: state.isLoading ? null : () {
                      AppRoutes.navigateTo(context, AppRoutes.signUp);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      locale.signUp,
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
} 