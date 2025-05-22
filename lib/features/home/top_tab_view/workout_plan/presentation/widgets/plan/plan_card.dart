import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_plan_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/widgets/common/info_chip.dart';

class PlanCard extends StatelessWidget {
  final WorkoutPlanModel plan;
  final VoidCallback onPressed;
  final VoidCallback onFavoriteClick;

  const PlanCard({
    Key? key,
    required this.plan,
    required this.onPressed,
    required this.onFavoriteClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image with overlay and badges
              Stack(
                children: [
                  // Cover image with rounded top corners
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      plan.mainImageUrl,
                      width: double.maxFinite,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.maxFinite,
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  // Dark gradient overlay for contrast
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Plan title on image
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      plan.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Level badge in corner
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: TColor.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 3, offset: const Offset(0, 1)),
                        ],
                      ),
                      child: Text(
                        plan.level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Plan details, description and icons
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Short description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        plan.description,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Info row
                    Row(
                      children: [
                        // Duration chip
                        InfoChip(
                          icon: Icons.timer,
                          label: "${plan.durationWeeks} أسبوع",
                          color: TColor.secondary.withOpacity(0.8),
                        ),
                        const SizedBox(width: 8),
                        // Goal chip
                        InfoChip(
                          icon: Icons.fitness_center,
                          label: plan.goal,
                          color: TColor.primary.withOpacity(0.8),
                        ),
                        const Spacer(),
                        // Favorite button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: onFavoriteClick,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            padding: EdgeInsets.zero,
                            iconSize: 22,
                            icon: Icon(
                              plan.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                              color: plan.isFavorite ? TColor.primary : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 