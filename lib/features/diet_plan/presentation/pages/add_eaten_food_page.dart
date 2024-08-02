import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:health/health.dart';

import '../../../../core/services/health_service.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/meal_type_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/dialogs/bottom_sheet_info.dart';
import '../../../../core/ui/widget/forms/search_text_form_widget.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../domain/entities/food_entity.dart';
import '../cubit/search_foods/search_foods_cubit.dart';
import '../widgets/food_option_item_widget.dart';
import '../widgets/input_food_quantity_widget.dart';

class AddEatenFoodPageParams {
  final MealType mealType;
  final DateTime date;

  const AddEatenFoodPageParams({
    required this.mealType,
    required this.date,
  });
}

class AddEatenFoodPage extends StatelessWidget {
  final AddEatenFoodPageParams? params;

  const AddEatenFoodPage({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchFoodsCubit>(),
      child: _Body(
        params: params,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final AddEatenFoodPageParams? params;

  const _Body({
    required this.params,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  AddEatenFoodPageParams? params;

  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    params = widget.params;
  }

  @override
  void dispose() {
    super.dispose();

    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    if (params == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                params!.mealType.name.toCapitalize(),
                style: textTheme.titleMedium.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                params!.date.formatDate(
                      format: 'dd MMMM yyyy',
                    ) ??
                    '',
                style: textTheme.bodyMedium.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          backgroundColor: colorScheme.white,
          surfaceTintColor: colorScheme.white,
          iconTheme: IconThemeData(
            color: colorScheme.primary,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              SearchTextFormWidget(
                context: context,
                controller: _searchTextController,
                hintText: context.locale.enterFoodName,
                onClear: _onSearch,
                onChangedText: _onSearch,
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<SearchFoodsCubit, SearchFoodsState>(
                builder: (context, state) {
                  if (state is SearchFoodsInitial) {
                    return const SizedBox.shrink();
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.locale.results,
                            style: textTheme.titleMedium.copyWith(
                              color: colorScheme.onSurfaceDim,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          BlocBuilder<SearchFoodsCubit, SearchFoodsState>(
                            builder: (context, state) {
                              if (state is SearchFoodsLoaded) {
                                if (state.foods.isEmpty) {
                                  return StateEmptyWidget(
                                    paddingTop: context.height * 0.2,
                                    width: context.width,
                                  );
                                }
                                return ListView.builder(
                                  itemCount: state.foods.length,
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final meal = state.foods[index];

                                    return FoodOptionItemWidget(
                                      food: meal,
                                      onFood: () => _onMeal(
                                        meal: meal,
                                      ),
                                    );
                                  },
                                );
                              } else if (state is SearchFoodsError) {
                                return StateErrorWidget(
                                  paddingTop: context.height * 0.2,
                                  width: context.width,
                                  description: state.error.message(context),
                                );
                              }

                              return ListView.separated(
                                itemCount: 8,
                                primary: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 16,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return ShimmerLoading.rectangular(
                                    height: 38,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSearch() async {
    try {
      // close keyboard
      context.closeKeyboard;

      // check if search text is empty
      if (_searchTextController.text.isEmpty) {
        BlocProvider.of<SearchFoodsCubit>(context).init();
      } else {
        // search
        await BlocProvider.of<SearchFoodsCubit>(context).searchProducts(
          mealType: params!.mealType,
          searchText: _searchTextController.text,
        );
      }

      // update state
      setState(() {});
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }

  Future<void> _onMeal({
    required FoodEntity meal,
  }) async {
    try {
      // show confirmation dialog
      final isSuccess = await sl<BottomSheetInfo>().showMaterialModal(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: context.viewInsetsBottom,
            ),
            child: InputFoodQuantityWidget(
              food: meal,
              onCancel: () {
                Navigator.of(context).pop(false);
              },
              onAdd: (quanity, unit) async {
                final isSuccess = await _onAddMeal(
                  meal: meal,
                  quantity: quanity,
                  quantityUnit: unit,
                );
                if (isSuccess != true) {
                  return;
                }

                // close dialog
                Navigator.of(context).pop(isSuccess);
              },
            ),
          );
        },
      );
      if (isSuccess != true) {
        return;
      }

      // close this page
      context.pop();
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }

  Future<bool?> _onAddMeal({
    required FoodEntity meal,
    required String quantity,
    required String quantityUnit,
  }) async {
    try {
      if (params == null) {
        return false;
      }

      // show loading
      context.showFullScreenLoading();

      final quantityValue = int.tryParse(quantity);
      if (quantityValue == null) {
        throw 'Quantity must be a number';
      }

      final mealType = params!.mealType;
      final date = params!.date;

      // add meal to health service
      await sl<HealthService>().addMeal(
        startTime: mealType.startTime(
          date: date,
        ),
        endTime: mealType.endTime(
          date: date,
        ),
        mealType: mealType,
        meal: meal,
        quantity: quantityValue,
      );

      // show success message
      context.showSuccessToast(
        message: context.locale.successAddFood,
      );

      return true;
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );

      return false;
    } finally {
      // hide loading
      context.hideFullScreenLoading;
    }
  }
}
