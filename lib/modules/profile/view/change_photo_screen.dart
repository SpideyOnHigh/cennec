import 'package:cennec/modules/core/common/widgets/button.dart';

import '../../core/utils/common_import.dart';

class ChangePhotosScreen extends StatefulWidget {
  const ChangePhotosScreen({super.key});

  @override
  State<ChangePhotosScreen> createState() => _ChangePhotosScreenState();
}

class _ChangePhotosScreenState extends State<ChangePhotosScreen> {
  List<String> imageList = [
    "https://picsum.photos/200/300",
    "https://picsum.photos/200/300",
    "https://picsum.photos/200/300"
  ];

  String profilePhotoUrl = 'https://picsum.photos/200/300';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Photos", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            const Text(
              "Tap on the images to change",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ProfilePhotoWidget(
              imageUrl: profilePhotoUrl,
              onEditTap: () {
                // TODO: open picker
              },
            ),
            const SizedBox(height: 8),
            const Text(
              "Profile Photo",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            GalleryGrid(
              images: imageList,
              onImageTap: (index) {
                // TODO: image edit logic
              },
              onAddTap: () {
                // TODO: add image logic
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CommonButton(
                text: "Update",
                onTap: (){},
              )
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePhotoWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onEditTap;

  const ProfilePhotoWidget({
    super.key,
    required this.imageUrl,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100)
              ),
              child: Image.network("https://picsum.photos/200/300", fit: BoxFit.cover,)),
        ),
        GestureDetector(
          onTap: onEditTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pinkAccent,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.edit, size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class GalleryGrid extends StatelessWidget {
  final List<String> images;
  final void Function(int) onImageTap;
  final VoidCallback onAddTap;

  const GalleryGrid({
    super.key,
    required this.images,
    required this.onImageTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length + 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index < images.length) {
          return GestureDetector(
            onTap: () => onImageTap(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: onAddTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: const Icon(Icons.add, size: 40, color: Colors.grey),
            ),
          );
        }
      },
    );
  }
}
