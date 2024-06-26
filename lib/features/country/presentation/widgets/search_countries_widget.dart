import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/forms/search_text_form_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../domain/entities/country_entity.dart';
import '../cubit/countries/countries_cubit.dart';

class SearchCountriesWidget extends StatelessWidget {
  final CountryEntity? selectedCountry;

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
  final CountryEntity? selectedCountry;

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
        const SizedBox(
          height: 16,
        ),
        SearchTextFormWidget(
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
