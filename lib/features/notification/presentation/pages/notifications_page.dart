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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    _scrollController.addListener(_scrollListener);

    final notificationsState =
        BlocProvider.of<NotificationsCubit>(context).state;
    if (notificationsState is! NotificationsLoaded) {
      _getNotifications();
    }
  }

  Future<void> _getNotifications() async {
    await BlocProvider.of<NotificationsCubit>(context).getNotifications();
  }

  void _scrollListener() {
    // reload state
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              stretch: true,
              backgroundColor: colorScheme.white,
              surfaceTintColor: colorScheme.white,
              iconTheme: IconThemeData(
                color: colorScheme.primary,
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text(
                  context.locale.notifications,
                  style: textTheme.titleMedium.copyWith(
                    color: colorScheme.onSurfaceDim,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                titlePadding: EdgeInsets.only(
                  left: _paddingLeft,
                  bottom: 16,
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: _onRefreshNotifications,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
      ),
    );
  }

  double get _paddingLeft {
    const double minPadding = 16;
    const double maxPadding = 60;
    const double maxOffset = 120;

    if (!_scrollController.hasClients) {
      return minPadding;
    }

    final offset = _scrollController.offset;
    if (offset <= 0) {
      return minPadding;
    } else if (offset >= maxOffset) {
      return maxPadding;
    }

    // Calculate padding linearly
    return minPadding + ((maxPadding - minPadding) * (offset / maxOffset));
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
