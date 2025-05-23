import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_plan_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_week_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/workout_day_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/models/day_exercise_model.dart';
import 'package:healtho_gym/features/home/top_tab_view/workout_plan/data/repositories/workout_plan_repository.dart';

part 'workout_plan_state.dart';

class WorkoutPlanCubit extends Cubit<WorkoutPlanState> {
  final WorkoutPlanRepository _repository;
  static const int _pageSize = 10;

  WorkoutPlanCubit(this._repository) : super(WorkoutPlanInitial());

  // الحصول على قائمة خطط التمارين
  Future<void> getWorkoutPlans() async {
    try {
      emit(WorkoutPlanLoading());
      
      final plans = await _repository.getWorkoutPlans(
        limit: _pageSize,
        offset: 0,
      );
      
      final totalCount = await _repository.getWorkoutPlansCount();
      
      emit(WorkoutPlansListLoaded(
        plans: plans,
        hasMoreData: plans.length < totalCount,
        page: 0,
      ));
    } catch (e) {
      print('خطأ في تحميل خطط التمارين: $e');
      emit(WorkoutPlanError('فشل تحميل خطط التمارين'));
    }
  }

  // تحميل المزيد من خطط التمارين
  Future<void> loadMorePlans() async {
    if (state is! WorkoutPlansListLoaded) return;
    
    final currentState = state as WorkoutPlansListLoaded;
    if (!currentState.hasMoreData) return;
    
    try {
      emit(WorkoutPlanLoading());
      
      final nextPage = currentState.page + 1;
      final offset = nextPage * _pageSize;
      
      final plans = await _repository.getWorkoutPlans(
        limit: _pageSize,
        offset: offset,
      );
      
      if (plans.isEmpty) {
        emit(WorkoutPlansListLoaded(
          plans: currentState.plans,
          hasMoreData: false,
          page: currentState.page,
        ));
      } else {
        final totalCount = await _repository.getWorkoutPlansCount();
        final allPlans = [...currentState.plans, ...plans];
        
        emit(WorkoutPlansListLoaded(
          plans: allPlans,
          hasMoreData: allPlans.length < totalCount,
          page: nextPage,
        ));
      }
    } catch (e) {
      print('خطأ في تحميل المزيد من الخطط: $e');
      emit(WorkoutPlanError('فشل تحميل المزيد من خطط التمارين'));
    }
  }

  // تصفية خطط التمارين حسب المعايير
  Future<void> filterPlans({String? goal, String? level, String? duration, int? categoryId, int? exerciseId}) async {
    try {
      emit(WorkoutPlanLoading());
      
      // Parse duration correctly
      int? durationWeeks;
      if (duration != null) {
        // Extract number from string like "4 Weeks"
        final regex = RegExp(r'(\d+)');
        final match = regex.firstMatch(duration);
        if (match != null) {
          durationWeeks = int.tryParse(match.group(1) ?? '');
          print('Parsed duration: $duration to $durationWeeks weeks');
        }
      }
      
      print('Applying filters - Category ID: $categoryId, Level: $level, Duration: $durationWeeks weeks');
      
      final plans = await _repository.getWorkoutPlans(
        limit: _pageSize,
        offset: 0,
        goal: goal,
        level: level,
        duration: durationWeeks,
        categoryId: categoryId,
        exerciseId: exerciseId,
      );
      
      print('Filtered plans count: ${plans.length}');
      
      final totalCount = await _repository.getWorkoutPlansCount();
      
      emit(WorkoutPlansListLoaded(
        plans: plans,
        hasMoreData: plans.length < totalCount,
        page: 0,
      ));
    } catch (e) {
      print('خطأ في تصفية خطط التمارين: $e');
      emit(WorkoutPlanError('فشل تصفية خطط التمارين'));
    }
  }

  // الحصول على تفاصيل خطة تمارين محددة
  Future<void> getWorkoutPlanDetails(int planId) async {
    try {
      emit(WorkoutPlanLoading());
      
      print('بدء تحميل تفاصيل الخطة - planId: $planId');
      final plan = await _repository.getWorkoutPlanDetails(planId);
      print('تم تحميل تفاصيل الخطة بنجاح: ${plan.title}');
      
      print('بدء تحميل أسابيع الخطة');
      final weeks = await _repository.getWorkoutWeeks(planId);
      print('تم تحميل ${weeks.length} أسبوع للخطة');
      
      final result = WorkoutPlanDetailsLoaded(
        plan: plan,
        weeks: weeks,
      );
      
      print('إرسال حالة تفاصيل الخطة المحملة');
      emit(result);
      
      // لا نقوم بتحميل أيام الأسبوع تلقائيًا هنا
      // لمنع التداخل بين الحالات ومشكلة التوقف عند التحميل
      // سنترك التحميل عند النقر على الأسبوع
    } catch (e) {
      print('خطأ في تحميل تفاصيل خطة التمارين: $e');
      emit(WorkoutPlanError('فشل تحميل تفاصيل خطة التمارين: $e'));
    }
  }

