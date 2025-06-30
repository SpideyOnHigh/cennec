import 'dart:math';
import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/theme_cubit/theme_cubit.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../AppNavObserver.dart';
import '../common/widgets/app_localizations.dart';
import '../utils/common_import.dart';

/// It returns the translated string for the given string.
///
/// Args:
///   strTranslate (String): The string to be translated.
///
/// Returns:
///   A String
String getTranslate(String strTranslate) {
  return AppLocalizations.of(NavigatorKey.navigatorKey.currentContext!)!.translate(strTranslate) != null
      ? AppLocalizations.of(NavigatorKey.navigatorKey.currentContext!)!.translate(strTranslate).toString()
      : '-';
}

DateTime convertToDateTime(String dateStr) {
  // Split the string based on the dash '-'
  List<String> parts = dateStr.split('-');

  // Extract month, day, and year from the split string
  int month = int.parse(parts[0]);
  int day = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  // Return the DateTime object
  return DateTime(year, month, day);
}

Color hexToColor(String hexString) {
  // Handle cases where hexString might be null, empty, or invalid
  if (hexString.isEmpty) {
    return Colors.transparent; // Return a default color if invalid
  }

  // Ensure the hexString starts with the correct characters
  hexString = hexString.replaceFirst('#', '');

  if (hexString.length == 6) {
    hexString = 'FF$hexString'; // Add alpha value if not present
  }

  // Parse the string and convert to color
  try {
    return Color(int.parse(hexString, radix: 16));
  } catch (e) {
    // Handle any parsing errors
    return Colors.transparent; // Return a default color in case of error
  }
}

String getCurrentRouteName() {
  late var navStack = AppNavObserver.navStack;
  late var routeSettings = navStack.isEmpty ? null : navStack.last;
  return routeSettings?.name.toString() ?? '';
}

ValueNotifier<int> getCurrentChatUserId = ValueNotifier(0);

/// It takes a string and prints it out in chunks of 800 characters
///
/// Args:
///   text (String): The text to be printed.
///[printWrapped] this function is used to print only in debug mode
void printWrapped(String text) {
  /// 800 is the size of each chunk
  final pattern = RegExp('.{1,800}');
  // ignore: avoid_print
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}
/// It takes a date object and a date format string and returns a formatted date string
///
/// Args:
///   mDate: The date you want to format.
///   mDateFormat (String): The format you want to convert the date to.
///
/// Returns:
///   A string
String formatDate(var mDate, String mDateFormat) {
  try {
    var dateFormatter = DateFormat(mDateFormat);
    String dateFormatted = dateFormatter.format(mDate);
    return dateFormatted;
  } catch (e) {
    return mDate.toString();
  }
}

/// It gets the user data from the shared preferences and returns it as a ModelUser object
///
/// Returns:
///   ModelUser
LoginDetail getUser() {
  String? data = PreferenceHelper.getString(PreferenceHelper.userData);
  if (data != null && data.isNotEmpty) {
    LoginDetail streams = LoginDetail.fromJson(json.decode(data));
    return streams;
  } else {
    return LoginDetail();
  }
}



/// It takes a time object and a time format string as input and returns a formatted time string as
/// output
///
/// Args:
///   mTime: The time you want to format.
///   mTimeFormat (String): The format of the time you want to convert.
///
/// Returns:
///   A string
String formatTime(var mTime, String mTimeFormat) {
  try {
    String selTime = '${mTime.hour}:${mTime.minute}:00';
    String dateFormatted = DateFormat.jm().format(DateFormat(mTimeFormat).parse(selTime));
    return dateFormatted;
  } catch (e) {
    return mTime.toString();
  }
}

/// It returns the context of the navigator key
///
/// Returns:
///   The current context of the navigator key.
BuildContext getNavigatorKeyContext() {
  return NavigatorKey.navigatorKey.currentContext!;
}

/// It takes a DateTime object and returns a string in the format of hh:mm:ss
///
/// Args:
///   mTime: The time you want to convert.
///
/// Returns:
///   A string
String formatTime24H(var mTime) {
  try {
    DateTime now = DateTime.now();
    var pickUpDateTime = DateTime(now.year, now.month, now.day, mTime.hour, mTime.minute);
    String dateFormatted = '';
    if (DateFormat('hh:mm a').format(pickUpDateTime).toLowerCase().contains('pm')) {
      String tmp = DateFormat('hh:mm:ss').format(pickUpDateTime);
      if (int.parse(tmp.split(':').first) == 12) {
        tmp = (int.parse(tmp.split(':').first)).toString() + tmp.replaceAll(tmp.split(':').first, '');
      } else {
        tmp = (int.parse(tmp.split(':').first) + 12).toString() + tmp.replaceAll(tmp.split(':').first, '');
      }
      dateFormatted = tmp;
    } else if (DateFormat('hh:mm a').format(pickUpDateTime).toLowerCase().contains('am') &&
        DateFormat('hh:mm:ss').format(pickUpDateTime).split(':').first == '12') {
      String tmp = DateFormat('hh:mm:ss').format(pickUpDateTime);
      tmp = (int.parse(tmp.split(':').first) - 12).toString() + tmp.replaceAll(tmp.split(':').first, '');
      dateFormatted = tmp;
    } else {
      dateFormatted = DateFormat('hh:mm:ss').format(pickUpDateTime);
    }

    return dateFormatted;
  } catch (e) {
    return mTime.toString();
  }
}

