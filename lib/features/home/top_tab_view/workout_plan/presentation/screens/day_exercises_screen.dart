import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/data/models/exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/exercises/workout_exercises_screen.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/services/exercise_progress_service.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/presentation/viewmodels/workout_plan_cubit.dart';

class DayExercisesScreen extends StatefulWidget {
  final int dayId;

  const DayExercisesScreen({
    Key? key,
    required this.dayId,
  }) : super(key: key);

  @override
  State<DayExercisesScreen> createState() => _DayExercisesScreenState();
}

class _DayExercisesScreenState extends State<DayExercisesScreen> {
  // قائمة التمارين المكتملة
  Map<int, bool> _completedExercises = {};
  // قائمة أوزان التمارين
  Map<int, double> _exerciseWeights = {};
  // قائمة الأوزان السابقة للتمارين
  Map<int, double> _previousExerciseWeights = {};

  @override
  void initState() {
    super.initState();
    _loadExerciseProgress();
  }

  // تحميل تقدم التمارين (الإكمال والأوزان) من SharedPreferences
  Future<void> _loadExerciseProgress() async {
    final completedExercises = await ExerciseProgressService.getCompletedExercises();

    setState(() {
      for (final exerciseId in completedExercises) {
        _completedExercises[exerciseId] = true;
      }
    });

    // سيتم تحميل الأوزان عند عرض كل تمرين على حدة
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutPlanCubit>()..loadDayExercises(widget.dayId),
      child: BlocBuilder<WorkoutPlanCubit, WorkoutPlanState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "assets/img/back.png",
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              backgroundColor: TColor.secondary,
              centerTitle: false,
              title: const Text(
                "Day Exercises",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Tooltip(
                    message: "Reset All",
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          _showResetConfirmationDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.refresh, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  // تبديل حالة إكمال التمرين (مكتمل/غير مكتمل)
  Future<void> _toggleExerciseCompletion(int exerciseId) async {
    final isCompleted = _completedExercises[exerciseId] ?? false;
    
    if (isCompleted) {
      await ExerciseProgressService.markExerciseIncomplete(exerciseId);
    } else {
      await ExerciseProgressService.markExerciseCompleted(exerciseId);
    }
    
    setState(() {
      _completedExercises[exerciseId] = !isCompleted;
    });
  }
  
  // تحميل وزن التمرين من SharedPreferences
  Future<void> _loadExerciseWeight(int exerciseId) async {
    if (_exerciseWeights.containsKey(exerciseId)) return;
    
    final weight = await ExerciseProgressService.getExerciseWeight(exerciseId);
    final previousWeight = await ExerciseProgressService.getPreviousExerciseWeight(exerciseId);
    
    setState(() {
      _exerciseWeights[exerciseId] = weight;
      _previousExerciseWeights[exerciseId] = previousWeight;
    });
  }
  
  // عرض مربع حوار لإدخال وزن جديد
  void _showWeightInputDialog(int exerciseId, String exerciseName) {
    final currentWeight = _exerciseWeights[exerciseId] ?? 0.0;
    final weightController = TextEditingController(
      text: currentWeight > 0 ? currentWeight.toString() : '',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Record Weight for $exerciseName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'Enter weight in kg',
                border: OutlineInputBorder(),
              ),
            ),
            if (_previousExerciseWeights[exerciseId] != null && _previousExerciseWeights[exerciseId]! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Previous weight: ${_previousExerciseWeights[exerciseId]!.toStringAsFixed(1)} kg',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              final weightText = weightController.text.trim();
              if (weightText.isNotEmpty) {
                final weight = double.tryParse(weightText) ?? 0.0;
                if (weight > 0) {
                  _saveExerciseWeight(exerciseId, weight);
                }
              }
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
  
  // حفظ وزن جديد للتمرين
  Future<void> _saveExerciseWeight(int exerciseId, double weight) async {
    await ExerciseProgressService.saveExerciseWeight(exerciseId, weight);
    
    setState(() {
      // حفظ الوزن السابق قبل تحديث الوزن الحالي
      if (_exerciseWeights.containsKey(exerciseId) && _exerciseWeights[exerciseId]! > 0) {
        _previousExerciseWeights[exerciseId] = _exerciseWeights[exerciseId]!;
      }
      _exerciseWeights[exerciseId] = weight;
    });
  }
  
  // عرض مربع حوار تأكيد إعادة تعيين جميع التمارين
  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Progress'),
        content: const Text(
          'Are you sure you want to reset all exercise completion status? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _resetAllExercises();
              Navigator.pop(context);
            },
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }
  
  // إعادة تعيين جميع التمارين
  Future<void> _resetAllExercises() async {
    await ExerciseProgressService.resetAllCompletedExercises();
    
    setState(() {
      _completedExercises.clear();
    });
  }
  
  Widget _buildBody(WorkoutPlanState state) {
    if (state is WorkoutPlanLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WorkoutPlanError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('العودة'),
            ),
          ],
        ),
      );
    } else if (state is WorkoutDayExercisesLoaded) {
      if (state.exercises.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'لا توجد تمارين متاحة لهذا اليوم.\nالرجاء المحاولة مرة أخرى لاحقاً.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('العودة'),
              ),
            ],
          ),
        );
      }
      
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        itemBuilder: (context, index) {
          final dayExercise = state.exercises[index];
          
          // تحميل وزن التمرين (إذا كان موجودًا)
          _loadExerciseWeight(dayExercise.exerciseId);
          
          // التحقق مما إذا كان التمرين مكتملًا محليًا
          final isCompleted = _completedExercises[dayExercise.exerciseId] ?? false;
          final currentWeight = _exerciseWeights[dayExercise.exerciseId] ?? 0.0;
          final previousWeight = _previousExerciseWeights[dayExercise.exerciseId] ?? 0.0;
          
          // Convert DayExerciseModel to Exercise model
          final exercise = Exercise(
            id: dayExercise.exerciseId,
            categoryId: 0, // Not needed for display
            title: dayExercise.exerciseName,
            description: '', // Will be loaded in detail screen
            mainImageUrl: dayExercise.exerciseImage,
            level: 1, // Not needed for display
            isFavorite: false, // Not needed for display
            createdAt: dayExercise.createdAt,
            updatedAt: dayExercise.updatedAt,
            imageUrl: [], // Will be loaded in detail screen
          );

          return Card(
            elevation: 7,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: isCompleted ? Colors.green[50] : Colors.white.withOpacity(0.96),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: dayExercise.exerciseImage.isNotEmpty
                        ? NetworkImage(dayExercise.exerciseImage)
                        : const AssetImage("assets/img/placeholder-exercise.png") as ImageProvider,
                  ),
                  title: Text(
                    dayExercise.exerciseName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green[700] : Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _InfoIconText(icon: Icons.fitness_center, text: "${dayExercise.sets} Sets"),
                            _InfoIconText(icon: Icons.repeat, text: "${dayExercise.reps} Reps"),
                            _InfoIconText(icon: Icons.timer, text: "${dayExercise.restTime}s Rest"),
                          ],
                        ),
                        if (currentWeight > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                _InfoIconText(
                                  icon: Icons.fitness_center,
                                  text: "Current: ${currentWeight.toStringAsFixed(1)} kg",
                                ),
                                if (previousWeight > 0 && previousWeight != currentWeight)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "(prev: ${previousWeight.toStringAsFixed(1)} kg)",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: currentWeight > previousWeight
                                              ? Colors.green[700]
                                              : Colors.red[700],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      if (currentWeight > previousWeight)
                                        Icon(Icons.arrow_upward, size: 12, color: Colors.green[700])
                                      else if (currentWeight < previousWeight)
                                        Icon(Icons.arrow_downward, size: 12, color: Colors.red[700]),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _toggleExerciseCompletion(dayExercise.exerciseId);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (isCompleted)
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : Icons.radio_button_unchecked,
                            color: isCompleted ? Colors.white : Colors.grey[700],
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutExercisesDetailScreen(
                                exercise: exercise,
                                onToggleFavorite: () {
                                  _toggleExerciseCompletion(dayExercise.exerciseId);
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Details",
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // زر تسجيل الوزن
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showWeightInputDialog(dayExercise.exerciseId, dayExercise.exerciseName),
                          icon: const Icon(Icons.fitness_center, size: 16),
                          label: Text(currentWeight > 0 ? "Update Weight" : "Record Weight"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[700],
                            side: BorderSide(color: Colors.blue[700]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: state.exercises.length,
      );
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('جاري تحميل تمارين اليوم...'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('العودة'),
          ),
        ],
      ),
    );
  }
}

// Widget مساعد لعرض معلومات التمرين مع أيقونة
class _InfoIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoIconText({Key? key, required this.icon, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}