  // تحميل أيام أسبوع محدد
  Future<void> loadWeekDays(int weekId) async {
    try {
      emit(WorkoutPlanLoading());
      
      print('بدء البحث عن بيانات الأسبوع - weekId: $weekId');
      // بما أن دالة getWorkoutWeek غير موجودة، سنبحث عن الأسبوع في القائمة الحالية أو نستخدم دالة أخرى
      WorkoutWeekModel week;
      
      // محاولة الحصول على الأسبوع من حالة تفاصيل الخطة إذا كانت متاحة
      if (state is WorkoutPlanDetailsLoaded) {
        final currentState = state as WorkoutPlanDetailsLoaded;
        print('البحث في الأسابيع المحملة مسبقاً، عدد الأسابيع: ${currentState.weeks.length}');
        final foundWeek = currentState.weeks.firstWhere(
          (w) => w.id == weekId,
          orElse: () {
            print('لم يتم العثور على الأسبوع في الحالة، إنشاء أسبوع افتراضي');
            return WorkoutWeekModel(
              id: weekId,
              planId: 0,
              weekNumber: 1,
              title: 'الأسبوع 1',
              description: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          },
        );
        week = foundWeek;
      } else {
        // إذا لم تكن متاحة، نستخدم كائن أسبوع بسيط
        print('حالة تفاصيل الخطة غير موجودة، إنشاء أسبوع افتراضي');
        week = WorkoutWeekModel(
          id: weekId,
          planId: 0,
          weekNumber: 1,
          title: 'الأسبوع 1',
          description: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      
      print('بدء تحميل أيام الأسبوع من Repository - weekId: $weekId');
      final days = await _repository.getWorkoutDays(weekId);
      print('تم تحميل ${days.length} يوم للأسبوع');
      
      final result = WorkoutWeekDaysLoaded(
        week: week,
        days: days,
      );
      
      print('إرسال حالة أيام الأسبوع المحملة');
      emit(result);
      
      // لا نقوم بتحميل تمارين اليوم تلقائيًا هنا
      // لمنع التداخل بين الحالات ومشكلة التوقف عند التحميل
      // سنترك التحميل عند النقر على اليوم
    } catch (e) {
      print('خطأ في تحميل أيام الأسبوع: $e');
      emit(WorkoutPlanError('فشل تحميل أيام الأسبوع: $e'));
    }
  }

  // تحميل تمارين يوم محدد
  Future<void> loadDayExercises(int dayId) async {
    try {
      emit(WorkoutPlanLoading());
      
      // بما أن دالة getWorkoutDay غير موجودة، سنبحث عن اليوم في القائمة الحالية أو نستخدم دالة أخرى
      WorkoutDayModel day;
      
      // محاولة الحصول على اليوم من حالة أيام الأسبوع إذا كانت متاحة
      if (state is WorkoutWeekDaysLoaded) {
        final currentState = state as WorkoutWeekDaysLoaded;
        final foundDay = currentState.days.firstWhere(
          (d) => d.id == dayId,
          orElse: () => WorkoutDayModel(
            id: dayId,
            weekId: 0,
            dayName: 'اليوم 1',
            dayNumber: 1,
            isRestDay: false,
            totalExercises: 0,
            majorExercises: 0,
            minorExercises: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        day = foundDay;
      } else {
        // إذا لم تكن متاحة، نستخدم كائن يوم بسيط
        day = WorkoutDayModel(
          id: dayId,
          weekId: 0,
          dayName: 'اليوم 1',
          dayNumber: 1,
          isRestDay: false,
          totalExercises: 0,
          majorExercises: 0,
          minorExercises: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      
      final exercises = await _repository.getDayExercises(dayId);
      
      emit(WorkoutDayExercisesLoaded(
        day: day,
        exercises: exercises,
      ));
    } catch (e) {
      print('خطأ في تحميل تمارين اليوم: $e');
      emit(WorkoutPlanError('فشل تحميل تمارين اليوم'));
    }
  }

  // تغيير حالة إكمال تمرين
  Future<void> toggleExerciseCompletion(int exerciseId, bool isCompleted) async {
    if (state is! WorkoutDayExercisesLoaded) return;
    
    try {
      final currentState = state as WorkoutDayExercisesLoaded;
      final currentExercises = [...currentState.exercises];
      final index = currentExercises.indexWhere((e) => e.id == exerciseId);
      
      if (index == -1) return;
      
      // تحديث محلي سريع
      currentExercises[index] = currentExercises[index].copyWith(isCompleted: isCompleted);
      
      emit(WorkoutDayExercisesLoaded(
        day: currentState.day,
        exercises: currentExercises,
      ));
      
      // حفظ التغيير في قاعدة البيانات
      await _repository.toggleExerciseCompletion(exerciseId, isCompleted);
    } catch (e) {
      print('خطأ في تغيير حالة إكمال التمرين: $e');
      emit(WorkoutPlanError('فشل تحديث حالة التمرين'));
      
      // إعادة تحميل البيانات في حالة الخطأ
      if (state is WorkoutDayExercisesLoaded) {
        await loadDayExercises((state as WorkoutDayExercisesLoaded).day.id);
      }
    }
  }

  // إضافة خطة إلى المفضلة أو إزالتها
  Future<void> togglePlanFavorite(int planId) async {
    if (state is! WorkoutPlansListLoaded && state is! WorkoutPlanDetailsLoaded) return;
    
    try {
      // جلب حالة المفضلة الحالية
      bool isFavorite = false;
      if (state is WorkoutPlansListLoaded) {
        final currentState = state as WorkoutPlansListLoaded;
        final plans = [...currentState.plans];
        final index = plans.indexWhere((p) => p.id == planId);
        
        if (index != -1) {
          isFavorite = plans[index].isFavorite;
          
          // تحديث محلي في واجهة المستخدم
          plans[index] = plans[index].copyWith(isFavorite: !isFavorite);
          emit(WorkoutPlansListLoaded(
            plans: plans,
            hasMoreData: currentState.hasMoreData,
            page: currentState.page,
          ));
        }
      } else if (state is WorkoutPlanDetailsLoaded) {
        final currentState = state as WorkoutPlanDetailsLoaded;
        isFavorite = currentState.plan.isFavorite;
        
        // تحديث محلي في واجهة المستخدم
        final updatedPlan = currentState.plan.copyWith(isFavorite: !isFavorite);
        emit(WorkoutPlanDetailsLoaded(
          plan: updatedPlan,
          weeks: currentState.weeks,
          selectedWeekIndex: currentState.selectedWeekIndex,
        ));
      }
      
      // محاولة حفظ التغييرات في قاعدة البيانات
      try {
        await _repository.togglePlanFavorite(planId);
        print('تم تحديث حالة المفضلة بنجاح');
      } catch (e) {
        print('حدث خطأ في قاعدة البيانات، ولكن تم تحديث الواجهة: $e');
        // إظهار رسالة للمستخدم أن هذه ميزة تجريبية (إذا كان لديك وصول إلى context)
        // لكننا لا نعيد الحالة لأننا نريد تجربة مستخدم سلسة
      }
    } catch (e) {
      // في حالة حدوث خطأ في الكود نفسه، نقوم بعرض رسالة خطأ
      print('خطأ في تحديث المفضلة: $e');
      emit(WorkoutPlanError('فشل تحديث حالة المفضلة'));
    }
  }
  
  // اختيار أسبوع معين
  void selectWeek(int weekIndex) {
    if (state is! WorkoutPlanDetailsLoaded) return;
    
    final currentState = state as WorkoutPlanDetailsLoaded;
    if (weekIndex < 0 || weekIndex >= currentState.weeks.length) return;
    
    emit(WorkoutPlanDetailsLoaded(
      plan: currentState.plan,
      weeks: currentState.weeks,
      selectedWeekIndex: weekIndex,
    ));
    
    // تحميل أيام الأسبوع المحدد
    loadWeekDays(currentState.weeks[weekIndex].id);
  }
  
  // اختيار يوم معين
  void selectDay(int dayIndex) {
    if (state is! WorkoutWeekDaysLoaded) return;
    
    final currentState = state as WorkoutWeekDaysLoaded;
    if (dayIndex < 0 || dayIndex >= currentState.days.length) return;
    
    emit(WorkoutWeekDaysLoaded(
      week: currentState.week,
      days: currentState.days,
      selectedDayIndex: dayIndex,
    ));
    
    // تحميل تمارين اليوم المحدد
    loadDayExercises(currentState.days[dayIndex].id);
  }
} 