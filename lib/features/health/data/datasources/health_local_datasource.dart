import 'package:health/health.dart';
import 'package:hive/hive.dart';

import '../../../../core/services/health_service.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/dynamic_extension.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/heart_rate_activity_entity.dart';
import '../../domain/entities/nutrition_activity_entity.dart';
import '../../domain/entities/sleep_activity_entity.dart';
import '../../domain/entities/steps_activity_entity.dart';
import '../../domain/entities/workout_activity_entity.dart';

abstract class HealthLocalDataSource {
  Future<ActivityEntity<List<StepsActivityEntity>>?> getSteps({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<SleepActivityEntity>>?> getSleep({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<HeartRateActivityEntity>>?> getHeartRate({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<WorkoutActivityEntity>>?> getWorkout({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<NutritionActivityEntity>>?> getNutrition({
    DateTime? startDate,
    DateTime? endDate,
  });
}

class HealthLocalDataSourceImpl implements HealthLocalDataSource {
  final HealthService healthService;
  final Box stepsBox;
  final Box sleepBox;
  final Box heartRateBox;
  final Box workoutBox;
  final Box nutritionBox;

  HealthLocalDataSourceImpl({
    required this.healthService,
    required this.stepsBox,
    required this.sleepBox,
    required this.heartRateBox,
    required this.workoutBox,
    required this.nutritionBox,
  });

  final _maxRangeDaysQuery = 30;
  final String _updatedAtKey = "updated_at";
  final String _createdAtKey = "created_at";
  final String _dataKey = "data";

  Future<void> _updateLocalData<T>({
    required Box box,
    required T? data,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) async {
    try {
      Logger.info(
          '_updateLocalData box: $box, data: $data, updatedAt: $updatedAt, createdAt: $createdAt');

      if (updatedAt != null) {
        // update updatedAt
        await box.put(
          _updatedAtKey,
          updatedAt,
        );
      }

      if (createdAt != null) {
        // update createdAt
        await box.put(
          _createdAtKey,
          createdAt,
        );
      }

      if (data != null) {
        // update data
        await box.put(
          _dataKey,
          data,
        );
      }

      Logger.success('_updateLocalData');
    } catch (error) {
      Logger.error('_updateLocalData error: $error');

      rethrow;
    }
  }

  DateTime? _getLastUpdatedAt({
    required Box box,
  }) {
    try {
      Logger.info('_getLastUpdatedAt box: $box');

      final DateTime? result = box.get(_updatedAtKey);
      Logger.success('_getLastUpdatedAt result: $result');

      return result;
    } catch (error) {
      Logger.error('_getLastUpdatedAt error: $error');

      rethrow;
    }
  }

  DateTime? _getCreatedAt({
    required Box box,
  }) {
    try {
      Logger.info('_getCreatedAt box: $box');

      final DateTime? result = box.get(_createdAtKey);
      Logger.success('_getCreatedAt result: $result');

      return result;
    } catch (error) {
      Logger.error('_getCreatedAt error: $error');

      rethrow;
    }
  }

  List<T>? _getData<T>({
    required Box box,
  }) {
    try {
      Logger.info('_getData box: $box');

      final List? result = box.get(_dataKey);
      Logger.success('_getData result: $result');

      return result?.cast<T>();
    } catch (error) {
      Logger.error('_getData error: $error');

      rethrow;
    }
  }

  @override
  Future<ActivityEntity<List<StepsActivityEntity>>?> getSteps({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Logger.info('getSteps startDate: $startDate, endDate: $endDate');

      final currentDate = DateTime.now();

      DateTime? lastUpdatedAtData = _getLastUpdatedAt(
        box: stepsBox,
      );
      DateTime? createdAt = _getCreatedAt(
        box: stepsBox,
      );
      List<StepsActivityEntity>? steps = _getData<StepsActivityEntity>(
        box: stepsBox,
      );

      if (lastUpdatedAtData == null) {
        // assume user first time access and steps is null
        // get for 30 days
        for (int i = _maxRangeDaysQuery; i >= 0; i--) {
          final nextDate = currentDate.add(Duration(days: -i));
          final newStepsData = await healthService.getTotalStepsInInterval(
            startTime: nextDate.firstHourOfDay,
            endTime: nextDate.lastHourOfDay,
          );

          steps = [
            ...steps ?? [],
            StepsActivityEntity(
              date: nextDate.lastHourOfDay,
              count: newStepsData,
            ),
          ];
        }

        createdAt = currentDate;
      } else {
        final difference = currentDate.difference(lastUpdatedAtData);
        Logger.info('getSteps difference: $difference');

        if (difference > healthService.refreshIntervalDuration) {
          // if last updated is more than refresh interval, get new data from health service
          // get different in days
          final diffInDays = currentDate.day - lastUpdatedAtData.day;
          Logger.info('getSteps diffInDays: $diffInDays');
          if (diffInDays > 0) {
            // if diffInDays is more than 0, get data per day
            for (int i = 0; i <= diffInDays; i++) {
              if (i == 0) {
                final newStepsData =
                    await healthService.getTotalStepsInInterval(
                  startTime: lastUpdatedAtData.firstHourOfDay,
                  endTime: lastUpdatedAtData.lastHourOfDay,
                );

                final newStepsActivity = StepsActivityEntity(
                  date: lastUpdatedAtData.lastHourOfDay,
                  count: newStepsData,
                );

                // replace last data with new data
                steps = steps?.map((e) {
                  if (e.date?.isSameDay(other: lastUpdatedAtData) ?? false) {
                    return newStepsActivity;
                  }

                  return e;
                }).toList();

                continue;
              }

              final nextDate = lastUpdatedAtData.add(Duration(days: i));
              final newStepsData = await healthService.getTotalStepsInInterval(
                startTime: nextDate.firstHourOfDay,
                endTime: nextDate.lastHourOfDay,
              );

              final newStepsActivity = StepsActivityEntity(
                date: nextDate.lastHourOfDay,
                count: newStepsData,
              );

              steps = [
                ...steps ?? [],
                newStepsActivity,
              ];
            }
          } else {
            // if diffInDays is 0, get data from first hour of currentDate to currentDate
            final newStepsData = await healthService.getTotalStepsInInterval(
              startTime: currentDate.firstHourOfDay,
              endTime: currentDate.lastHourOfDay,
            );

            final newStepsActivity = StepsActivityEntity(
              date: currentDate,
              count: newStepsData,
            );

            // replace last data with new data
            steps = steps?.map((e) {
              if (e.date?.isSameDay(other: lastUpdatedAtData) ?? false) {
                return newStepsActivity;
              }

              return e;
            }).toList();
          }
        }
      }
      Logger.success('getSteps steps: $steps');

      // update local database
      await _updateLocalData<List<StepsActivityEntity>?>(
        box: stepsBox,
        data: steps,
        updatedAt: currentDate,
        createdAt: createdAt,
      );

      List<StepsActivityEntity>? result = List.from(steps ?? []);
      // if startDate is not null, filter data from startDate to currentDate
      if (startDate != null) {
        result = steps?.where((e) {
          return e.date?.isAfter(startDate.addDays(-1)) ?? false;
        }).toList();
      }

      // if endDate is not null, filter data until endDate
      if (endDate != null) {
        List<StepsActivityEntity>? filtered;
        if (startDate != null) {
          filtered = result;
        } else {
          filtered = steps;
        }

        result = filtered?.where((e) {
          return e.date?.isBefore(endDate.addDays(1)) ?? false;
        }).toList();
      }
      Logger.success('getSteps result: $result');

      return ActivityEntity(
        data: result?.map((e) {
          return StepsActivityEntity(
            date: e.date,
            count: e.count,
          );
        }).toList(),
        updatedAt: currentDate,
        createdAt: createdAt,
      );
    } catch (error) {
      Logger.error('getSteps error: $error');

      rethrow;
    }
  }

  @override
  Future<ActivityEntity<List<SleepActivityEntity>>?> getSleep({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Logger.info('getSleep startDate: $startDate, endDate: $endDate');

      final currentDate = DateTime.now();

      DateTime? lastUpdatedAtData = _getLastUpdatedAt(
        box: sleepBox,
      );
      DateTime? createdAt = _getCreatedAt(
        box: sleepBox,
      );
      List<SleepActivityEntity>? sleep = _getData<SleepActivityEntity>(
        box: sleepBox,
      );
      if (lastUpdatedAtData == null) {
        // assume user first time access and sleep is null
        // get for 30 days
        for (int i = _maxRangeDaysQuery; i >= 0; i--) {
          final nextDate = currentDate.add(Duration(days: -i));
          final newSleepData = await healthService.getSleepSessions(
            startTime: nextDate.firstHourOfDay,
            endTime: nextDate.lastHourOfDay,
          );

          final List<SleepActivityEntity> newSleepActivity = [];
          for (final data in newSleepData) {
            newSleepActivity.add(
              SleepActivityEntity(
                fromDate: data.dateFrom,
                toDate: data.dateTo,
              ),
            );
          }

          // add new data to last data
          sleep = [
            ...sleep ?? [],
            ...newSleepActivity,
          ];
        }

        createdAt = currentDate;
      } else {
        final difference = currentDate.difference(lastUpdatedAtData);
        Logger.info('getSleep difference: $difference');

        if (difference > healthService.refreshIntervalDuration) {
          // if last updated is more than refresh interval, get new data from health service
          // get different in days
          final diffInDays = currentDate.day - lastUpdatedAtData.day;
          Logger.info('getSleep diffInDays: $diffInDays');
          if (diffInDays > 0) {
            // if diffInDays is more than 0, get data per day
            for (int i = 0; i <= diffInDays; i++) {
              if (i == 0) {
                final newSleepData = await healthService.getSleepSessions(
                  startTime: lastUpdatedAtData,
                  endTime: lastUpdatedAtData.lastHourOfDay,
                );

                final List<SleepActivityEntity> newSleepActivity = [];
                for (final data in newSleepData) {
                  newSleepActivity.add(
                    SleepActivityEntity(
                      fromDate: data.dateFrom,
                      toDate: data.dateTo,
                    ),
                  );
                }

                // add new data to last data
                sleep = [
                  ...sleep ?? [],
                  ...newSleepActivity,
                ];

                continue;
              }

              final nextDate = lastUpdatedAtData.add(Duration(days: i));
              final newSleepData = await healthService.getSleepSessions(
                startTime: nextDate.firstHourOfDay,
                endTime: nextDate.lastHourOfDay,
              );

              final List<SleepActivityEntity> newSleepActivity = [];
              for (final data in newSleepData) {
                newSleepActivity.add(
                  SleepActivityEntity(
                    fromDate: data.dateFrom,
                    toDate: data.dateTo,
                  ),
                );
              }

              sleep = [
                ...sleep ?? [],
                ...newSleepActivity,
              ];
            }
          } else {
            // if diffInDays is 0, get data from first hour of currentDate to currentDate
            final newSleepData = await healthService.getSleepSessions(
              startTime: lastUpdatedAtData,
              endTime: currentDate,
            );

            final List<SleepActivityEntity> newSleepActivity = [];
            for (final data in newSleepData) {
              newSleepActivity.add(
                SleepActivityEntity(
                  fromDate: data.dateFrom,
                  toDate: data.dateTo,
                ),
              );
            }

            // add new data to last data
            sleep = [
              ...sleep ?? [],
              ...newSleepActivity,
            ];
          }
        }
      }

      // update local database
      await _updateLocalData<List<SleepActivityEntity>?>(
        box: sleepBox,
        data: sleep,
        updatedAt: currentDate,
        createdAt: createdAt,
      );

      List<SleepActivityEntity>? result = List.from(sleep ?? []);
      // if startDate is not null, filter data from startDate to currentDate
      if (startDate != null) {
        result = sleep?.where((e) {
          return e.fromDate?.isAfter(startDate.addDays(-1)) ?? false;
        }).toList();
      }

      // if endDate is not null, filter data until endDate
      if (endDate != null) {
        List<SleepActivityEntity>? filtered;
        if (startDate != null) {
          filtered = result;
        } else {
          filtered = sleep;
        }

        result = filtered?.where((e) {
          return e.fromDate?.isBefore(endDate.addDays(1)) ?? false;
        }).toList();
      }

      Logger.success('getSleep result: $result');

      return ActivityEntity(
        data: result?.map((e) {
          return SleepActivityEntity(
            fromDate: e.fromDate,
            toDate: e.toDate,
          );
        }).toList(),
        updatedAt: currentDate,
        createdAt: createdAt,
      );
    } catch (error) {
      Logger.error('getSleep error: $error');

      rethrow;
    }
  }

  @override
  Future<ActivityEntity<List<HeartRateActivityEntity>>?> getHeartRate({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Logger.info('getHeartRate startDate: $startDate, endDate: $endDate');

      final currentDate = DateTime.now();

      DateTime? lastUpdatedAtData = _getLastUpdatedAt(
        box: heartRateBox,
      );
      DateTime? createdAt = _getCreatedAt(
        box: heartRateBox,
      );
      List<HeartRateActivityEntity>? heartRates =
          _getData<HeartRateActivityEntity>(
        box: heartRateBox,
      );
      if (lastUpdatedAtData == null) {
        // assume user first time access and heartRates is null
        // get for 30 days
        for (int i = _maxRangeDaysQuery; i >= 0; i--) {
          final nextDate = currentDate.add(Duration(days: -i));
          final newHeartRateData = await healthService.getHearRate(
            startTime: nextDate.firstHourOfDay,
            endTime: nextDate.lastHourOfDay,
          );

          final List<HeartRateActivityEntity> newHeartRateActivity = [];
          for (final data in newHeartRateData) {
            newHeartRateActivity.add(
              HeartRateActivityEntity(
                fromDate: data.dateFrom,
                toDate: data.dateTo,
                value: data.value.dynamicToInt,
              ),
            );
          }

          // add new data to last data
          heartRates = [
            ...heartRates ?? [],
            ...newHeartRateActivity,
          ];
        }

        createdAt = currentDate;
      } else {
        final difference = currentDate.difference(lastUpdatedAtData);
        Logger.info('getHeartRate difference: $difference');

        if (difference > healthService.refreshIntervalDuration) {
          // if last updated is more than refresh interval, get new data from health service
          // get different in days
          final diffInDays = currentDate.day - lastUpdatedAtData.day;
          Logger.info('getHeartRate diffInDays: $diffInDays');
          if (diffInDays > 0) {
            // if diffInDays is more than 0, get data per day
            for (int i = 0; i <= diffInDays; i++) {
              if (i == 0) {
                // if i is 0, get data from lastUpdatedAtData to last hour of day
                final newHeartRateData = await healthService.getHearRate(
                  startTime: lastUpdatedAtData,
                  endTime: lastUpdatedAtData.lastHourOfDay,
                );

                final List<HeartRateActivityEntity> newHeartRateActivity = [];
                for (final data in newHeartRateData) {
                  newHeartRateActivity.add(
                    HeartRateActivityEntity(
                      fromDate: data.dateFrom,
                      toDate: data.dateTo,
                      value: data.value.dynamicToInt,
                    ),
                  );
                }

                // add new data to last data
                heartRates = [
                  ...heartRates ?? [],
                  ...newHeartRateActivity,
                ];

                continue;
              }

              // get data per day
              final nextDate = lastUpdatedAtData.add(Duration(days: i));
              final newHeartRateData = await healthService.getHearRate(
                startTime: nextDate.firstHourOfDay,
                endTime: nextDate.lastHourOfDay,
              );

              final List<HeartRateActivityEntity> newHeartRateActivity = [];
              for (final data in newHeartRateData) {
                newHeartRateActivity.add(
                  HeartRateActivityEntity(
                    fromDate: data.dateFrom,
                    toDate: data.dateTo,
                    value: data.value.dynamicToInt,
                  ),
                );
              }

              heartRates = [
                ...heartRates ?? [],
                ...newHeartRateActivity,
              ];
            }
          } else {
            // if diffInDays is 0, get data from lastUpdatedAtData to currentDate
            final newHeartRateData = await healthService.getHearRate(
              startTime: lastUpdatedAtData,
              endTime: currentDate,
            );

            final List<HeartRateActivityEntity> newHeartRateActivity = [];
            for (final data in newHeartRateData) {
              newHeartRateActivity.add(
                HeartRateActivityEntity(
                  fromDate: data.dateFrom,
                  toDate: data.dateTo,
                  value: data.value.dynamicToInt,
                ),
              );
            }

            // add new data to last data
            heartRates = [
              ...heartRates ?? [],
              ...newHeartRateActivity,
            ];
          }
        }
      }

      // update local database
      await _updateLocalData<List<HeartRateActivityEntity>?>(
        box: heartRateBox,
        data: heartRates,
        updatedAt: currentDate,
        createdAt: createdAt,
      );

      List<HeartRateActivityEntity>? result = List.from(heartRates ?? []);
      // if startDate is not null, filter data from startDate to currentDate
      if (startDate != null) {
        result = heartRates?.where((e) {
          return e.fromDate?.isAfter(startDate.addDays(-1)) ?? false;
        }).toList();
      }

      // if endDate is not null, filter data until endDate
      if (endDate != null) {
        List<HeartRateActivityEntity>? filtered;
        if (startDate != null) {
          filtered = result;
        } else {
          filtered = heartRates;
        }

        result = filtered?.where((e) {
          return e.fromDate?.isBefore(endDate.addDays(1)) ?? false;
        }).toList();
      }

      Logger.success('getHeartRate result: $result');

      return ActivityEntity(
        data: result?.map((e) {
          return HeartRateActivityEntity(
            fromDate: e.fromDate,
            toDate: e.toDate,
            value: e.value,
          );
        }).toList(),
        updatedAt: currentDate,
        createdAt: createdAt,
      );
    } catch (error) {
      Logger.error('getHeartRate error: $error');

      rethrow;
    }
  }

  @override
  Future<ActivityEntity<List<WorkoutActivityEntity>>?> getWorkout({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Logger.info('getWorkout startDate: $startDate, endDate: $endDate');

      final currentDate = DateTime.now();

      DateTime? lastUpdatedAtData = _getLastUpdatedAt(
        box: workoutBox,
      );
      DateTime? createdAt = _getCreatedAt(
        box: workoutBox,
      );
      List<WorkoutActivityEntity>? workouts = _getData<WorkoutActivityEntity>(
        box: workoutBox,
      );
      if (lastUpdatedAtData == null) {
        // assume user first time access and workouts is null
        // get for 30 days
        for (int i = _maxRangeDaysQuery; i >= 0; i--) {
          final nextDate = currentDate.add(Duration(days: -i));
          final newWorkoutData = await healthService.getWorkout(
            startTime: nextDate.firstHourOfDay,
            endTime: nextDate.lastHourOfDay,
          );

          final List<WorkoutActivityEntity> newWorkoutActivity = [];
          for (final data in newWorkoutData) {
            // get workout type
            final value = data.value;
            String? type;
            if (value is WorkoutHealthValue) {
              type = value.workoutActivityType.name;
            }

            newWorkoutActivity.add(
              WorkoutActivityEntity(
                fromDate: data.dateFrom,
                toDate: data.dateTo,
                type: type,
              ),
            );
          }

          // add new data to last data
          workouts = [
            ...workouts ?? [],
            ...newWorkoutActivity,
          ];
        }

        createdAt = currentDate;
      } else {
        final difference = currentDate.difference(lastUpdatedAtData);
        Logger.info('getWorkout difference: $difference');

        if (difference > healthService.refreshIntervalDuration) {
          // if last updated is more than refresh interval, get new data from health service
          // get different in days
          final diffInDays = currentDate.day - lastUpdatedAtData.day;
          Logger.info('getWorkout diffInDays: $diffInDays');
          if (diffInDays > 0) {
            // if diffInDays is more than 0, get data per day
            for (int i = 0; i <= diffInDays; i++) {
              if (i == 0) {
                // if i is 0, get data from lastUpdatedAtData to last hour of day
                final newWorkoutData = await healthService.getWorkout(
                  startTime: lastUpdatedAtData,
                  endTime: lastUpdatedAtData.lastHourOfDay,
                );

                final List<WorkoutActivityEntity> newWorkoutActivity = [];
                for (final data in newWorkoutData) {
                  // get workout type
                  final value = data.value;
                  String? type;
                  if (value is WorkoutHealthValue) {
                    type = value.workoutActivityType.name;
                  }

                  newWorkoutActivity.add(
                    WorkoutActivityEntity(
                      fromDate: data.dateFrom,
                      toDate: data.dateTo,
                      type: type,
                    ),
                  );
                }

                // add new data to last data
                workouts = [
                  ...workouts ?? [],
                  ...newWorkoutActivity,
                ];

                continue;
              }

              // get data per day
              final nextDate = lastUpdatedAtData.add(Duration(days: i));
              final newWorkoutData = await healthService.getWorkout(
                startTime: nextDate.firstHourOfDay,
                endTime: nextDate.lastHourOfDay,
              );

              final List<WorkoutActivityEntity> newWorkoutActivity = [];
              for (final data in newWorkoutData) {
                // get workout type
                final value = data.value;
                String? type;
                if (value is WorkoutHealthValue) {
                  type = value.workoutActivityType.name;
                }

                newWorkoutActivity.add(
                  WorkoutActivityEntity(
                    fromDate: data.dateFrom,
                    toDate: data.dateTo,
                    type: type,
                  ),
                );
              }

              workouts = [
                ...workouts ?? [],
                ...newWorkoutActivity,
              ];
            }
          } else {
            // if diffInDays is 0, get data from lastUpdatedAtData to currentDate
            final newWorkoutData = await healthService.getWorkout(
              startTime: lastUpdatedAtData,
              endTime: currentDate,
            );

            final List<WorkoutActivityEntity> newWorkoutActivity = [];
            for (final data in newWorkoutData) {
              // get workout type
              final value = data.value;
              String? type;
              if (value is WorkoutHealthValue) {
                type = value.workoutActivityType.name;
              }

              newWorkoutActivity.add(
                WorkoutActivityEntity(
                  fromDate: data.dateFrom,
                  toDate: data.dateTo,
                  type: type,
                ),
              );
            }

            // add new data to last data
            workouts = [
              ...workouts ?? [],
              ...newWorkoutActivity,
            ];
          }
        }
      }

      // update local database
      await _updateLocalData<List<WorkoutActivityEntity>?>(
        box: workoutBox,
        data: workouts,
        updatedAt: currentDate,
        createdAt: createdAt,
      );

      List<WorkoutActivityEntity>? result = List.from(workouts ?? []);

      // if startDate is not null, filter data from startDate to currentDate
      if (startDate != null) {
        result = workouts?.where((e) {
          return e.fromDate?.isAfter(startDate.addDays(-1)) ?? false;
        }).toList();
      }

      // if endDate is not null, filter data until endDate
      if (endDate != null) {
        List<WorkoutActivityEntity>? filtered;
        if (startDate != null) {
          filtered = result;
        } else {
          filtered = workouts;
        }

        result = filtered?.where((e) {
          return e.fromDate?.isBefore(endDate.addDays(1)) ?? false;
        }).toList();
      }

      Logger.success('getWorkout result: $result');

      return ActivityEntity(
        data: result?.map((e) {
          return WorkoutActivityEntity(
            fromDate: e.fromDate,
            toDate: e.toDate,
            type: e.type,
          );
        }).toList(),
        updatedAt: currentDate,
        createdAt: createdAt,
      );
    } catch (error) {
      Logger.error('getWorkout error: $error');

      rethrow;
    }
  }

  @override
  Future<ActivityEntity<List<NutritionActivityEntity>>?> getNutrition({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Logger.info('getNutrition startDate: $startDate, endDate: $endDate');

      final currentDate = DateTime.now();

      DateTime? lastUpdatedAtData = _getLastUpdatedAt(
        box: nutritionBox,
      );
      DateTime? createdAt = _getCreatedAt(
        box: nutritionBox,
      );
      List<NutritionActivityEntity>? nutrition =
          _getData<NutritionActivityEntity>(
        box: nutritionBox,
      );
      if (lastUpdatedAtData == null) {
        // assume user first time access and nutrition is null
        // get for 30 days
        for (int i = _maxRangeDaysQuery; i >= 0; i--) {
          final nextDate = currentDate.add(Duration(days: -i));
          final newNutritionData = await healthService.getNutrition(
            startTime: nextDate.firstHourOfDay,
            endTime: nextDate.lastHourOfDay,
          );

          final List<NutritionActivityEntity> newNutritionActivity = [];
          for (final data in newNutritionData) {
            newNutritionActivity.add(
              NutritionActivityEntity(
                fromDate: data.dateFrom,
                toDate: data.dateTo,
                value: data.value.dynamicToDouble,
              ),
            );
          }

          // add new data to last data
          nutrition = [
            ...nutrition ?? [],
            ...newNutritionActivity,
          ];
        }

        createdAt = currentDate;
      } else {
        final difference = currentDate.difference(lastUpdatedAtData);
        Logger.info('getNutrition difference: $difference');

        if (difference > healthService.refreshIntervalDuration) {
          // if last updated is more than refresh interval, get new data from health service
          // get different in days
          final diffInDays = currentDate.day - lastUpdatedAtData.day;
          Logger.info('getNutrition diffInDays: $diffInDays');
          if (diffInDays > 0) {
            // if diffInDays is more than 0, get data per day
            for (int i = 0; i <= diffInDays; i++) {
              if (i == 0) {
                // if i is 0, get data from lastUpdatedAtData to last hour of day
                final newNutritionData = await healthService.getNutrition(
                  startTime: lastUpdatedAtData,
                  endTime: lastUpdatedAtData.lastHourOfDay,
                );

                final List<NutritionActivityEntity> newNutritionActivity = [];
                for (final data in newNutritionData) {
                  newNutritionActivity.add(
                    NutritionActivityEntity(
                      fromDate: data.dateFrom,
                      toDate: data.dateTo,
                      value: data.value.dynamicToDouble,
                    ),
                  );
                }

                // add new data to last data
                nutrition = [
                  ...nutrition ?? [],
                  ...newNutritionActivity,
                ];

                continue;
              }

              // get data per day
              final nextDate = lastUpdatedAtData.add(Duration(days: i));
              final newNutritionData = await healthService.getNutrition(
                startTime: nextDate.firstHourOfDay,
                endTime: nextDate.lastHourOfDay,
              );

              final List<NutritionActivityEntity> newNutritionActivity = [];
              for (final data in newNutritionData) {
                newNutritionActivity.add(
                  NutritionActivityEntity(
                    fromDate: data.dateFrom,
                    toDate: data.dateTo,
                    value: data.value.dynamicToDouble,
                  ),
                );
              }

              nutrition = [
                ...nutrition ?? [],
                ...newNutritionActivity,
              ];
            }
          } else {
            // if diffInDays is 0, get data from lastUpdatedAtData to currentDate
            final newNutritionData = await healthService.getNutrition(
              startTime: lastUpdatedAtData,
              endTime: currentDate.lastHourOfDay,
            );

            final List<NutritionActivityEntity> newNutritionActivity = [];
            for (final data in newNutritionData) {
              newNutritionActivity.add(
                NutritionActivityEntity(
                  fromDate: data.dateFrom,
                  toDate: data.dateTo,
                  value: data.value.dynamicToDouble,
                ),
              );
            }

            // add new data to last data
            nutrition = [
              ...nutrition ?? [],
              ...newNutritionActivity,
            ];
          }
        }
      }

      // update local database
      await _updateLocalData<List<NutritionActivityEntity>?>(
        box: nutritionBox,
        data: nutrition,
        updatedAt: currentDate,
        createdAt: createdAt,
      );

      List<NutritionActivityEntity>? result = List.from(nutrition ?? []);

      // if startDate is not null, filter data from startDate to currentDate
      if (startDate != null) {
        result = nutrition?.where((e) {
          return e.fromDate?.isAfter(startDate.addDays(-1)) ?? false;
        }).toList();
      }

      // if endDate is not null, filter data until endDate
      if (endDate != null) {
        List<NutritionActivityEntity>? filtered;
        if (startDate != null) {
          filtered = result;
        } else {
          filtered = nutrition;
        }

        result = filtered?.where((e) {
          return e.fromDate?.isBefore(endDate.addDays(1)) ?? false;
        }).toList();
      }

      Logger.success('getNutrition result: $result');

      return ActivityEntity(
        data: result?.map((e) {
          return NutritionActivityEntity(
            fromDate: e.fromDate,
            toDate: e.toDate,
            value: e.value,
          );
        }).toList(),
        updatedAt: currentDate,
        createdAt: createdAt,
      );
    } catch (error) {
      Logger.error('getNutrition error: $error');

      rethrow;
    }
  }
}
