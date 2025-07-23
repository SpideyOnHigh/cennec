import 'package:cennec/modules/search_posts/view/screen_find_connections_details.dart';
import 'package:cennec/modules/search_posts/view/screen_similar_and_interest.dart';
import 'package:flutter/services.dart';

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

  void _checkInput(String value) {
    isSearchEnabled.value = value.trim().isNotEmpty;
  }

  @override
  void dispose() {
    searchController.dispose();
    isSearchEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: AppColors.colorRoundedBgContainer,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    "Find a cennection to join your next adventure",
                    textAlign: TextAlign.center,
                    style: getTextStyleFromFont(AppFont.poppins, 22, Colors.black, FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    "Type your activity, interest, or event to find like-minded companions.",
                    textAlign: TextAlign.center,
                    style: getTextStyleFromFont(AppFont.poppins, 18, Colors.black54, FontWeight.w400),
                  ),
                  const SizedBox(height: 30),

                  // White card container
                  Container(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
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
                          fontSize: 22,
                        ),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<bool>(
                          valueListenable: isSearchEnabled,
                          builder: (_, isEnabled, __) {
                            return CommonButton(
                              text: "Search",
                              height: 48,
                              backgroundColor: isEnabled ? AppColors.colorDarkBlue : Colors.grey.shade300,
                              textColor: isEnabled ? Colors.white : Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(12),
                              onTap: isEnabled
                                  ? () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => ScreenSimilarAndInterest(
                                      //       searchText: searchController.text.trim(),
                                      //     ),
                                      //   ),
                                      // );
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
                                      // discussionTopic: whatController.text.trim(),
                                      // location: locationController.text.trim(),
                                      // meetAt: dateController.text.trim(),
                                      // meetWith: whoController.text.trim(),
                                      // activity: activityController.text.trim(),
                                      // searchText: searchController.text.trim(),
                                    ),
                                  ),
                                );
                                      // Navigator.pushNamed(context, AppRoutes.routeSearchNewConnectionDetails);
                                    }
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
