import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/model/model_login.dart';
import '../../connections/model/model_recommendations.dart';
import '../../core/api_service/common_service.dart';
import '../../core/api_service/preference_helper.dart';
import '../../core/common/widgets/button.dart';
import '../../core/common/widgets/common_appbar.dart';
import '../../core/common/widgets/dialog/common_loading_animation.dart';
import '../../core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/app_dimens.dart';
import '../../core/utils/app_font.dart';
import '../../core/utils/app_images.dart';
import '../../core/utils/app_string.dart';
import '../../core/utils/app_urls.dart';
import '../bloc/get_user_profile_pic/get_user_profile_pic_bloc.dart';
import '../bloc/post_profile_picture_bloc/post_profile_picture_bloc.dart';
import '../bloc/set_default_profile_pic/set_default_profile_pic_bloc.dart';
import '../model/profile_picture_model.dart';

class ChangePhotosScreen extends StatefulWidget {
  const ChangePhotosScreen({Key? key}) : super(key: key);

  @override
  State<ChangePhotosScreen> createState() => _ChangePhotosScreenState();
}

class _ChangePhotosScreenState extends State<ChangePhotosScreen> {
  final imageList = ValueNotifier<List<ProfilePictureModel>>([]);
  final isLoadingButton = ValueNotifier<bool>(false);
  final isProfilePicUpdated = ValueNotifier<bool>(false);
  final isApiLoading = ValueNotifier<bool>(false);
  final picker = ImagePicker();