/// It takes a date string and a date format as input and returns a string containing the time duration
/// in hours and minutes
///
/// Args:
///   dateStr (String): The date string that you want to convert.
///   dateFormat (String): The format of the date string you're passing in.
///
/// Returns:
///   A string
String getTimeDurations(String dateStr, String dateFormat) {
  try {
    ///05:25:23
    ///5h - 25 min
    DateTime parseDate = DateFormat(dateFormat).parse(dateStr);
    int hours = int.parse(DateFormat('HH').format(parseDate));
    int minutes = int.parse(DateFormat('mm').format(parseDate));
    String durations = '';

    if (hours > 0) {
      durations = '${hours}h';
    }
    if (minutes > 0) {
      if (hours > 0) {
        durations = '${hours}h  $minutes min';
      } else {
        durations = '$minutes min';
      }
    }
    return durations;
  } catch (e) {
    return '-';
  }
}

/// It takes a date string, converts it to a DateTime object, converts it to UTC, converts it back to
/// local time, and then converts it to a string in the format you want
///
/// Args:
///   dateStr (String): The date string that you want to convert.
///   inPutDateFormat (String): The format of the date you are passing in.
///   outPutDateFormat (String): The format you want to convert the date to.
///
/// Returns:
///   A string
String convertDateFormat(String dateStr, String inPutDateFormat, String outPutDateFormat) {
  try {
    DateTime tempDate = DateFormat(inPutDateFormat).parse(dateStr);
    var date = tempDate.toUtc();
    var dateLocal = date.toLocal();
    String newDate = DateFormat(outPutDateFormat).format(dateLocal);
    return newDate;
  } catch (e) {
    return '-';
  }
}

/// It takes a string and a date format as input and returns a DateTime object
///
/// Args:
///   dateStr (String): The date string that you want to convert to a DateTime object.
///   inPutDateFormat (String): The format of the date string you are passing in.
///
/// Returns:
///   A DateTime object.
DateTime convertStringToDateFormat(String dateStr, String inPutDateFormat) {
  try {
    DateTime newDate = DateFormat(inPutDateFormat).parse(dateStr);
    return newDate;
  } catch (e) {
    return DateTime.now();
  }
}

/// It takes a string in the format of "HH:MM" and returns a TimeOfDay object
///
/// Args:
///   dateStr (String): The string that you want to convert to a TimeOfDay object.
///
/// Returns:
///   A TimeOfDay object
TimeOfDay convertStringToTimeOfDay(String dateStr) {
  try {
    TimeOfDay newDate = TimeOfDay(
      hour: int.parse(dateStr.split(':')[0]),
      minute: int.parse(dateStr.split(':')[1]),
    );

    return newDate;
  } catch (e) {
    return TimeOfDay.now();
  }
}

///[randomImage] This method use to random Image
String randomImage() {
  var rng = Random();
  return "https://picsum.photos/500/500?random=${rng.nextInt(500)}";
}

///[getNetworkMediaUrl] This method use to getNetworkMediaUrl
String getNetworkMediaUrl(String url) {
  return AppUrls.baseUrl + url.replaceFirst('/', '');
}

///[randomNumber] This method use to random Number
int randomNumber({required int maxNum, int? min}) {
  var rng = Random();
  return rng.nextInt(
        maxNum - (min ?? 0),
      ) +
      (min ?? 0);
}

///[setCurrency] This method use to set Currency code in text
String setCurrency(String value) {
  return '\$$value';
}

///[formatDateWithSuffix] This method use to format Date WithSuffix
String formatDateWithSuffix(String dateStr) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate;
    try {
      parseDate = DateFormat('dd-MM-yyyy hh:mm:ss').parse(dateStr);
      var suffix = 'th';
      var digit = parseDate.day % 10;
      if ((digit > 0 && digit < 4) && (parseDate.day < 11 || parseDate.day > 13)) {
        suffix = ['st', 'nd', 'rd'][digit - 1];
      }
      return DateFormat("d'$suffix' MMM yyyy | hh:mm a").format(parseDate);
    } catch (e) {
      parseDate = DateFormat('dd-MM-yyyy').parse(dateStr);
      var suffix = 'th';
      var digit = parseDate.day % 10;
      if ((digit > 0 && digit < 4) && (parseDate.day < 11 || parseDate.day > 13)) {
        suffix = ['st', 'nd', 'rd'][digit - 1];
      }
      return DateFormat("d'$suffix' MMM").format(parseDate);
    }
  } catch (e) {
    return '-';
  }
}

