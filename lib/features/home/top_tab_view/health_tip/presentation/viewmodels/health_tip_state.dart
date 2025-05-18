import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/models/health_tip_model.dart';

enum HealthTipStatus { initial, loading, loadingMore, loaded, error }

class HealthTipState extends Equatable {
  final HealthTipStatus status;
  final List<HealthTipModel> healthTips;
  final HealthTipModel? selectedTip;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;

  const HealthTipState({
    this.status = HealthTipStatus.initial,
    this.healthTips = const [],
    this.selectedTip,
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.itemsPerPage = 10,
    this.totalItems = 0,
  });

  HealthTipState copyWith({
    HealthTipStatus? status,
    List<HealthTipModel>? healthTips,
    HealthTipModel? selectedTip,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
    int? itemsPerPage,
    int? totalItems,
  }) {
    return HealthTipState(
      status: status ?? this.status,
      healthTips: healthTips ?? this.healthTips,
      selectedTip: selectedTip ?? this.selectedTip,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object?> get props => [
    status, 
    healthTips, 
    selectedTip, 
    errorMessage, 
    hasReachedMax, 
    currentPage, 
    itemsPerPage,
    totalItems,
  ];
} 