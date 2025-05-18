import 'package:equatable/equatable.dart';
import '../../data/models/health_tip_model.dart';

enum HealthTipStatus {
  initial,
  loading,
  success,
  error,
}

class HealthTipState extends Equatable {
  final HealthTipStatus status;
  final List<HealthTipModel> healthTips;
  final List<HealthTipModel> featuredHealthTips;
  final HealthTipModel? selectedHealthTip;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final bool hasMoreItems;
  final String errorMessage;
  
  const HealthTipState({
    this.status = HealthTipStatus.initial,
    this.healthTips = const [],
    this.featuredHealthTips = const [],
    this.selectedHealthTip,
    this.totalCount = 0,
    this.currentPage = 0,
    this.pageSize = 10,
    this.hasMoreItems = true,
    this.errorMessage = '',
  });
  
  HealthTipState copyWith({
    HealthTipStatus? status,
    List<HealthTipModel>? healthTips,
    List<HealthTipModel>? featuredHealthTips,
    HealthTipModel? selectedHealthTip,
    int? totalCount,
    int? currentPage,
    int? pageSize,
    bool? hasMoreItems,
    String? errorMessage,
  }) {
    return HealthTipState(
      status: status ?? this.status,
      healthTips: healthTips ?? this.healthTips,
      featuredHealthTips: featuredHealthTips ?? this.featuredHealthTips,
      selectedHealthTip: selectedHealthTip ?? this.selectedHealthTip,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  bool get isLoading => status == HealthTipStatus.loading;
  bool get hasError => status == HealthTipStatus.error;
  bool get hasData => healthTips.isNotEmpty;
  
  @override
  List<Object?> get props => [
    status,
    healthTips,
    featuredHealthTips,
    selectedHealthTip,
    totalCount,
    currentPage,
    pageSize,
    hasMoreItems,
    errorMessage,
  ];
} 