///[formatOnlyDate] This method use to format Date WithSuffix
String formatOnlyDate(String dateStr) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate = DateFormat('dd-MM-yyyy hh:mm:ss').parse(dateStr);
    var suffix = 'th';
    var digit = parseDate.day % 10;
    if ((digit > 0 && digit < 4) && (parseDate.day < 11 || parseDate.day > 13)) {
      suffix = ['st', 'nd', 'rd'][digit - 1];
    }
    return DateFormat("d'$suffix' MMM yyyy").format(parseDate);
  } catch (e) {
    return '-';
  }
}

///[formatOnlyDate] This method use to format Date WithSuffix
String getDateForCustomDisplayFormat(String dateStr, String dateFormat, String displayFormat) {
  try {
    ///19-07-2022 05:25:23
    ///17th Jan 2022 | 02:45 PM
    DateTime parseDate = DateFormat(dateFormat).parse(dateStr);
    return DateFormat(displayFormat).format(parseDate);
  } catch (e) {
    return '-';
  }
}

/// A [checkConnectivity] widget is a widget that describes part of check Connectivity
Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

/// A [getTextStyle] This Method Use to getTextStyle
TextStyle getTextStyle(TextStyle mainTextStyle, double size, FontWeight fontWeight) {
  return mainTextStyle.copyWith(fontSize: size, fontWeight: fontWeight);
}

/// A [getTextStyleFromFont] This Method Use to getTextStyleFromFont
TextStyle getTextStyleFromFont(String fontFamily, double size, Color fontColor, FontWeight fontWeight,
    {TextDecoration? mainTextDecoration, List<Shadow>? shadow}) {
  return TextStyle(shadows: shadow, fontFamily: fontFamily, fontSize: size, fontWeight: fontWeight, color: fontColor, decoration: mainTextDecoration);
}

/// A [getFileImageSize] is a method that calculates MB from bytes
double getFileImageSize(var bytes) {
  final mb = bytes / (1024 * 1024);
  return mb;
}

///[getThemeData] is used to get current theme data
bool getThemeData({bool def = false}) {
  bool result = Hive.box(AppConfig.hiveThemeBox).get(AppConfig.hiveThemeData) ?? def;

  return result;
}

///[setThemeData] is used to set current theme data
void setThemeData(BuildContext context, {bool isDark = false}) {
  isDark ? BlocProvider.of<ThemeCubit>(context).setThemeDataDark() : BlocProvider.of<ThemeCubit>(context).setThemeDataLight();
}

/// A [isInteger] method is a check Integer value
bool isInteger(num value) => value is int || value == value.roundToDouble();

/// A [validatePhone] widget is a widget that describes part of validate Phone number
bool validatePhone(String data) => RegExp(r'(^(?:[+0]9)?[0-9]{8,12}$)').hasMatch(data);

/// A [validateEmail] widget is a widget that describes part of validate Phone number
bool validateEmail(String data) => RegExp(r'^[a-z0-9](\.?[a-z0-9_-]){0,}@[a-z0-9-]+\.([a-z]{2,6}\.)?[a-z]{2,6}$').hasMatch(data);

/// A [validatePassword] widget is a widget that describes part of validate Phone number
bool validatePassword(String data) => RegExp(r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$)').hasMatch(data);

/// A [checkIsValidUrl] widget is a widget that describes part of validate URL
bool checkIsValidUrl(String value) {
  var isValid = false;
  if (RegExp(r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)").hasMatch(value)) {
    isValid = true;
  }
  return isValid;
}

class AlphanumericAndSpecialCharFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Regular expression to allow only alphanumeric and special characters
    final RegExp regex = RegExp(r'[a-zA-Z0-9!@#\$&*~^%+=:;,<>?{}\[\]\-_()]');

    // Filtering the text
    String filteredText = newValue.text
        .split('')
        .where((char) => regex.hasMatch(char))
        .join();

    // Returning the new filtered value
    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}

List<Color> _colors = [
  AppColors.colorInterestRandomColor1,
  AppColors.colorInterestRandomColor2,
  AppColors.colorInterestRandomColor3,
  AppColors.colorInterestRandomColor4,
  AppColors.colorInterestRandomColor5,
];

Color getRandomColor() {
  return _colors[Random().nextInt(_colors.length)];
}
