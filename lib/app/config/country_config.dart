import 'package:country_picker/country_picker.dart';

class CountryConfig {
  static Country indonesia = Country.from(
    json: {
      'e164_cc': "62",
      'iso2_cc': 'ID',
      'e164_sc': 0,
      'geographic': true,
      'level': 1,
      'name': 'Indonesia',
      'example': "812345678",
      'display_name': 'Indonesia (ID) [+62]',
      'full_example_with_plus_sign': '+62812345678',
      'display_name_no_e164_cc': 'Indonesia (ID)',
      'e164_key': '62-ID-0',
    },
  );
}
