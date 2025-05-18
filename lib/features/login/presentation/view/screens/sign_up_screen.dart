import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_cubit.dart';
import 'package:healtho_gym/features/login/presentation/view/widgets/sign_up_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Always use RTL for Arabic
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => sl<AuthCubit>()),
                  BlocProvider(create: (_) => sl<ProfileCubit>()),
                ],
                child: const SignUpBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

