import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Health Tips',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add New', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.secondary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddHealthTipScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<HealthTipCubit, HealthTipState>(
                  builder: (context, state) {
                    if (state.isLoading && state.healthTips.isEmpty) {
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
                                context.read<HealthTipCubit>().loadHealthTips();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    if (state.healthTips.isEmpty) {
                      return const Center(
                        child: Text('No health tips found. Add some!'),
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
                                  DataColumn(label: Text('Title')),
                                  DataColumn(label: Text('Subtitle')),
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Featured')),
                                  DataColumn(label: Text('Likes')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: state.healthTips.map((tip) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                        tip.title.length > 30
                                            ? '${tip.title.substring(0, 30)}...'
                                            : tip.title,
                                      )),
                                      DataCell(Text(
                                        tip.subtitle.length > 30
                                            ? '${tip.subtitle.substring(0, 30)}...'
                                            : tip.subtitle,
                                      )),
                                      DataCell(Text(
                                        _formatDate(tip.createdAt),
                                      )),
                                      DataCell(
                                        IconButton(
                                          icon: tip.isFeatured 
                                            ? const Icon(Icons.star, color: Colors.amber)
                                            : const Icon(Icons.star_border),
                                          onPressed: () {
                                            context.read<HealthTipCubit>().toggleFeaturedStatus(
                                              tip.id,
                                              !tip.isFeatured,
                                            );
                                          },
                                        ),
                                      ),
                                      DataCell(Text('${tip.likes ?? 0}')),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              color: Colors.blue,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditHealthTipScreen(tipId: tip.id),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              color: Colors.red,
                                              onPressed: () {
                                                _showDeleteConfirmation(context, tip);
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
                                    : () => context.read<HealthTipCubit>().loadMoreHealthTips(),
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
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  void _showDeleteConfirmation(BuildContext context, HealthTipModel tip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Health Tip'),
        content: Text('Are you sure you want to delete "${tip.title}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<HealthTipCubit>().deleteHealthTip(tip.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Health tip deleted successfully'),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 