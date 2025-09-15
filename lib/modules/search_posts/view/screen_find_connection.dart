import 'package:cennec/modules/search_posts/view/screen_find_connections_details.dart';
import 'package:cennec/modules/search_posts/view/screen_similar_and_interest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/common/widgets/button.dart';
import '../../core/common/widgets/common_underline_textfield.dart';
import '../../core/utils/common_import.dart';

//todo : follow common json, dimens and integrate apis
class ScreenFindConnection extends StatefulWidget {
  const ScreenFindConnection({super.key});

  @override
  State<ScreenFindConnection> createState() => _ScreenFindConnectionState();
}

class _ScreenFindConnectionState extends State<ScreenFindConnection> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<bool> isSearchEnabled = ValueNotifier(false);

  // Static suggestions list
  final List<String> suggestions = [
    "Beach volleyball at Golden Gardens?",
    "Go to SLU Block Party this Friday?",
    "Does anyone want to meetup before the Paddle Board Rave this weekend!?",
    "Can I borrow someone's paddleboard tonight?",
    "Can someone pick me up from the airport? Will pay you!",
    "Grab a coffee at Wunderground Cafe this week?",
    "Has anyone tried Irish Seamoss or Mushroom coffee yet?",
    "Try this Skybowl Cafe in Queen Anne?",
    "Go to Taylor Swift dance night at Neumos?",
    "Surprise me! I am looking for something fun and unique to do in Seattle today?",
    "Looking for a dog sitter for next weekend.",
  ];

  void _checkInput(String value) {
    isSearchEnabled.value = value.trim().isNotEmpty;
  }

  void _onSuggestionTap(String suggestion) {
    searchController.text = suggestion;
    _checkInput(suggestion);
  }

  void _navigateToNextScreen() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenConnectionDetails(
          desc: searchController.text.trim(),
        ),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenSimilarAndInterest(
          searchText: searchController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    isSearchEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: Theme.of(context).brightness,
    ));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: AppColors.colorRoundedBgContainer,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Title
                Text(
                  "Find a cennection to join your next adventure",
                  textAlign: TextAlign.center,
                  style: getTextStyleFromFont(AppFont.poppins, 20, Colors.black, FontWeight.w700),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  "Type your activity, interest, or event to find like-minded companions.",
                  textAlign: TextAlign.center,
                  style: getTextStyleFromFont(AppFont.poppins, 16, Colors.black54, FontWeight.w400),
                ),
                const SizedBox(height: 15),

                // White card container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      CommonUnderlineTextField(
                        controller: searchController,
                        hintText: "Go hiking this Friday",
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
                        onChanged: _checkInput,
                        fontSize: 20,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<bool>(
                        valueListenable: isSearchEnabled,
                        builder: (_, isEnabled, __) {
                          return CommonButton(
                            text: "Search",
                            height: 46,
                            backgroundColor: isEnabled ? AppColors.colorDarkBlue : Colors.grey.shade300,
                            textColor: isEnabled ? Colors.white : Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(12),
                            onTap: isEnabled ? _navigateToNextScreen : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Suggestions section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Suggested prompts",
                    style: getTextStyleFromFont(AppFont.poppins, 16, Colors.black87, FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                getStaggerdView(),
                // Suggestions list
                // GridView.builder(
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2),
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: suggestions.length,
                //   // separatorBuilder: (context, index) => const SizedBox(height: 10),
                //   itemBuilder: (context, index) {
                //     return GestureDetector(
                //       onTap: () => _onSuggestionTap(suggestions[index]),
                //       child: Container(
                //         padding: const EdgeInsets.all(12),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(8),
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black.withOpacity(0.05),
                //               blurRadius: 4,
                //               offset: const Offset(0, 2),
                //             ),
                //           ],
                //         ),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: Text(
                //                 suggestions[index],
                //                 style: getTextStyleFromFont(
                //                     AppFont.poppins, 14, Colors.black87, FontWeight.w400),
                //               ),
                //             ),
                //             Icon(
                //               Icons.arrow_forward_ios,
                //               size: 14,
                //               color: Colors.grey.shade600,
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getStaggerdView() {
    return StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: suggestions.map((e) {
          return GestureDetector(
            onTap: () => _onSuggestionTap(e),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e,
                      style: getTextStyleFromFont(AppFont.poppins, 14, Colors.black87, FontWeight.w400),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          );
        }).toList());
  }
}
