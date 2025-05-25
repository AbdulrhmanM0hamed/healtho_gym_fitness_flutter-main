import 'package:bloc/bloc.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_plan_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_week_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_workout_day_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/models/dashboard_day_exercise_model.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/data/repositories/dashboard_workout_plan_repository.dart';
import 'package:healtho_gym/dashboard/features/workout_plan/presentation/viewmodels/dashboard_workout_plan_state.dart';

/// كيوبت إدارة خطط التمرين في لوحة التحكم
class DashboardWorkoutPlanCubit extends Cubit<DashboardWorkoutPlanState> {
  final DashboardWorkoutPlanRepository _repository;

  DashboardWorkoutPlanCubit(this._repository) : super(DashboardWorkoutPlanInitial());

  /// الحصول على جميع خطط التمرين
  Future<void> getAllWorkoutPlans() async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final plans = await _repository.getAllWorkoutPlans();
      emit(DashboardWorkoutPlansLoaded(plans));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في الحصول على خطط التمرين: $e'));
    }
  }

  /// الحصول على خطة تمرين محددة
  Future<void> getWorkoutPlanById(int planId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final plan = await _repository.getWorkoutPlanById(planId);
      emit(DashboardWorkoutPlanLoaded(plan));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في الحصول على خطة التمرين: $e'));
    }
  }

  /// إضافة خطة تمرين جديدة
  Future<void> addWorkoutPlan(DashboardWorkoutPlanModel plan) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.addWorkoutPlan(plan);
      
      // إعادة تحميل جميع الخطط مباشرة بعد الإضافة
      final plans = await _repository.getAllWorkoutPlans();
      
      // إرسال حالة النجاح مع البيانات المحدثة
      emit(DashboardWorkoutPlansLoaded(plans));
      
      // إشعار المستخدم بالنجاح
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تمت إضافة خطة التمرين بنجاح',
        actionType: 'add',
        entityType: 'plan',
      ));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في إضافة خطة التمرين: $e'));
    }
  }

  /// تحديث خطة تمرين موجودة
  Future<void> updateWorkoutPlan(DashboardWorkoutPlanModel plan) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.updateWorkoutPlan(plan);
      
      // إعادة تحميل جميع الخطط مباشرة بعد التحديث
      final plans = await _repository.getAllWorkoutPlans();
      
      // إرسال حالة النجاح مع البيانات المحدثة
      emit(DashboardWorkoutPlansLoaded(plans));
      
      // إشعار المستخدم بالنجاح
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تم تحديث خطة التمرين بنجاح',
        actionType: 'update',
        entityType: 'plan',
      ));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في تحديث خطة التمرين: $e'));
    }
  }

  /// حذف خطة تمرين
  Future<void> deleteWorkoutPlan(int planId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final success = await _repository.deleteWorkoutPlan(planId);
      
      if (success) {
        // إعادة تحميل جميع الخطط مباشرة بعد الحذف
        final plans = await _repository.getAllWorkoutPlans();
        
        // إرسال حالة النجاح مع البيانات المحدثة
        emit(DashboardWorkoutPlansLoaded(plans));
        
        // إشعار المستخدم بالنجاح
        emit(const DashboardWorkoutPlanActionSuccess(
          message: 'تم حذف خطة التمرين بنجاح',
          actionType: 'delete',
          entityType: 'plan',
        ));
      } else {
        emit(const DashboardWorkoutPlanError('فشل في حذف خطة التمرين'));
      }
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في حذف خطة التمرين: $e'));
    }
  }

  /// الحصول على أسابيع خطة تمرين محددة
  Future<void> getWeeksForPlan(int planId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final weeks = await _repository.getWeeksForPlan(planId);
      emit(DashboardWorkoutWeeksLoaded(planId: planId, weeks: weeks));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في الحصول على أسابيع الخطة: $e'));
    }
  }

  /// إضافة أسبوع جديد لخطة تمرين
  Future<void> addWeekToPlan(DashboardWorkoutWeekModel week) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.addWeekToPlan(week);
      
      // إعادة تحميل الأسابيع مباشرة بعد الإضافة
      final weeks = await _repository.getWeeksForPlan(week.planId!);
      
      // إرسال حالة النجاح مع البيانات المحدثة
      emit(DashboardWorkoutWeeksLoaded(planId: week.planId!, weeks: weeks));
      
      // إشعار المستخدم بالنجاح
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تمت إضافة الأسبوع بنجاح',
        actionType: 'add',
        entityType: 'week',
      ));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في إضافة الأسبوع للخطة: $e'));
    }
  }

  /// تحديث أسبوع موجود
  Future<void> updateWeek(DashboardWorkoutWeekModel week) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.updateWeek(week);
      
      // إعادة تحميل الأسابيع مباشرة بعد التحديث
      final weeks = await _repository.getWeeksForPlan(week.planId!);
      
      // إرسال حالة النجاح مع البيانات المحدثة
      emit(DashboardWorkoutWeeksLoaded(planId: week.planId!, weeks: weeks));
      
      // إشعار المستخدم بالنجاح
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تم تحديث الأسبوع بنجاح',
        actionType: 'update',
        entityType: 'week',
      ));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في تحديث الأسبوع: $e'));
    }
  }

  /// حذف أسبوع
  Future<void> deleteWeek(int weekId, int planId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final success = await _repository.deleteWeek(weekId);
      
      if (success) {
        // إعادة تحميل الأسابيع مباشرة بعد الحذف
        final weeks = await _repository.getWeeksForPlan(planId);
        
        // إرسال حالة النجاح مع البيانات المحدثة
        emit(DashboardWorkoutWeeksLoaded(planId: planId, weeks: weeks));
        
        // إشعار المستخدم بالنجاح
        emit(const DashboardWorkoutPlanActionSuccess(
          message: 'تم حذف الأسبوع بنجاح',
          actionType: 'delete',
          entityType: 'week',
        ));
      } else {
        emit(const DashboardWorkoutPlanError('فشل في حذف الأسبوع'));
      }
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في حذف الأسبوع: $e'));
    }
  }

  /// الحصول على أيام أسبوع محدد
  Future<void> getDaysForWeek(int weekId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final days = await _repository.getDaysForWeek(weekId);
      emit(DashboardWorkoutDaysLoaded(weekId: weekId, days: days));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في الحصول على أيام الأسبوع: $e'));
    }
  }

  /// إضافة يوم جديد لأسبوع
  Future<void> addDayToWeek(DashboardWorkoutDayModel day) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.addDayToWeek(day);
      
      // إعادة تحميل الأيام مباشرة بعد الإضافة
      final days = await _repository.getDaysForWeek(day.weekId!);
      
      // إرسال حالة النجاح مع البيانات المحدثة
      emit(DashboardWorkoutDaysLoaded(weekId: day.weekId!, days: days));
      
      // إشعار المستخدم بالنجاح
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تمت إضافة اليوم بنجاح',
        actionType: 'add',
        entityType: 'day',
      ));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في إضافة اليوم للأسبوع: $e'));
    }
  }

  /// تحديث يوم موجود
  Future<void> updateDay(DashboardWorkoutDayModel day) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.updateDay(day);
      
      // إعادة تحميل الأيام مباشرة بعد التحديث
      final days = await _repository.getDaysForWeek(day.weekId!);
      
      // إرسال حالة النجاح مع البيانات المحدثة
      emit(DashboardWorkoutDaysLoaded(weekId: day.weekId!, days: days));
      
      // إشعار المستخدم بالنجاح
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تم تحديث اليوم بنجاح',
        actionType: 'update',
        entityType: 'day',
      ));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في تحديث اليوم: $e'));
    }
  }

  /// حذف يوم
  Future<void> deleteDay(int dayId, int weekId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final success = await _repository.deleteDay(dayId);
      
      if (success) {
        // إعادة تحميل الأيام مباشرة بعد الحذف
        final days = await _repository.getDaysForWeek(weekId);
        
        // إرسال حالة النجاح مع البيانات المحدثة
        emit(DashboardWorkoutDaysLoaded(weekId: weekId, days: days));
        
        // إشعار المستخدم بالنجاح
        emit(const DashboardWorkoutPlanActionSuccess(
          message: 'تم حذف اليوم بنجاح',
          actionType: 'delete',
          entityType: 'day',
        ));
      } else {
        emit(const DashboardWorkoutPlanError('فشل في حذف اليوم'));
      }
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في حذف اليوم: $e'));
    }
  }

  /// الحصول على تمارين يوم محدد
  Future<void> getExercisesForDay(int dayId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final exercises = await _repository.getExercisesForDay(dayId);
      emit(DashboardDayExercisesLoaded(dayId: dayId, exercises: exercises));
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في الحصول على تمارين اليوم: $e'));
    }
  }

  /// إضافة تمرين جديد ليوم
  Future<void> addExerciseToDay(DashboardDayExerciseModel exercise) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.addExerciseToDay(exercise);
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تمت إضافة التمرين بنجاح',
        actionType: 'add',
        entityType: 'exercise',
      ));
      getExercisesForDay(exercise.dayId!); // إعادة تحميل التمارين بعد الإضافة
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في إضافة التمرين لليوم: $e'));
    }
  }

  /// تحديث تمرين موجود
  Future<void> updateExercise(DashboardDayExerciseModel exercise) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      await _repository.updateExercise(exercise);
      emit(const DashboardWorkoutPlanActionSuccess(
        message: 'تم تحديث التمرين بنجاح',
        actionType: 'update',
        entityType: 'exercise',
      ));
      getExercisesForDay(exercise.dayId!); // إعادة تحميل التمارين بعد التحديث
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في تحديث التمرين: $e'));
    }
  }

  /// حذف تمرين
  Future<void> deleteExercise(int exerciseId, int dayId) async {
    try {
      emit(DashboardWorkoutPlanLoading());
      final success = await _repository.deleteExercise(exerciseId);
      if (success) {
        emit(const DashboardWorkoutPlanActionSuccess(
          message: 'تم حذف التمرين بنجاح',
          actionType: 'delete',
          entityType: 'exercise',
        ));
        getExercisesForDay(dayId); // إعادة تحميل التمارين بعد الحذف
      } else {
        emit(const DashboardWorkoutPlanError('فشل في حذف التمرين'));
      }
    } catch (e) {
      emit(DashboardWorkoutPlanError('فشل في حذف التمرين: $e'));
    }
  }
}
