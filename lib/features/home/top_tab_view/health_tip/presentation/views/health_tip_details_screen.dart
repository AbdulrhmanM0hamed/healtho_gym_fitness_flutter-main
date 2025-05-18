import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_state.dart';

class HealthTipDetailScreen extends StatefulWidget {
  final String tipId;
  
  const HealthTipDetailScreen({super.key, required this.tipId});

  @override
  State<HealthTipDetailScreen> createState() => _HealthTipDetailScreenState();
}

class _HealthTipDetailScreenState extends State<HealthTipDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HealthTipCubit>()..getHealthTipById(widget.tipId),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: TColor.secondary,
          centerTitle: false,
          title: const Text(
            "Health Tip",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocBuilder<HealthTipCubit, HealthTipState>(
          builder: (context, state) {
            if (state.status == HealthTipStatus.loading) {
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
                        context.read<HealthTipCubit>().getHealthTipById(widget.tipId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            final tip = state.selectedTip;
            if (tip == null) {
              return Center(
                child: Text(
                  'Health tip not found',
                  style: TextStyle(color: TColor.primaryText),
                ),
              );
            }
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: tip.imageUrl != null && tip.imageUrl!.isNotEmpty
                              ? Image.network(
                                  tip.imageUrl!,
                                  width: double.maxFinite,
                                  height: MediaQuery.of(context).size.width * 0.5,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/img/home_1.png",
                                      width: double.maxFinite,
                                      height: MediaQuery.of(context).size.width * 0.5,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/img/home_1.png",
                                  width: double.maxFinite,
                                  height: MediaQuery.of(context).size.width * 0.5,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          tip.title,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tip.content,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<HealthTipCubit, HealthTipState>(
          builder: (context, state) {
            if (state.status != HealthTipStatus.loaded || state.selectedTip == null) {
              return const SizedBox.shrink();
            }
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                  ),
                ]
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<HealthTipCubit>().updateLikes(
                        state.selectedTip!.id, 
                        state.selectedTip!.likes ?? 0
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/img/fav_color.png",
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${state.selectedTip!.likes ?? 0}',
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      // Share functionality
                    },
                    child: Image.asset(
                      "assets/img/share.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 