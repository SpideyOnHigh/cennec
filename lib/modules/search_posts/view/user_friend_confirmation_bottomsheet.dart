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
        ConfettiController(duration: const Duration(seconds: 4));

    // Delay the confetti start slightly for better visual effect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _confettiController.play();
        }
      });
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
      height: height * 0.70,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Material(
          color: AppColors.colorWhite,
          child: Stack(
            children: [
              // Content - Centered
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height: height * 0.08), // Dynamic top spacing
                      Text(
                        "You're making moves!",
                        textAlign: TextAlign.center,
                        style: getTextStyleFromFont(
                          AppFont.poppins,
                          24,
                          AppColors.colorBlack,
                          FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "${widget.targetUserName} has your invite, let's see where this connection takes you.",
                          textAlign: TextAlign.center,
                          style: getTextStyleFromFont(
                            AppFont.poppins,
                            15,
                            AppColors.colorBlack1,
                            FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.05), // Dynamic spacing
                      _buildAvatars(),
                      SizedBox(height: height * 0.10), // Dynamic spacing
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CommonButton(
                          text: "Back to my Search",
                          height: 52,
                          backgroundColor: AppColors.colorPrimary,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(height: height * 0.04), // Bottom spacing
                    ],
                  ),
                ),
              ),

              // Multiple Confetti widgets for better coverage
              // Top center - falling down
              Positioned(
                top: 50,
                left: MediaQuery.of(context).size.width * 0.5 - 10,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: 1.57, // downward (π/2 radians)
                  emissionFrequency: 0.05,
                  numberOfParticles: 15,
                  gravity: 0.3,
                  shouldLoop: false,
                  maxBlastForce: 20,
                  minBlastForce: 5,
                  blastDirectionality: BlastDirectionality.explosive,
                  createParticlePath: (size) {
                    // Create smaller rectangular confetti
                    final path = Path();
                    path.addRect(Rect.fromLTWH(0, 0, size.width * 0.6, size.height * 0.6));
                    return path;
                  },
                  colors: const [
                    Colors.red,
                    Colors.green,
                    Colors.blue,
                    Colors.orange,
                    Colors.purple,
                    Colors.pink,
                    Colors.yellow,
                  ],
                ),
              ),

              // Left side confetti
              Positioned(
                top: 100,
                left: 50,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: 0.5, // slightly right and down
                  emissionFrequency: 0.03,
                  numberOfParticles: 10,
                  gravity: 0.2,
                  shouldLoop: false,
                  maxBlastForce: 15,
                  minBlastForce: 5,
                  createParticlePath: (size) {
                    // Create smaller rectangular confetti
                    final path = Path();
                    path.addRect(Rect.fromLTWH(0, 0, size.width * 0.6, size.height * 0.6));
                    return path;
                  },
                  blastDirectionality: BlastDirectionality.explosive,
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

              // Right side confetti
              Positioned(
                top: 100,
                right: 50,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: 2.6, // slightly left and down
                  emissionFrequency: 0.03,
                  numberOfParticles: 10,
                  gravity: 0.2,
                  shouldLoop: false,
                  maxBlastForce: 15,
                  minBlastForce: 5,
                  createParticlePath: (size) {
                    // Create smaller rectangular confetti
                    final path = Path();
                    path.addRect(Rect.fromLTWH(0, 0, size.width * 0.6, size.height * 0.6));
                    return path;
                  },
                  blastDirectionality: BlastDirectionality.explosive,
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
            const SizedBox(width: 32), // Increased spacing between avatars
            _buildSafeAvatar(widget.targetUserImage),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8), // Slightly larger padding
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Image.asset(
            APPImages.icCennecBottom,
            width: 28,
            height: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildSafeAvatar(String? imageUrl) {
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;
    return CircleAvatar(
      radius: 65, // Slightly larger avatars
      backgroundColor:
      hasImage ? AppColors.colorGreyExtraLight : AppColors.colorHyperLink,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: !hasImage
          ? Text(
        '?',
        style: getTextStyleFromFont(
          AppFont.poppins,
          22,
          AppColors.colorWhite,
          FontWeight.w600,
        ),
      )
          : null,
    );
  }
}