import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/depedency_injection.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/forms/search_form_field_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../data/models/country_model.dart';
import '../cubit/countries/countries_cubit.dart';

class SearchCountriesWidget extends StatelessWidget {
  final CountryModel? selectedCountry;

  const SearchCountriesWidget({
    super.key,
    this.selectedCountry,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CountriesCubit>(),
      child: _Body(
        selectedCountry: selectedCountry,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final CountryModel? selectedCountry;

  const _Body({
    this.selectedCountry,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _onGetCountries();
  }

  Future<void> _onGetCountries() async {
    await BlocProvider.of<CountriesCubit>(context).getCountries();
  }

  @override
  void dispose() {
    super.dispose();

    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;

    return Column(
      children: [
        SizedBox(
          height: context.paddingTop,
        ),
        SearchFormFieldWidget(
          controller: _searchTextController,
          hintText: context.locale.startTypingToSearch,
          onChanged: (val) {
            BlocProvider.of<CountriesCubit>(context).getCountries(
              name: val,
              phoneCode: val,
            );
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: BlocBuilder<CountriesCubit, CountriesState>(
            builder: (context, state) {
              if (state is CountriesLoaded) {
                return ListView.builder(
                  itemCount: state.countries.length,
                  itemBuilder: (context, index) {
                    final country = state.countries[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: context.theme.appColorScheme.onSurfaceDim,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            country.name,
                            style: textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Text(
                            '+${country.phoneCode}',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is CountriesError) {
                return StateErrorWidget(
                  description: state.error.message(context),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}