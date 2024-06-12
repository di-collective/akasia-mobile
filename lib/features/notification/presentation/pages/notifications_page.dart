import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../domain/entities/notification_entity.dart';
import '../cubit/notifications/notifications_cubit.dart';
import '../widgets/notification_item_widget.dart';
import '../widgets/notification_loading_item_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    final notificationsState =
        BlocProvider.of<NotificationsCubit>(context).state;
    if (notificationsState is! NotificationsLoaded) {
      _getNotifications();
    }
  }

  Future<void> _getNotifications() async {
    await BlocProvider.of<NotificationsCubit>(context).getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefreshNotifications,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.paddingTop,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingHorizontal,
                ),
                child: Text(
                  context.locale.notifications,
                  style: textTheme.headlineSmall.copyWith(
                    color: colorScheme.onSurfaceDim,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: context.width,
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoaded) {
                      final notifications = state.notifications;
                      if (notifications == null || notifications.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: context.height * 0.3,
                            left: context.paddingHorizontal,
                            right: context.paddingHorizontal,
                          ),
                          child: const StateEmptyWidget(),
                        );
                      }

                      return ListView.separated(
                        itemCount: notifications.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          return NotificationItemWidget(
                            notification: notification,
                            onTap: _onTapNotification,
                          );
                        },
                      );
                    } else if (state is NotificationsError) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: context.height * 0.3,
                          left: context.paddingHorizontal,
                          right: context.paddingHorizontal,
                        ),
                        child: StateErrorWidget(
                          description: state.error.message(context),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: 8,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return const NotificationLoadingItemWidget();
                      },
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

  Future<void> _onRefreshNotifications() async {
    try {
      await BlocProvider.of<NotificationsCubit>(context).refreshNotifications();
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }

  void _onTapNotification(NotificationEntity notification) {
    // TODO: Handle notification tap
  }
}
