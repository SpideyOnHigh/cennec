import 'package:cennec/modules/search_posts/view/user_send_request_bottomsheet.dart';

import '../../core/utils/common_import.dart';
final List<String> imageUrls = [
  "https://picsum.photos/id/237/400/250",
  "https://picsum.photos/id/238/400/250",
  "https://picsum.photos/id/239/400/250",
];


final PageController _pageController = PageController();
final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

class UserProfileBottomSheet extends StatelessWidget {
  const UserProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildCarousel(),
            const SizedBox(height: 12),
            _buildBio(),
            const SizedBox(height: 16),
            _buildSection("Interests", _buildInterests()),
            const SizedBox(height: 16),
            _buildSection("Recent Posts", _buildRecentPosts()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage("https://yourbaseurl.com/user_profile_images/66e825745ac82.jpg"),
          backgroundColor: AppColors.colorGreyExtraLight,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Test User",
                      style: TextStyle(
                        fontFamily: AppFont.poppins,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                      )),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.colorHyperLink80.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "95%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorHyperLink,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "21 mutual connections",
                style: TextStyle(
                  fontFamily: AppFont.poppins,
                  fontSize: 13,
                  color: AppColors.colorGrey,
                ),
              ),
            ],
          ),
        ),
        _buildFriendIcon(false,context),
      ],
    );
  }

  Widget _buildFriendIcon(bool isFriend, context) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => BottomSheetConnectRequest(
            currentUserImage: 'https://yourbaseurl.com/user_profile_images/123.jpg',
            targetUserImage: 'https://yourbaseurl.com/user_profile_images/456.jpg',
            targetUserName: 'John',
            mutualInterests: ['🎨 Visual Design', '🎬 Independent Film', '📷 Photography'],
            message: '''Hey John!

I want to go on a hike near Seattle at night with expert Hikers for a sense of adventure

Would you be interested?''',
          ),
        );

      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isFriend ? AppColors.colorWhite : AppColors.colorHyperLink,
          border: Border.all(
            color: AppColors.colorHyperLink,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.colorBlackTransparent,
              blurRadius: 2,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(
          isFriend ? Icons.chat_bubble_outline : Icons.person_add_alt_1,
          size: 20,
          color: isFriend ? AppColors.colorHyperLink : Colors.white,
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              onPageChanged: (index) => _currentIndex.value = index,
              itemBuilder: (context, index) {
                return Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
            Positioned(
              bottom: 10,
              child: ValueListenableBuilder<int>(
                valueListenable: _currentIndex,
                builder: (context, current, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imageUrls.length, (index) {
                      final isActive = index == current;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 8 : 6,
                        height: isActive ? 8 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.colorBlack
                              : AppColors.colorBlack.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildBio() {
    return Text(
      "Experienced professional with a demonstrated history of working in the apparel, film, art, music.",
      style: TextStyle(
        fontFamily: AppFont.poppins,
        fontSize: 14,
        color: AppColors.colorBlack1,
        height: 1.4,
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontFamily: AppFont.poppins,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorBlack,
            )),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildInterests() {
    final interests = [
      "🎯 Sports Events & News",
      "🌎 Destinations & Attractions",
      "🎵 Music Production",
      "🎥 Film Making"
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: interests.map((label) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.colorSelectedInterestChip,
            border: Border.all(color: AppColors.colorGreyExtraLight),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFont.poppins,
              fontSize: 13,
              color: AppColors.colorBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentPosts() {
    final posts = [
      "I wanna hike this Friday to get back in shape",
      "Taking time to meditate by the lake this weekend",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Ensures left alignment
      children: posts.map((text) {
        return Container(
          width: double.infinity, // Ensures equal width for all posts
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.colorRoundedBgContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFont.poppins,
              fontSize: 16,
              color: AppColors.colorBlack1,
            ),
          ),
        );
      }).toList(),
    );
  }
}