  // Main profile photo (separate from gallery)
  File? mainProfileImage;
  bool isMainProfileUpdated = false;
  LoginDetail userDetail = LoginDetail(); // Add user detail instance

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
    _fetchUserProfilePics();
  }

  void _loadUserDetail() {
    // Load user detail using getUser() method
    userDetail = getUser();
  }

  void _fetchUserProfilePics() {
    // Trigger the API call to fetch user profile pictures
    BlocProvider.of<GetUserProfilePicBloc>(context).add(GetUserProfilePic(url: AppUrls.apiGetProfilePicture));

  }

  void getImages() {
    // Convert ProfileImages to ProfilePictureModel
    List<ProfilePictureModel> profilePictures = [];

    if (userDetail.userData?.profileImages != null) {
      for (var profileImage in userDetail.userData!.profileImages!) {
        profilePictures.add(ProfilePictureModel(
          imageId: profileImage.imageId,
          imageDatabaseUrl: profileImage.imageUrl,
          containsDatabaseImage: true,
          isUpdate: false,
          isDefault: profileImage.isDefault ?? false,
        ));
      }
    }

    // Update the image list
    imageList.value = profilePictures;

    // Set main profile image if default exists
    if (userDetail.userData?.defaultProfilePic != null) {
      // The main profile image will be shown from the default URL
      // No need to set mainProfileImage file here as it's from server
    }
  }

  void uploadImage() {
    Map<String, String> body = {};
    BlocProvider.of<PostProfilePictureBloc>(context).add(
      PostProfilePictureApi(
        url: AppUrls.apiPostImage,
        body: body,
        imageList: imageList.value,
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: CommonButton(
        isLoading: isLoadingButton.value,
        text: "Update",
        backgroundColor: const Color(0xFF2C3E50),
        onTap: uploadImage,
      ),
    );
  }

  Future<void> getImageCameraForVerification({required bool update, int? index, bool isMainProfile = false}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        if (isMainProfile) {
          mainProfileImage = file;
          isMainProfileUpdated = true;
        } else if (update && index != null) {
          imageList.value[index] = imageList.value[index].copyWith(imageFile: file, isUpdate: true);
        } else {
          imageList.value.add(ProfilePictureModel(imageFile: file, isUpdate: true));
        }
        isProfilePicUpdated.value = true;
      });
    }
    Navigator.pop(context);
  }

  Future<void> getImageGalleryForVerification({required bool update, int? index, bool isMainProfile = false}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        if (isMainProfile) {
          mainProfileImage = file;
          isMainProfileUpdated = true;
        } else if (update && index != null) {
          imageList.value[index] = imageList.value[index].copyWith(imageFile: file, isUpdate: true);
        } else {
          imageList.value.add(ProfilePictureModel(imageFile: file, isUpdate: true));
        }
        isProfilePicUpdated.value = true;
      });
    }
    Navigator.pop(context);
  }

  void showPopUpForProfilePic({required bool update, int? index, bool isMainProfile = false}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(Dimens.margin15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select a photo",
                    style: getTextStyleFromFont(AppFont.poppins, Dimens.margin17, Theme.of(context).colorScheme.secondary, FontWeight.w600),
                  ),
                ),
              ),
              const Divider(),
              CupertinoButton(
                child: Text("Open Camera", style: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, CupertinoColors.activeBlue, FontWeight.w600)),
                onPressed: () async => await getImageCameraForVerification(update: update, index: index, isMainProfile: isMainProfile),
              ),
              const Divider(),
              CupertinoButton(
                child: Text("Select from Gallery", style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue, FontWeight.w600)),
                onPressed: () async => await getImageGalleryForVerification(update: update, index: index, isMainProfile: isMainProfile),
              ),
              const Divider(),
              CupertinoButton(
                child: Text("Cancel", style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.systemRed, FontWeight.w600)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainProfileSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "Tap on the images to change",
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin14, Colors.grey[600]!, FontWeight.w400),
        ),
        const SizedBox(height: 30),
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.pink, width: 3),
              ),
              child: ClipOval(
                child: mainProfileImage != null
                    ? Image.file(
                  mainProfileImage!,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                )
                    : userDetail.userData?.defaultProfilePic != null
                    ? Image.network(
                  userDetail.userData!.defaultProfilePic!,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CommonLoadingAnimation());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      APPImages.icDummyProfile,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    );
                  },
                )
                    : Image.asset(
                  APPImages.icDummyProfile,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => showPopUpForProfilePic(update: false, isMainProfile: true),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "Profile Photo",
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, Colors.grey[600]!, FontWeight.w400),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget pageThree() {
    return ValueListenableBuilder<bool>(
      valueListenable: isApiLoading,
      builder: (context, loading, child) {
        if (loading) {
          return const Center(child: CommonLoadingAnimation());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main profile photo section
              _buildMainProfileSection(),

              // Gallery grid
              ValueListenableBuilder<List<ProfilePictureModel>>(
                valueListenable: imageList,
                builder: (context, images, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: images.length + 1,
                      itemBuilder: (context, index) {
                        if (index < images.length) {
                          return GestureDetector(
                            onTap: () => showPopUpForProfilePic(update: true, index: index),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[300],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: images[index].containsDatabaseImage == true && !images[index].isUpdate!
                                        ? Image.network(
                                      images[index].imageDatabaseUrl ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(child: CommonLoadingAnimation());
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          APPImages.icDummyProfile,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        );
                                      },
                                    )
                                        : images[index].imageFile != null
                                        ? Image.file(
                                      images[index].imageFile!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                        : Image.asset(
                                      APPImages.icDummyProfile,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),

                                  // Edit button
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: GestureDetector(
                                      onTap: () => showPopUpForProfilePic(update: true, index: index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Set as default button (only show for non-default, non-updated database images)
                                  if (images[index].isDefault == false &&
                                      images[index].isUpdate == false &&
                                      images[index].containsDatabaseImage == true)
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => _showSetDefaultDialog(index),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "Set as default",
                                            style: getTextStyleFromFont(
                                              AppFont.poppins,
                                              10,
                                              Colors.white,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Default indicator
                                  if (images[index].isDefault == true)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Default",
                                          style: getTextStyleFromFont(
                                            AppFont.poppins,
                                            10,
                                            Colors.white,
                                            FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () => showPopUpForProfilePic(update: false),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[300],
                                border: Border.all(color: Colors.grey[400]!, width: 1),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Update button
              ValueListenableBuilder<bool>(
                valueListenable: isProfilePicUpdated,
                builder: (context, updated, child) {
                  return Visibility(
                    visible: updated || isMainProfileUpdated,
                    child: saveButton(),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonAppBar(title: "Change Photos"),
      body: MultiBlocListener(
        listeners: [
          // BlocListener for fetching user profile pictures
          BlocListener<GetUserProfilePicBloc, GetUserProfilePicState>(
            listener: (context, state) {
              isApiLoading.value = state is GetUserProfilePicLoading;
              if (state is GetUserProfilePicFailure) {
                if (state.errorMessage.generalError!.isNotEmpty) {
                  ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                }
              }
              if (state is GetUserProfilePicResponse) {
                // Clear existing profile images
                userDetail.userData?.profileImages?.clear();

                // Add new profile images from API response
                for (int i = 0; i < (state.modelGetImages.data ?? []).length; i++) {
                  userDetail.userData?.profileImages?.add(ProfileImages(
                    imageId: state.modelGetImages.data?[i].id,
                    imageUrl: state.modelGetImages.data?[i].imagePath,
                    isDefault: state.modelGetImages.data?[i].isDefault,
                  ));

                  // Set default profile picture
                  if (state.modelGetImages.data?[i].isDefault == true) {
                    userDetail.userData?.defaultProfilePic = state.modelGetImages.data?[i].imagePath;
                  }
                }

                // Save updated user detail to preferences
                PreferenceHelper.setString(PreferenceHelper.userData, json.encode(userDetail));

                // Update UI with new images
                getImages();
              }
            },
          ),

          // BlocListener for posting profile pictures
          BlocListener<PostProfilePictureBloc, PostProfilePictureState>(
            listener: (context, state) {
              isLoadingButton.value = state is PostProfilePictureLoading;
              if (state is PostProfilePictureFailure) {
                ToastController.showToast(context, state.error.failed ?? '', false);
              }
              if (state is PostProfilePictureResponse) {
                ToastController.showToast(context, 'Profile pictures updated successfully', true);
                // Refresh the profile pictures after successful upload
                _fetchUserProfilePics();
                setState(() {
                  isProfilePicUpdated.value = false;
                  isMainProfileUpdated = false;
                  mainProfileImage = null;
                });
              }
            },
          ),

          // BlocListener for setting default profile picture
          BlocListener<SetDefaultProfilePicBloc, SetDefaultProfilePicState>(
            listener: (context, state) {
              if (state is SetDefaultProfilePicFailure) {
                ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
              }
              if (state is SetDefaultProfilePicResponse) {
                ToastController.showToast(context, 'Default profile picture updated successfully', true);
                // Refresh the profile pictures after successful default change
                _fetchUserProfilePics();
              }
            },
          ),
        ],
        child: pageThree(),
      ),
    );
  }

  void setDefaultProfilePic(int id) {
    Map<String, dynamic> body = {"image_id": id};
    BlocProvider.of<SetDefaultProfilePicBloc>(context).add(
      SetDefaultProfilePic(
        url: AppUrls.apiSetDefaultProfilePicture,
        body: body,
      ),
    );
  }

  void _showSetDefaultDialog(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoConfirmationDialog(
        title: getTranslate(APPStrings.textSetAsDefaultPic),
        description: getTranslate(APPStrings.textSetAsDefaultPicCnf),
        cancelText: getTranslate(APPStrings.textCancel),
        confirmText: getTranslate(APPStrings.textOk),
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          setDefaultProfilePic(imageList.value[index].imageId ?? 0);
          Navigator.pop(context);
        },
      ),
    );
  }
}