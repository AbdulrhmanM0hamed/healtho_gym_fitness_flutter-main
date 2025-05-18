import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_state.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/views/health_tip_details_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/widgets/health_tip_row.dart';

class HealthTipScreen extends StatefulWidget {
  const HealthTipScreen({super.key});

  @override
  State<HealthTipScreen> createState() => _HealthTipScreenState();
}

class _HealthTipScreenState extends State<HealthTipScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HealthTipCubit>()..getHealthTips(),
      child: Scaffold(
        body: BlocBuilder<HealthTipCubit, HealthTipState>(
          builder: (context, state) {
            if (state.status == HealthTipStatus.loading && state.healthTips.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state.status == HealthTipStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error: ${state.errorMessage}',
                      style: TextStyle(color: TColor.primaryText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HealthTipCubit>().getHealthTips();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state.healthTips.isEmpty) {
              return Center(
                child: Text(
                  'No health tips available',
                  style: TextStyle(color: TColor.primaryText),
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HealthTipCubit>().getHealthTips();
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemBuilder: (context, index) {
                  final tip = state.healthTips[index];
                  return HealthTipRow(
                    tip: tip,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthTipDetailScreen(tipId: tip.id),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemCount: state.healthTips.length,
              ),
            );
          },
        ),
      ),
    );
  }
} 