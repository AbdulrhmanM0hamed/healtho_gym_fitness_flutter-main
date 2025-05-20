import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/core/routes/app_routes.dart';
import 'package:healtho_gym/dashboard/app/dashboard_app.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/auth_cubit/auth_state.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_cubit.dart';
import 'package:healtho_gym/features/login/presentation/viewmodels/user_profile_cubit/profile_state.dart';

class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({Key? key}) : super(key: key);

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    final authState = context.read<AuthCubit>().state;
    if (authState.isAuthenticated && authState.user != null) {
      context.read<ProfileCubit>().loadUserProfile(authState.user!.id);
    }
  }

  Future<void> _handleSignOut() async {
    try {
      final success = await context.read<AuthCubit>().signOut();

      if (success && mounted) {
        final locale = AppLocalizations.of(context);
        ToastHelper.showSuccess(
          context: context,
          title: locale.success,
          message: locale.signOut,
        );

        // Give toast time to be visible
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          AppRoutes.navigateAndClearStack(context, AppRoutes.signIn);
        }
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showAuthError(
          context: context,
          message: e.toString(),
        );
      }
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DashboardApp(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            final userProfile = profileState.userProfile;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: theme.colorScheme.primary,
                            child: userProfile?.profilePictureUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      userProfile!.profilePictureUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, _) => const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProfile?.fullName ??
                                      user.email ??
                                      locale.profile,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user.email ?? '',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                if (userProfile?.isAdmin == true)
                                  const Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Chip(
                                      backgroundColor: Colors.amber,
                                      label: Text(
                                        'Admin',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Profile Options
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            icon: Icons.person_outline,
                            title: locale.personalInfo,
                            onTap: () {
                              // TODO: Navigate to personal info screen
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileOption(
                            icon: Icons.settings_outlined,
                            title: locale.settings,
                            onTap: () {
                              // TODO: Navigate to settings screen
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileOption(
                            icon: Icons.language_outlined,
                            title: locale.language,
                            onTap: () {
                              // TODO: Navigate to language screen
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileOption(
                            icon: Icons.dark_mode_outlined,
                            title: locale.darkMode,
                            onTap: () {
                              // TODO: Toggle dark mode
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileOption(
                            icon: Icons.notifications_outlined,
                            title: locale.notifications,
                            onTap: () {
                              // TODO: Navigate to notifications screen
                            },
                          ),
                          if (userProfile?.isAdmin == true) ...[
                            const Divider(height: 1),
                            _buildProfileOption(
                              icon: Icons.admin_panel_settings,
                              title: 'Admin Dashboard',
                              onTap: _navigateToDashboard,
                              highlight: true,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign Out Button
                    RoundButton(
                      title: locale.signOut,
                      onPressed: _handleSignOut,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final highlightColor = highlight ? Colors.amber : primaryColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: highlightColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: highlight ? FontWeight.bold : null,
                    color: highlight ? Colors.black87 : null,
                  ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: highlightColor,
            ),
          ],
        ),
      ),
    );
  }
}
