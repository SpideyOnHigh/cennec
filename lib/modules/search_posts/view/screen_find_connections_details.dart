import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

import '../../core/common/widgets/button.dart';
import '../../core/common/widgets/common_connection_textfield.dart';

class ScreenConnectionDetails extends StatefulWidget {
  const ScreenConnectionDetails({super.key});

  @override
  State<ScreenConnectionDetails> createState() => _ScreenConnectionDetailsState();
}

class _ScreenConnectionDetailsState extends State<ScreenConnectionDetails> {
  final TextEditingController activityController = TextEditingController(text: "Hiking");
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: "this Friday");
  final TextEditingController whoController = TextEditingController();
  final TextEditingController whatController = TextEditingController();

  final ValueNotifier<bool> isSearchEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    locationController.addListener(_updateSearchButtonState);
  }

  void _updateSearchButtonState() {
    isSearchEnabled.value = locationController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    activityController.dispose();
    locationController.dispose();
    dateController.dispose();
    whoController.dispose();
    whatController.dispose();
    isSearchEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  "Add more details to find ideal connections.",
                  textAlign: TextAlign.center,
                  style: getTextStyleFromFont(AppFont.poppins, 18, Colors.black, FontWeight.w600),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Activity
                      CustomConnectionTextField(
                        controller: activityController,
                        fontSize: 16,
                        hintText: "What do you want to do",
                      ),
                      const SizedBox(height: 20),

                      // Location
                      CustomConnectionTextField(
                        controller: locationController,
                        fontSize: 16,
                        hintText: "Where do you want to go",
                        onChanged: (_) => _updateSearchButtonState(),
                      ),
                      const SizedBox(height: 20),

                      // Date
                      CustomConnectionTextField(
                        controller: dateController,
                        fontSize: 16,
                        hintText: "When do you want to go",
                      ),
                      const SizedBox(height: 20),

                      // Who to meet (placeholder-style)
                      CustomConnectionTextField(
                        controller: whoController,
                        fontSize: 16,
                        hintText: "Who do you want to meet",
                      ),
                      const SizedBox(height: 20),

                      // What to discuss (placeholder-style)
                      CustomConnectionTextField(
                        controller: whatController,
                        fontSize: 16,
                        hintText: "What do you want to discuss",
                      ),
                      const SizedBox(height: 24),

                      // Search Button
                      ValueListenableBuilder<bool>(
                        valueListenable: isSearchEnabled,
                        builder: (_, isEnabled, __) {
                          return CommonButton(
                            text: "Search",
                            height: 48,

                            backgroundColor: isEnabled ? AppColors.colorDarkBlue : Colors.grey.shade300,
                            textColor: isEnabled ? Colors.white : Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(12),
                            onTap: isEnabled ? () {
                              Navigator.pushNamed(context, AppRoutes.routeScreenSimilarAndInterest);

                            } : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
