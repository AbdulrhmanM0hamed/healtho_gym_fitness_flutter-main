import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_cubit.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_state.dart';
import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late final UserManagementCubit _userManagementCubit;

  @override
  void initState() {
    super.initState();
    _userManagementCubit = sl<UserManagementCubit>();
    _userManagementCubit.loadUsers();
  }

  @override
  void dispose() {
    // No need to close the cubit here as it will be handled by the service locator
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userManagementCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
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
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'إدارة المستخدمين',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<UserManagementCubit>().loadUsers(),
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white),
                      tooltip: 'تحديث القائمة',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: BlocConsumer<UserManagementCubit, UserManagementState>(
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
            if (state.isLoading && state.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: TColor.primary),
                    const SizedBox(height: 16),
                    Text(
                      'جاري تحميل المستخدمين...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            if (state.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.error_outline_rounded,
                          color: Colors.red, size: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'عذراً، حدث خطأ',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? '',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<UserManagementCubit>().loadUsers(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColor.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white),
                      label: const Text(
                        'إعادة المحاولة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state.users.isEmpty) {
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
                      child: Icon(Icons.people_outline,
                          size: 64, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'لا يوجد مستخدمون',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لم يتم العثور على أي مستخدمين حتى الآن',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserManagementCubit>().loadUsers();
              },
              color: TColor.primary,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.users.length + (state.hasMoreItems ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.users.length) {
                    return _buildLoadMoreButton(context, state);
                  }
                  final user = state.users[index];
                  final profile = user.profile;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: TColor.primary.withOpacity(0.1),
                        child: Icon(
                          profile?.isAdmin == true
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          color: profile?.isAdmin == true
                              ? Colors.amber
                              : TColor.primary,
                        ),
                      ),
                      title: Text(profile?.fullName ?? user.id,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email ?? '---',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 13)),
                          if (profile?.updateDate != null)
                            Text(
                                'آخر تحديث: ${_formatDate(profile!.updateDate!)}',
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: profile?.isAdmin ?? false,
                            activeColor: Colors.amber,
                            onChanged: profile == null
                                ? null
                                : (value) => _showAdminStatusConfirmation(
                                    context, profile, value),
                          ),
                          IconButton(
                            icon: const Icon(Icons.visibility_rounded),
                            color: TColor.primary,
                            tooltip: 'عرض التفاصيل',
                            onPressed: () => _showUserDetails(context, user),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildLoadMoreButton(BuildContext context, UserManagementState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () => context.read<UserManagementCubit>().loadMoreUsers(),
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

  void _showAdminStatusConfirmation(
    BuildContext context,
    UserProfileModel profile,
    bool newStatus,
  ) {
    final action = newStatus ? 'منح' : 'سحب';
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$action صلاحية الأدمن'),
        content: Text(
            'هل أنت متأكد من $action صلاحية الأدمن للمستخدم "${profile.fullName ?? profile.userId}"؟'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              context
                  .read<UserManagementCubit>()
                  .toggleAdminStatus(profile.id, profile.userId, newStatus);
              Navigator.pop(dialogContext);
              ToastHelper.showFlushbar(
                context: context,
                title: 'تم التحديث',
                message:
                    newStatus ? 'تم منح صلاحية الأدمن' : 'تم سحب صلاحية الأدمن',
                type: ToastType.success,
              );
            },
            child: Text('$action'),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, dynamic user) {
    // الحصول على بيانات المستخدم من خلال خاصية profile
    final profile = user.profile;

    if (profile == null) {
      ToastHelper.showFlushbar(
        context: context,
        title: 'خطأ',
        message: 'لا يمكن عرض بيانات المستخدم',
        type: ToastType.error,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تفاصيل المستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('معرف المستخدم: ${profile.id}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('الاسم الكامل: ${profile.fullName ?? "غير متوفر"}'),
            const SizedBox(height: 4),
            Text(
                'العمر: ${profile.age != null ? "${profile.age} سنة" : "غير متوفر"}'),
            const SizedBox(height: 4),
            Text(
                'الطول: ${profile.height != null ? "${profile.height} سم" : "غير متوفر"}'),
            const SizedBox(height: 4),
            Text(
                'الوزن: ${profile.weight != null ? "${profile.weight} كجم" : "غير متوفر"}'),
            const SizedBox(height: 4),
            Text('الهدف: ${profile.goal ?? "غير متوفر"}'),
            const SizedBox(height: 4),
            Text('مستوى اللياقة: ${profile.fitnessLevel ?? "غير متوفر"}'),
            const SizedBox(height: 4),
            Text('حالة الأدمن: ${profile.isAdmin ? "أدمن" : "مستخدم عادي"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
