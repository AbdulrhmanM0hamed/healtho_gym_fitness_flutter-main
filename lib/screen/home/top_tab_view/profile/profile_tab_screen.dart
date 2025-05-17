import 'package:flutter/material.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/toast_helper.dart';
import 'package:healtho_gym/core/locale/app_localizations.dart';
import 'package:healtho_gym/screen/login/sign_in_screen.dart';
import 'package:healtho_gym/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({Key? key}) : super(key: key);

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  }

  Future<void> _handleSignOut() async {
    try {
      await _authViewModel.signOut();
      
      if (mounted) {
        ToastHelper.showSuccess(
          context: context,
          message: AppLocalizations.of(context).signOut,
        );
        
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
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

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
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
                    child: const Icon(
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
                          _authViewModel.user?.email ?? locale.profile,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _authViewModel.user?.email ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
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
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
} 