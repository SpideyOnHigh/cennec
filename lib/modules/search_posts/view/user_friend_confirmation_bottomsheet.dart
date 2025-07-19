import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/app_images.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';

import '../../core/api_service/common_service.dart';

class BottomSheetConnectionSent extends StatefulWidget {
  final String currentUserImage;
  final String targetUserImage;
  final String targetUserName;

  const BottomSheetConnectionSent({
    super.key,
    required this.currentUserImage,
    required this.targetUserImage,
    required this.targetUserName,
  });

  @override
  State<BottomSheetConnectionSent> createState() =>
      _BottomSheetConnectionSentState();
}

class _BottomSheetConnectionSentState extends State<BottomSheetConnectionSent> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.75,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Material(
          color: AppColors.colorWhite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Confetti — rains upward from bottom center
              Align(
                alignment: Alignment.bottomCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: -1.5, // upward
                  emissionFrequency: 0.04,
                  numberOfParticles: 50,
                  gravity: 0.1,
                  shouldLoop: false,
                  maxBlastForce: 30,
                  minBlastForce: 10,
                  colors: const [
                    Colors.red,
                    Colors.green,
                    Colors.blue,
                    Colors.orange,
                    Colors.purple,
                    Colors.pink,
                  ],
                ),
              ),

              // Content
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "You’re making moves!",
                      textAlign: TextAlign.center,
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        22,
                        AppColors.colorBlack,
                        FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${widget.targetUserName} has your invite, let’s see where this connection takes you.",
                      textAlign: TextAlign.center,
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        14,
                        AppColors.colorBlack1,
                        FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildAvatars(),
                    const SizedBox(height: 28),
                    CommonButton(
                      text: "Back to my Search",
                      height: 48,
                      backgroundColor: AppColors.colorPrimary,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatars() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSafeAvatar(widget.currentUserImage),
            const SizedBox(width: 16),
            _buildSafeAvatar(widget.targetUserImage),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Image.asset(
            APPImages.icCennecBottom,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSafeAvatar(String? imageUrl) {
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;
    return CircleAvatar(
      radius: 60,
      backgroundColor:
      hasImage ? AppColors.colorGreyExtraLight : AppColors.colorHyperLink,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: !hasImage
          ? Text(
        '?',
        style: getTextStyleFromFont(
          AppFont.poppins,
          20,
          AppColors.colorWhite,
          FontWeight.w600,
        ),
      )
          : null,
    );
  }
}
