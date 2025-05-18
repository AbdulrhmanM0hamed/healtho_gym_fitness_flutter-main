import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/health_tip/data/models/health_tip_model.dart';

enum HealthTipStatus { initial, loading, loaded, error }

class HealthTipState extends Equatable {
  final HealthTipStatus status;
  final List<HealthTipModel> healthTips;
  final HealthTipModel? selectedTip;
  final String? errorMessage;

  const HealthTipState({
    this.status = HealthTipStatus.initial,
    this.healthTips = const [],
    this.selectedTip,
    this.errorMessage,
  });

  HealthTipState copyWith({
    HealthTipStatus? status,
    List<HealthTipModel>? healthTips,
    HealthTipModel? selectedTip,
    String? errorMessage,
  }) {
    return HealthTipState(
      status: status ?? this.status,
      healthTips: healthTips ?? this.healthTips,
      selectedTip: selectedTip ?? this.selectedTip,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, healthTips, selectedTip, errorMessage];
} 