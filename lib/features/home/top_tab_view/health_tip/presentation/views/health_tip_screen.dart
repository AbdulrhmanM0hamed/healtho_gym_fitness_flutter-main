import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_cubit.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/viewmodels/health_tip_state.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/widgets/health_tip_row_updated.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/presentation/widgets/health_tip_shimmer.dart';

class HealthTipScreen extends StatefulWidget {
  const HealthTipScreen({super.key});

  @override
  State<HealthTipScreen> createState() => _HealthTipScreenState();
}

class _HealthTipScreenState extends State<HealthTipScreen> {
  final ScrollController _scrollController = ScrollController();
  late HealthTipCubit _healthTipCubit;
  
  @override
  void initState() {
    super.initState();
    _healthTipCubit = sl<HealthTipCubit>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _healthTipCubit.loadNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Load more when user scrolls to 80% of the list
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _healthTipCubit..getHealthTips(),
      child: Scaffold(
        body: BlocBuilder<HealthTipCubit, HealthTipState>(
          builder: (context, state) {
            if (state.status == HealthTipStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state.status == HealthTipStatus.loading && state.healthTips.isEmpty) {
              return const HealthTipListShimmer();
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
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            
            if (state.healthTips.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد نصائح صحية متاحة',
                  style: TextStyle(color: TColor.primaryText),
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HealthTipCubit>().refreshHealthTips();
              },
              color: TColor.primary,
              backgroundColor: Colors.white,
              strokeWidth: 3.0,
              displacement: 50,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              edgeOffset: 20,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                itemBuilder: (context, index) {
                  // Show loading indicator at the bottom while loading more
                  if (index >= state.healthTips.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  final healthTip = state.healthTips[index];
                  return HealthTipRowUpdated(
                    healthTip: healthTip,
                    onPressed: () {
                      // Empty - no navigation, expanding happens in the card itself
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemCount: state.status == HealthTipStatus.loadingMore 
                    ? state.healthTips.length + 1  // +1 for the loading indicator
                    : state.healthTips.length,
              ),
            );
          },
        ),
      ),
    );
  }
} 