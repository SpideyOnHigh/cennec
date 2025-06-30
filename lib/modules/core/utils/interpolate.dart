///[InterpolateString] This class use to Interpolate String via any string
/// It takes a string and a map of variables and replaces all instances of the variables with their
/// values
class InterpolateString {
  static String interpolate(String string, List params) {
    String result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceFirst('{#}', params[i - 1]);
    }
    return result;
  }
}
