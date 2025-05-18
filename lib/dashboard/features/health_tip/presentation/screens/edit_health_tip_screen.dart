import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import '../../data/models/health_tip_model.dart';
import '../viewmodels/health_tip_cubit.dart';
import '../viewmodels/health_tip_state.dart';
import 'package:image_picker/image_picker.dart';

class EditHealthTipScreen extends StatefulWidget {
  final String tipId;
  
  const EditHealthTipScreen({super.key, required this.tipId});

  @override
  State<EditHealthTipScreen> createState() => _EditHealthTipScreenState();
}

class _EditHealthTipScreenState extends State<EditHealthTipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  
  bool _isFeatured = false;
  List<String> _tags = [];
  bool _isInitialized = false;
  XFile? _pickedFile;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _initializeForm(HealthTipModel tip) {
    if (_isInitialized) return;
    
    _titleController.text = tip.title;
    _subtitleController.text = tip.subtitle;
    _contentController.text = tip.content;
    _tags = tip.tags?.toList() ?? [];
    _isFeatured = tip.isFeatured;
    _isInitialized = true;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm(BuildContext context, HealthTipModel currentTip) async {
    if (_formKey.currentState!.validate()) {
      // Create updated health tip
      final updatedTip = currentTip.copyWith(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        content: _contentController.text,
        tags: _tags,
        isFeatured: _isFeatured,
      );

      final cubit = context.read<HealthTipCubit>();
      bool success;
      
      if (_pickedFile != null) {
        // Update with new image
        success = await cubit.updateHealthTipWithImage(updatedTip, _pickedFile!);
      } else {
        // Update without changing image
        success = await cubit.updateHealthTip(updatedTip);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health tip updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        foregroundColor: Colors.white,
        title: const Text('Edit Health Tip'),
      ),
      body: BlocProvider(
        create: (context) => sl<HealthTipCubit>()..getHealthTipById(widget.tipId),
        child: BlocConsumer<HealthTipCubit, HealthTipState>(
          listener: (context, state) {
            if (state.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
            
            // Initialize the form when data is loaded
            if (state.status == HealthTipStatus.success && state.selectedHealthTip != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initializeForm(state.selectedHealthTip!);
              });
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.selectedHealthTip == null) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final healthTip = state.selectedHealthTip;
            if (healthTip == null) {
              return const Center(
                child: Text('Health tip not found'),
              );
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Display/Preview
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            image: _pickedFile != null
                                ? DecorationImage(
                                    image: FileImage(File(_pickedFile!.path)),
                                    fit: BoxFit.cover,
                                  )
                                : healthTip.imageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(healthTip.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                          ),
                          child: (_pickedFile == null && healthTip.imageUrl == null)
                              ? const Icon(
                                  Icons.add_photo_alternate,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title Field
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Subtitle Field
                    TextFormField(
                      controller: _subtitleController,
                      decoration: const InputDecoration(
                        labelText: 'Subtitle',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subtitle';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Content Field
                    TextFormField(
                      controller: _contentController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter content';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tags
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              labelText: 'Add Tags',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addTag,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.secondary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Add Tag'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                          deleteIconColor: Colors.red,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Featured Checkbox
                    CheckboxListTile(
                      title: const Text('Featured'),
                      value: _isFeatured,
                      onChanged: (value) {
                        setState(() {
                          _isFeatured = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isLoading 
                            ? null 
                            : () => _submitForm(context, healthTip),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColor.secondary,
                          foregroundColor: Colors.white,
                        ),
                        child: state.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Update Health Tip', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 