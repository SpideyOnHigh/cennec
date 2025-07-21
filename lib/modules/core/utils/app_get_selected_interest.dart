import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:cennec/modules/search_posts/model/similar_post_model.dart';

class InterestHelper {
  /// Finds mutual interests between logged-in user and post user
  /// Returns a list of common interests
  ///
  /// [loggedInUserInterests] - List of interests of the current user
  /// [postUserInterests] - List of interests of the post/profile user
  static List<String> getMutualInterests(
      List<String> loggedInUserInterests,
      List<String> postUserInterests,
      ) {
    if (loggedInUserInterests.isEmpty || postUserInterests.isEmpty) {
      return [];
    }

    // Convert to sets for efficient intersection
    final loggedInSet = loggedInUserInterests.map((e) => e.toLowerCase().trim()).toSet();
    final postUserSet = postUserInterests.map((e) => e.toLowerCase().trim()).toSet();

    // Find intersection
    final mutualSet = loggedInSet.intersection(postUserSet);

    // Return original casing from logged in user's interests
    return loggedInUserInterests
        .where((interest) => mutualSet.contains(interest.toLowerCase().trim()))
        .toList();
  }

  /// Enhanced version that also handles interest objects with IDs
  /// Useful if interests are stored as objects with id, name, etc.
  static List<ModelInterests> getMutualInterestsFromObjects(
      List<ModelInterests> loggedInUserInterests,
      List<ModelInterests> postUserInterests,
      ) {
    if (loggedInUserInterests.isEmpty || postUserInterests.isEmpty) {
      return [];
    }

    final postUserInterestIds = postUserInterests.map((e) => e.id).toSet();

    return loggedInUserInterests
        .where((interest) => postUserInterestIds.contains(interest.id))
        .toList();
  }
}