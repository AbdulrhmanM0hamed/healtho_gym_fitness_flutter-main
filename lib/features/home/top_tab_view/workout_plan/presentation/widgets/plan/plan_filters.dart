import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class PlanFilters extends StatelessWidget {
  final String selectedCategory;
  final String selectedLevel;
  final String selectedDuration;
  final List<String> categories;
  final List<String> levels;
  final List<String> durations;
  final Function(String?) onCategoryChanged;
  final Function(String?) onLevelChanged;
  final Function(String?) onDurationChanged;

  const PlanFilters({
    Key? key,
    required this.selectedCategory,
    required this.selectedLevel,
    required this.selectedDuration,
    required this.categories,
    required this.levels,
    required this.durations,
    required this.onCategoryChanged,
    required this.onLevelChanged,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: TColor.secondary.withOpacity(0.1),
      child: Column(
        children: [
          // Category Filter
   
          const SizedBox(height: 8),

          // Level Filter
          DropdownButtonFormField<String>(
            value: selectedLevel,
            decoration: InputDecoration(
              labelText: 'المستوى',
              labelStyle: TextStyle(color: TColor.primaryText),
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              alignLabelWithHint: true,
            ),
            isExpanded: true,
            alignment: AlignmentDirectional.centerEnd,
            items: levels.map((String level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(
                  level,
                ),
              );
            }).toList(),
            onChanged: onLevelChanged,
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: Colors.white,
          ),
          const SizedBox(height: 8),

          // Duration Filter
          DropdownButtonFormField<String>(
            value: selectedDuration,
            decoration: InputDecoration(
              labelText: 'المدة',
              labelStyle: TextStyle(color: TColor.primaryText),
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              alignLabelWithHint: true,
            ),
            isExpanded: true,
            alignment: AlignmentDirectional.centerEnd,
            items: durations.map((String duration) {
              return DropdownMenuItem<String>(
                value: duration,
                child: Text(
                  duration,
                ),
              );
            }).toList(),
            onChanged: onDurationChanged,
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
