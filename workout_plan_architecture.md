# هيكل MVVM و BLoC لميزة خطط التمارين

## نظرة عامة على الهيكل

سنستخدم نمط MVVM (Model-View-ViewModel) مع BLoC (Business Logic Component) لفصل طبقات التطبيق وجعل الكود أكثر قابلية للاختبار والصيانة. سيتم ربط التطبيق بقاعدة بيانات Supabase.

```
lib/
├── core/
│   ├── api/
│   │   └── supabase_client.dart
│   ├── models/
│   │   ├── result.dart
│   │   └── app_exception.dart
│   └── utils/
│       └── constants.dart
├── features/
│   └── workout_plan/
│       ├── data/
│       │   ├── models/
│       │   │   ├── workout_plan_model.dart
│       │   │   ├── workout_week_model.dart
│       │   │   ├── workout_day_model.dart
│       │   │   └── day_exercise_model.dart
│       │   ├── repositories/
│       │   │   └── workout_plan_repository.dart
│       │   └── datasources/
│       │       └── workout_plan_remote_data_source.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── workout_plan.dart
│       │   │   ├── workout_week.dart
│       │   │   ├── workout_day.dart
│       │   │   └── day_exercise.dart
│       │   ├── repositories/
│       │   │   └── i_workout_plan_repository.dart
│       │   └── usecases/
│       │       ├── get_workout_plans_usecase.dart
│       │       ├── get_workout_plan_details_usecase.dart
│       │       └── toggle_exercise_completion_usecase.dart
│       └── presentation/
│           ├── blocs/
│           │   ├── workout_plans/
│           │   │   ├── workout_plans_bloc.dart
│           │   │   ├── workout_plans_event.dart
│           │   │   └── workout_plans_state.dart
│           │   └── workout_plan_details/
│           │       ├── workout_plan_details_bloc.dart
│           │       ├── workout_plan_details_event.dart
│           │       └── workout_plan_details_state.dart
│           ├── screens/
│           │   ├── workout_plan_screen.dart
│           │   ├── workout_detail_screen.dart
│           │   └── day_exercises_screen.dart
│           └── widgets/
│               ├── workout_plan_card.dart
│               └── day_exercise_row.dart
```

## مكونات الهيكل

### 1. طبقة البيانات (Data Layer)

#### النماذج (Models)
تمثل هياكل البيانات التي تأتي من Supabase:

```dart
// workout_plan_model.dart
class WorkoutPlanModel {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String mainImageUrl;
  final String goal;
  final int durationWeeks;
  final String level;
  final int daysPerWeek;
  final String targetGender;
  final bool isFeatured;
  final bool isFavorite;

  WorkoutPlanModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.mainImageUrl,
    required this.goal,
    required this.durationWeeks,
    required this.level,
    required this.daysPerWeek,
    required this.targetGender,
    required this.isFeatured,
    this.isFavorite = false,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      mainImageUrl: json['main_image_url'],
      goal: json['goal'],
      durationWeeks: json['duration_weeks'],
      level: json['level'],
      daysPerWeek: json['days_per_week'],
      targetGender: json['target_gender'],
      isFeatured: json['is_featured'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}
```

#### مصادر البيانات (Data Sources)

```dart
// workout_plan_remote_data_source.dart
class WorkoutPlanRemoteDataSource {
  final SupabaseClient _supabaseClient;

  WorkoutPlanRemoteDataSource(this._supabaseClient);

  Future<List<WorkoutPlanModel>> getWorkoutPlans() async {
    final response = await _supabaseClient
        .from('workout_plans_with_favorite')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => WorkoutPlanModel.fromJson(json))
        .toList();
  }

  Future<WorkoutPlanModel> getWorkoutPlanDetails(int planId) async {
    final response = await _supabaseClient
        .from('workout_plans_with_favorite')
        .select()
        .eq('id', planId)
        .single();
    
    return WorkoutPlanModel.fromJson(response);
  }
}
```

#### المستودعات (Repositories)

```dart
// workout_plan_repository.dart
class WorkoutPlanRepository implements IWorkoutPlanRepository {
  final WorkoutPlanRemoteDataSource _remoteDataSource;

  WorkoutPlanRepository(this._remoteDataSource);

  @override
  Future<Result<List<WorkoutPlan>>> getWorkoutPlans() async {
    try {
      final models = await _remoteDataSource.getWorkoutPlans();
      final entities = models.map((model) => model.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failure(AppException(message: e.toString()));
    }
  }
}
```

### 2. طبقة المجال (Domain Layer)

#### الكيانات (Entities)

```dart
// workout_plan.dart
class WorkoutPlan {
  final int id;
  final String title;
  final String description;
  final String mainImageUrl;
  final String goal;
  final int durationWeeks;
  final String level;
  final bool isFavorite;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.mainImageUrl,
    required this.goal,
    required this.durationWeeks,
    required this.level,
    this.isFavorite = false,
  });
}
```

#### واجهات المستودعات (Repository Interfaces)

