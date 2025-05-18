import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/view/widgets/sign_in_body.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
              child: BlocProvider(
                create: (_) => sl<AuthCubit>(),
                child: const SignInBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 