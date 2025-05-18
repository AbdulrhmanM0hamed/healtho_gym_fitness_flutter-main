import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_cubit.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/viewmodels/user_management_state.dart';
import 'package:healtho_gym/features/login/data/models/user_profile_model.dart';

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
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Users Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder<UserManagementCubit, UserManagementState>(
                      builder: (context, state) {
                        if (state.isLoading && state.users.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (state.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Error: ${state.errorMessage}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<UserManagementCubit>().loadUsers();
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (state.users.isEmpty) {
                          return const Center(
                            child: Text('No users found.'),
                          );
                        }
                        
                        return Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('User ID')),
                                      DataColumn(label: Text('Full Name')),
                                      DataColumn(label: Text('Admin Status')),
                                      DataColumn(label: Text('Last Updated')),
                                      DataColumn(label: Text('Actions')),
                                    ],
                                    rows: state.users.map((user) {
                                      final profile = user.profile;
                                      if (profile == null) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(user.id)),
                                            const DataCell(Text('Profile Not Set')),
                                            const DataCell(Text('No')),
                                            const DataCell(Text('Never')),
                                            const DataCell(Text('N/A')),
                                          ],
                                        );
                                      }
                                      
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(profile.userId)),
                                          DataCell(Text(profile.fullName ?? 'Not Set')),
                                          DataCell(
                                            Switch(
                                              value: profile.isAdmin,
                                              activeColor: Colors.amber,
                                              onChanged: (value) {
                                                _showAdminStatusConfirmation(
                                                  context, 
                                                  profile, 
                                                  value,
                                                );
                                              },
                                            ),
                                          ),
                                          DataCell(Text(
                                            profile.updateDate != null
                                                ? _formatDate(profile.updateDate!)
                                                : 'Never',
                                          )),
                                          DataCell(
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.visibility),
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    _showUserDetails(context, user);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              
                              // Load more button
                              if (state.hasMoreItems)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton(
                                    onPressed: state.isLoading 
                                        ? null 
                                        : () => context.read<UserManagementCubit>().loadMoreUsers(),
                                    child: state.isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text('Load More'),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  void _showAdminStatusConfirmation(
    BuildContext context, 
    UserProfileModel profile, 
    bool newStatus,
  ) {
    final action = newStatus ? 'grant' : 'revoke';
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$action Admin Access'),
        content: Text(
          'Are you sure you want to $action admin privileges for ${profile.fullName ?? profile.userId}?'
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Get the cubit reference from the context captured in the outer function
              final cubit = context.read<UserManagementCubit>();
              
              // Call the method
              cubit.toggleAdminStatus(
                profile.id,
                profile.userId,
                newStatus,
              );
              
              Navigator.pop(dialogContext);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Admin status ${newStatus ? 'granted' : 'revoked'} successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              newStatus ? 'Grant Access' : 'Revoke Access',
              style: TextStyle(
                color: newStatus ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showUserDetails(BuildContext context, dynamic user) {
    final profile = user.profile;
    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No profile available for this user'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Profile Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('User ID:', profile.userId),
              _buildDetailRow('Full Name:', profile.fullName),
              _buildDetailRow('Age:', profile.age?.toString()),
              _buildDetailRow('Height:', profile.height != null 
                  ? '${profile.height} cm' : null),
              _buildDetailRow('Weight:', profile.weight != null 
                  ? '${profile.weight} kg' : null),
              _buildDetailRow('Goal:', profile.goal),
              _buildDetailRow('Fitness Level:', profile.fitnessLevel),
              _buildDetailRow('Admin Status:', profile.isAdmin ? 'Yes' : 'No'),
              _buildDetailRow('Last Updated:', profile.updateDate != null 
                  ? _formatDate(profile.updateDate!) : 'Never'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? 'Not set'),
          ),
        ],
      ),
    );
  }
} 