```dart
// i_workout_plan_repository.dart
abstract class IWorkoutPlanRepository {
  Future<Result<List<WorkoutPlan>>> getWorkoutPlans();
  Future<Result<WorkoutPlan>> getWorkoutPlanDetails(int planId);
  Future<Result<List<WorkoutWeek>>> getWorkoutWeeks(int planId);
  Future<Result<List<WorkoutDay>>> getWorkoutDays(int weekId);
  Future<Result<List<DayExercise>>> getDayExercises(int dayId);
  Future<Result<bool>> toggleExerciseCompletion(int dayExerciseId, bool isCompleted);
  Future<Result<bool>> togglePlanFavorite(int planId);
}
```

#### حالات الاستخدام (Use Cases)

```dart
// get_workout_plans_usecase.dart
class GetWorkoutPlansUseCase {
  final IWorkoutPlanRepository _repository;

  GetWorkoutPlansUseCase(this._repository);

  Future<Result<List<WorkoutPlan>>> call() {
    return _repository.getWorkoutPlans();
  }
}
```

### 3. طبقة العرض (Presentation Layer)

#### BLoCs

```dart
// workout_plans_bloc.dart
class WorkoutPlansBloc extends Bloc<WorkoutPlansEvent, WorkoutPlansState> {
  final GetWorkoutPlansUseCase _getWorkoutPlansUseCase;

  WorkoutPlansBloc(this._getWorkoutPlansUseCase) : super(WorkoutPlansInitial()) {
    on<LoadWorkoutPlans>(_onLoadWorkoutPlans);
  }

  Future<void> _onLoadWorkoutPlans(
    LoadWorkoutPlans event,
    Emitter<WorkoutPlansState> emit,
  ) async {
    emit(WorkoutPlansLoading());
    
    final result = await _getWorkoutPlansUseCase();
    
    result.when(
      success: (plans) => emit(WorkoutPlansLoaded(plans)),
      failure: (error) => emit(WorkoutPlansError(error.message)),
    );
  }
}

// workout_plans_event.dart
abstract class WorkoutPlansEvent {}

class LoadWorkoutPlans extends WorkoutPlansEvent {}

// workout_plans_state.dart
abstract class WorkoutPlansState {}

class WorkoutPlansInitial extends WorkoutPlansState {}

class WorkoutPlansLoading extends WorkoutPlansState {}

class WorkoutPlansLoaded extends WorkoutPlansState {
  final List<WorkoutPlan> plans;
  WorkoutPlansLoaded(this.plans);
}

class WorkoutPlansError extends WorkoutPlansState {
  final String message;
  WorkoutPlansError(this.message);
}
```

#### الشاشات (Screens)

```dart
// workout_plan_screen.dart
class WorkoutPlanScreen extends StatelessWidget {
  const WorkoutPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WorkoutPlansBloc>()..add(LoadWorkoutPlans()),
      child: Scaffold(
        body: BlocBuilder<WorkoutPlansBloc, WorkoutPlansState>(
          builder: (context, state) {
            if (state is WorkoutPlansLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkoutPlansLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // UI components...
                    _buildFeaturedPlans(context, state.plans),
                    _buildCategoryPlans(context, state.plans, 'Muscle Building'),
                    _buildCategoryPlans(context, state.plans, 'Gain Strength'),
                  ],
                ),
              );
            } else if (state is WorkoutPlansError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
```

## ربط التطبيق بـ Supabase

### 1. تهيئة Supabase Client

```dart
// supabase_client.dart
class SupabaseClientProvider {
  static late final SupabaseClient _client;
  
  static Future<void> initialize() async {
    _client = SupabaseClient(
      Constants.supabaseUrl,
      Constants.supabaseAnonKey,
    );
  }
  
  static SupabaseClient get client => _client;
}
```

### 2. حقن التبعيات (Dependency Injection)

```dart
// dependency_injection.dart
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => SupabaseClientProvider.client);
  
  // Data sources
  sl.registerLazySingleton(() => WorkoutPlanRemoteDataSource(sl()));
  
  // Repositories
  sl.registerLazySingleton<IWorkoutPlanRepository>(() => WorkoutPlanRepository(sl()));
  
  // Use cases
  sl.registerLazySingleton(() => GetWorkoutPlansUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutPlanDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetWeekDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetDayExercisesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleExerciseCompletionUseCase(sl()));
  sl.registerLazySingleton(() => TogglePlanFavoriteUseCase(sl()));
  
  // BLoCs
  sl.registerFactory(() => WorkoutPlansBloc(sl()));
  sl.registerFactory(() => WorkoutPlanDetailsBloc(sl(), sl()));
  sl.registerFactory(() => WeekDetailsBloc(sl()));
  sl.registerFactory(() => DayExercisesBloc(sl(), sl()));
}
```

## خطوات التنفيذ

1. **إنشاء قاعدة البيانات**: تنفيذ هيكل SQL في Supabase
2. **تنفيذ النماذج والكيانات**: إنشاء الفئات التي تمثل البيانات
3. **تنفيذ مصادر البيانات والمستودعات**: للتعامل مع Supabase API
4. **تنفيذ حالات الاستخدام**: لتغليف منطق الأعمال
5. **تنفيذ BLoCs**: لإدارة حالة التطبيق
6. **تحديث واجهات المستخدم**: لاستخدام BLoCs وعرض البيانات الديناميكية 