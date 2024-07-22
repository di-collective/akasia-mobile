import 'package:hive/hive.dart';

import '../../../../core/services/health_service.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/sleep_activity_entity.dart';
import '../../domain/entities/steps_activity_entity.dart';

abstract class HealthLocalDataSource {
  Future<ActivityEntity<List<StepsActivityEntity>>?> getSteps({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<ActivityEntity<List<SleepActivityEntity>>?> getSleep({
    DateTime? startDate,
    DateTime? endDate,
  });
}

class HealthLocalDataSourceImpl implements HealthLocalDataSource {
  final HealthService healthService;
  final Box activityBox;

  HealthLocalDataSourceImpl({
    required this.healthService,
    required this.activityBox,
  });

  final _refreshInterval =
      const Duration(minutes: 1); // TODO: Change this to 30
  final _maxRangeDaysQuery = 30;

  @override
  Future<ActivityEntity<List<StepsActivityEntity>>?> getSteps({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Logger.info('getSteps startDate: $startDate, endDate: $endDate');

      final currentDate = DateTime.now();

      final ActivityEntity<List<StepsActivityEntity>>? currentStepsData =
          activityBox.get('steps');
      Logger.success('getSteps currentStepsData: $currentStepsData');

      DateTime? lastUpdatedAtData = currentStepsData?.updatedAt;
      DateTime? createdAt = currentStepsData?.createdAt;
      List<StepsActivityEntity>? steps = currentStepsData?.data;
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

        if (difference > _refreshInterval) {
          // if last updated is more than _refreshInterval, get new data from health service
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
      activityBox.put(
        'steps',
        ActivityEntity<List<StepsActivityEntity>>(
          updatedAt: currentDate,
          data: steps,
          createdAt: createdAt,
        ),
      );

      List<StepsActivityEntity>? result;
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

      final ActivityEntity<List<SleepActivityEntity>>? currentSleepData =
          activityBox.get('sleep');
      Logger.success('getSleep currentSleepData: $currentSleepData');

      DateTime? lastUpdatedAtData = currentSleepData?.updatedAt;
      DateTime? createdAt = currentSleepData?.createdAt;
      List<SleepActivityEntity>? sleep = currentSleepData?.data;
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

        if (difference > _refreshInterval) {
          // if last updated is more than _refreshInterval, get new data from health service
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
      activityBox.put(
        'sleep',
        ActivityEntity<List<SleepActivityEntity>>(
          updatedAt: currentDate,
          data: sleep,
          createdAt: createdAt,
        ),
      );

      List<SleepActivityEntity>? result;
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
}
