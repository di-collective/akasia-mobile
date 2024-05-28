import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  ///The country phone code
  final String phoneCode;

  ///The country code, ISO (alpha-2)
  final String countryCode;
  final int e164Sc;
  final bool geographic;
  final int level;

  ///The country name in English
  final String name;

  ///An example of a telephone number without the phone code
  final String example;

  ///Country name (country code) [phone code]
  final String displayName;

  ///An example of a telephone number with the phone code and plus sign
  final String? fullExampleWithPlusSign;

  ///Country name (country code)

  final String displayNameNoCountryCode;
  final String e164Key;

  const CountryEntity({
    required this.phoneCode,
    required this.countryCode,
    required this.e164Sc,
    required this.geographic,
    required this.level,
    required this.name,
    required this.example,
    required this.displayName,
    required this.displayNameNoCountryCode,
    required this.e164Key,
    this.fullExampleWithPlusSign,
  });

  @override
  List<Object?> get props => [
        phoneCode,
        countryCode,
        e164Sc,
        geographic,
        level,
        name,
        example,
        displayName,
        displayNameNoCountryCode,
        e164Key,
        fullExampleWithPlusSign,
      ];
}
