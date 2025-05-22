import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';
import 'add_health_tip_screen.dart';
import 'edit_health_tip_screen.dart';
import '../../data/models/health_tip_model.dart';
import '../viewmodels/health_tip_cubit.dart';
import '../viewmodels/health_tip_state.dart';

class HealthTipsListScreen extends StatelessWidget {
  const HealthTipsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HealthTipCubit>()..loadHealthTips(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildBody(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAddTip(context),
          backgroundColor: TColor.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'إضافة نصيحة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'النصائح الصحية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إدارة وتنظيم النصائح الصحية',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => context.read<HealthTipCubit>().loadHealthTips(),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              tooltip: 'تحديث القائمة',
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<HealthTipCubit, HealthTipState>(
      listener: (context, state) {
        if (state.hasError) {
          ToastHelper.showFlushbar(
            context: context,
            title: 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ غير متوقع',
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.healthTips.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: TColor.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'جاري تحميل النصائح...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (state.healthTips.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.tips_and_updates_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'لا توجد نصائح صحية',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أضف نصيحة جديدة لمساعدة المستخدمين',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => _navigateToAddTip(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                  label: const Text(
                    'إضافة نصيحة جديدة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HealthTipCubit>().loadHealthTips();
          },
          color: TColor.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.healthTips.length + (state.hasMoreItems ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.healthTips.length) {
                return _buildLoadMoreButton(context, state);
              }
              return _buildHealthTipCard(context, state.healthTips[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildHealthTipCard(BuildContext context, HealthTipModel tip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip.subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    tip.isFeatured ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: tip.isFeatured ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    context.read<HealthTipCubit>().toggleFeaturedStatus(
                      tip.id,
                      !tip.isFeatured,
                    );
                  },
                  tooltip: tip.isFeatured ? 'إلغاء التمييز' : 'تمييز النصيحة',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(tip.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.favorite_rounded,
                  size: 16,
                  color: Colors.red[400],
                ),
                const SizedBox(width: 4),
                Text(
                  '${tip.likes ?? 0}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _navigateToEditTip(context, tip),
                  icon: const Icon(Icons.edit_rounded),
                  tooltip: 'تعديل النصيحة',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, tip),
                  icon: const Icon(Icons.delete_rounded),
                  tooltip: 'حذف النصيحة',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context, HealthTipState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () => context.read<HealthTipCubit>().loadMoreHealthTips(),
          style: ElevatedButton.styleFrom(
            backgroundColor: TColor.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: state.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'تحميل المزيد',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToAddTip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<HealthTipCubit>(),
          child: const AddHealthTipScreen(),
        ),
      ),
    ).then((value) {
      if (value == true) {
        context.read<HealthTipCubit>().loadHealthTips();
        ToastHelper.showFlushbar(
          context: context,
          title: 'تمت الإضافة بنجاح',
          message: 'تم إضافة النصيحة الجديدة بنجاح',
          type: ToastType.success,
        );
      }
    });
  }

  void _navigateToEditTip(BuildContext context, HealthTipModel tip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<HealthTipCubit>(),
          child: EditHealthTipScreen(tipId: tip.id),
        ),
      ),
    ).then((value) {
      if (value == true) {
        context.read<HealthTipCubit>().loadHealthTips();
        ToastHelper.showFlushbar(
          context: context,
          title: 'تم التعديل بنجاح',
          message: 'تم تعديل النصيحة بنجاح',
          type: ToastType.success,
        );
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context, HealthTipModel tip) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل أنت متأكد من حذف نصيحة "${tip.title}"؟',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'لا يمكن التراجع عن هذا الإجراء.',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'إلغاء',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.read<HealthTipCubit>().deleteHealthTip(tip.id);
              Navigator.pop(dialogContext);
              ToastHelper.showFlushbar(
                context: context,
                title: 'تم الحذف بنجاح',
                message: 'تم حذف النصيحة بنجاح',
                type: ToastType.success,
              );
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
            label: const Text(
              'حذف',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 