import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.phoneCode,
    required super.countryCode,
    required super.e164Sc,
    required super.geographic,
    required super.level,
    required super.name,
    required super.example,
    required super.displayName,
    required super.fullExampleWithPlusSign,
    required super.displayNameNoCountryCode,
    required super.e164Key,
  });

  factory CountryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CountryModel(
      phoneCode: json['e164_cc'],
      countryCode: json['iso2_cc'],
      e164Sc: json['e164_sc'],
      geographic: json['geographic'],
      level: json['level'],
      name: json['name'],
      example: json['example'],
      displayName: json['display_name'],
      fullExampleWithPlusSign: json['full_example_with_plus_sign'],
      displayNameNoCountryCode: json['display_name_no_e164_cc'],
      e164Key: json['e164_key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'e164_cc': phoneCode,
      'iso2_cc': countryCode,
      'e164_sc': e164Sc,
      'geographic': geographic,
      'level': level,
      'name': name,
      'example': example,
      'display_name': displayName,
      'full_example_with_plus_sign': fullExampleWithPlusSign,
      'display_name_no_e164_cc': displayNameNoCountryCode,
      'e164_key': e164Key,
    };
  }
}
