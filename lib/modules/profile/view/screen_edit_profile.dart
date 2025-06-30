import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/connections/model/model_fetch_user_detail.dart';
import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/common/widgets/base_date_picker.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import 'package:cennec/modules/core/common/widgets/drink_dropdown.dart';
import 'package:cennec/modules/core/common/widgets/gender_dropdown.dart';
import 'package:cennec/modules/core/common/widgets/smoke_dropdown.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_constant.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/profile/bloc/get_user_profile_pref/get_user_profile_pref_bloc.dart';
import 'package:cennec/modules/profile/bloc/get_user_que_ans/get_user_que_ans_bloc.dart';
import 'package:cennec/modules/profile/bloc/post_profile_picture_bloc/post_profile_picture_bloc.dart';
import 'package:cennec/modules/profile/bloc/post_user_que_ans/post_user_que_ans_bloc.dart';
import 'package:cennec/modules/profile/bloc/set_default_profile_pic/set_default_profile_pic_bloc.dart';
import 'package:cennec/modules/profile/bloc/update_user_profile/update_user_profile_bloc.dart';
import 'package:cennec/modules/profile/model/model_question_answer.dart';
import 'package:cennec/modules/profile/model/profile_picture_model.dart';
import 'package:cennec/modules/profile/widgets/custom_progress_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/utils/common_import.dart';
import '../bloc/get_user_profile_pic/get_user_profile_pic_bloc.dart';

class ScreenEditProfile extends StatefulWidget {
  const ScreenEditProfile({super.key});

  @override
  State<ScreenEditProfile> createState() => _ScreenEditProfileState();
}

class _ScreenEditProfileState extends State<ScreenEditProfile> {
  // bool isEditing = false;
  // String _answer = '';

  List<bool> isEditing = [];
  List<QuestionsWithAnswers> queAndAns = [];
  List<TextEditingController> qaControllers = [];
  // TextEditingController _controller = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController locationController = TextEditingController(text: "");
  TextEditingController bioController = TextEditingController();
  ValueNotifier<int> pageIndex = ValueNotifier(0);
  ValueNotifier<bool> isLoadingAnimation = ValueNotifier(false);
  ValueNotifier<bool> isApiLoading = ValueNotifier(false);
  ValueNotifier<bool> isLoadingButton = ValueNotifier(false);
  ValueNotifier<bool> isProfilePicUpdated = ValueNotifier(false);
  ValueNotifier<ModelQuestionAnswers> modelQuestionAnswers = ValueNotifier(ModelQuestionAnswers());
  ValueNotifier<File>? imageFile = ValueNotifier(File(""));
  List<ProfileImages> listImages = [];
  LoginDetail userDetail = getUser();
  String latitudeSelected = '';
  String longitudeSelected = '';

  @override
  void initState() {
    listImages = getUser().userData?.profileImages ?? [];
    getUserPref();
    getImages();
    // imageList.add(ProfilePictureModel(containsDatabaseImage: true, imageDatabaseUrl: "https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg"));
    super.initState();
  }

  Widget navigationWithLogo() {
    return InkWell(
      // onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context, true),
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(Dimens.margin50)),
                  height: Dimens.margin45,
                  width: Dimens.margin45,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Image.asset(APPImages.icBack),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin20,
          Theme.of(context).colorScheme.onPrimary,
          FontWeight.w600,
        ),
      ),
    );
  }

  Widget userDisplayName() {
    return Column(
      children: [
        textTitle("Display name"),
        const SizedBox(
          height: Dimens.margin5,
        ),
        BaseTextFormFieldRounded(
          borderRadius: Dimens.margin10,
          controller: displayNameController,
          hintText: "Enter Display Name",
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
          hintStyle: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).hintColor,
            FontWeight.w600,
          ),
        )
      ],
    );
  }

  Widget location() {
    return Column(
      children: [
        textTitle("Location"),
        const SizedBox(
          height: Dimens.margin5,
        ),
        InkWell(
          onTap: () {
            showLocationDialog();
          },
          child: BaseTextFormFieldRounded(
            enabled: false,
            borderRadius: Dimens.margin10,
            hintText: "Enter your address",
            controller: locationController,
            hintStyle: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin18,
              Theme.of(context).hintColor,
              FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget bio() {
    return Column(
      children: [
        textTitle("Bio"),
        const SizedBox(
          height: Dimens.margin5,
        ),
        BaseTextFormFieldRounded(
          borderRadius: Dimens.margin10,
          hintText: "Enter your bio",
          controller: bioController,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
          hintStyle: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).hintColor,
            FontWeight.w600,
          ),
        )
      ],
    );
  }

  String? hintDateText;
  DateTime? pickedDateTime;
  Widget datePickerField(BuildContext context) {
    // todo change initial date time
    return Column(
      children: [
        textTitle("DOB"),
        const SizedBox(
          height: Dimens.margin5,
        ),
        BaseDatePicker(
          borderRadius: Dimens.margin10,
          hintText: hintDateText ?? getTranslate(APPStrings.textDateOfBirth),
          initialDateTime: pickedDateTime,
          onDateTimeChanged: (p0) {
            setState(() {
              pickedDateTime = p0;
              hintDateText = "${p0.month.toString().padLeft(2, '0')}-${p0.day.toString().padLeft(2, '0')}-${p0.year}";
            });
          },
          hintStyle: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).hintColor,
            FontWeight.w600,
          ),
        ),
      ],
    );
  }

  GenderModel gender = GenderModel();
  Widget genderPickerField(BuildContext context) {
    // todo change initial date time
    return Column(
      children: [
        textTitle("Gender"),
        const SizedBox(
          height: Dimens.margin5,
        ),
        GenderDropdown(
          borderRadius: Dimens.margin10,
          hintText: gender.genderString ?? getTranslate(APPStrings.textGender),
          onChanged: (p0) {
            setState(() {
              printWrapped("${p0.type}");
              gender = p0;
            });
          },
        ),
      ],
    );
  }

  SmokeModel smoke = SmokeModel();
  Widget smokePickerField(BuildContext context) {
    return Column(
      children: [
        textTitle("Smoke"),
        const SizedBox(
          height: Dimens.margin5,
        ),
        SmokeDropdown(
          borderRadius: Dimens.margin10,
          hintText: smoke.smoke ?? 'Please select',
          onChanged: (p0) {
            setState(() {
              printWrapped("${p0.type}");
              smoke = p0;
            });
          },
        ),
      ],
    );
  }

  DrinkModel drinkText = DrinkModel();
  Widget drinkPickerField(BuildContext context) {
    // todo change initial date time
    return Column(
      children: [
        textTitle("Drink?"),
        const SizedBox(
          height: Dimens.margin5,
        ),
        DrinkDropdown(
          borderRadius: Dimens.margin10,
          // hintText: smokeText ?? getTranslate(APPStrings.textGender),
          hintText: drinkText.drink ?? 'Please select',
          onChanged: (p0) {
            setState(() {
              printWrapped("${p0.type}");
              drinkText = p0;
            });
          },
        ),
      ],
    );
  }

  Widget nextButton({required Function onTap}) {
    return CommonButton(
      isLoading: isLoadingButton.value,
      text: getTranslate(APPStrings.textNext),
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        onTap();
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   if(pageIndex.value < 2)
        //     {
        // }
        // },);
      },
    );
  }

  Widget saveButton() {
    return CommonButton(
      isLoading: isLoadingButton.value,
      // text: getTranslate(APPStrings.),
      text: "Save",
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        uploadImage();
      },
    );
  }

  uploadImage() {
    Map<String, String> body = {};
    for (int i = 0; i < imageList.value.length; i++) {
      // if (imageList.value[i].imageDatabaseUrl != null) {
      //   body['deleted_images[$i]'] = imageList.value[i].imageId.toString();
      // }
    }
    BlocProvider.of<PostProfilePictureBloc>(context).add(PostProfilePictureApi(url: AppUrls.apiPostImage, body: body, imageList: imageList.value));
  }

  getImages() {
    var listImages = getUser().userData?.profileImages ?? [];
    printWrapped("profile images = ${listImages.length}");

    bool isDefaultAvailable = false;
    for (int i = 0; listImages.length > 3 ? i < 3 : i < listImages.length; i++) {
      if (listImages[i].isDefault == true) // this variable shows main user image
          {
        imageToShow.value = listImages[i].imageUrl ?? '';
        isDefaultAvailable = true;
      }
      imageList.value.removeAt(i);
      imageList.value.insert(
          i, ProfilePictureModel(imageId: listImages[i].imageId, isDefault: listImages[i].isDefault, containsDatabaseImage: true, imageDatabaseUrl: listImages[i].imageUrl));
    }
    if (!isDefaultAvailable) {
      imageToShow.value = listImages.isNotEmpty ? listImages.first.imageUrl ?? '' : '';
    }
  }

  Widget pageOne() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            userDisplayName(),
            const SizedBox(
              height: 10,
            ),
            location(),
            const SizedBox(
              height: 10,
            ),
            bio(),
            const SizedBox(
              height: 10,
            ),
            datePickerField(context),
            const SizedBox(
              height: 15,
            ),
            genderPickerField(context),
            const SizedBox(
              height: 15,
            ),
            smokePickerField(context),
            const SizedBox(
              height: 15,
            ),
            drinkPickerField(context),
            const SizedBox(
              height: 15,
            ),
            nextButton(onTap: () => updateUserProfile())
          ],
        ),
      ),
    );
  }

  Widget questionAnswerContent(QuestionsWithAnswers data, int index) {
    return SizedBox(
      // height: 170,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (!isEditing[index]) {
                    setState(() {
                      isEditing[index] = true;
                    });
                  }
                },
                child: Container(
                  width: double.maxFinite,
                  // height: 100,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.question ?? '',
                        style: getTextStyleFromFont(
                          AppFont.poppins,
                          Dimens.margin15,
                          Theme.of(context).colorScheme.onSecondary,
                          FontWeight.w600,
                        ),
                      ),
                      Visibility(
                        visible: (queAndAns[index].answer ?? '').isNotEmpty,
                        replacement: const Padding(
                          padding: EdgeInsets.only(top: 8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            queAndAns[index].answer ?? '',
                            style: getTextStyleFromFont(
                              AppFont.poppins,
                              Dimens.margin25,
                              Theme.of(context).colorScheme.onPrimary,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 18), child: SizedBox())
            ],
          ),
          if (isEditing[index]) ...[
            Positioned(
              right: 50,
              // height: 50,
              bottom: 1,
              left: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 10,
                    color: Colors.transparent,
                    child: BaseTextFormFieldRounded(
                      height: 50,
                      borderRadius: Dimens.margin10,
                      controller: qaControllers[index],
                      onChange: () {
                        setState(() {});
                      },
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
                      hintText: "Write your answer here",
                      onSubmit: () {
                        setState(() {
                          queAndAns[index].answer = qaControllers[index].text.trim();
                          queAndAns[index].questionId = data.questionId;
                          isEditing[index] = false;
                          // qaControllers[index].text = '';
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget pageTwo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Answers",
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin20,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: (modelQuestionAnswers.value.data ?? []).length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: questionAnswerContent(modelQuestionAnswers.value.data?[index] ?? QuestionsWithAnswers(), index),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: Dimens.margin10,
        ),
        nextButton(onTap: () => validateQueAns())
      ],
    );
  }

  ValueNotifier<List<ProfilePictureModel>> imageList = ValueNotifier([
    ProfilePictureModel(),
    ProfilePictureModel(),
    ProfilePictureModel(),
  ]);

  ValueNotifier<String> imageToShow = ValueNotifier('');

  Widget pageThree() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Profile Pictures",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin20,
                  Theme.of(context).colorScheme.onPrimary,
                  FontWeight.w600,
                ),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: imageList.value.length,
            itemBuilder: (context, index) {
              if (index < imageList.value.length) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      width: Dimens.margin200,
                      height: Dimens.margin200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Visibility(
                            visible: imageList.value[index].containsDatabaseImage == true && !imageList.value[index].isUpdate!,
                            replacement: imageList.value[index].imageFile != null
                                ? Image.file(
                              imageList.value[index].imageFile!,
                              width: Dimens.margin200,
                              height: Dimens.margin200,
                              fit: BoxFit.cover,
                            )
                                : Image.asset(APPImages.icDummyProfile),
                            child: Image.network(
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // Image is fully loaded
                                }
                                return const Center(
                                  child: CommonLoadingAnimation(), // Show the loading animation
                                );
                              },
                              imageList.value[index].imageDatabaseUrl ?? '',
                              width: Dimens.margin200,
                              height: Dimens.margin200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showPopUpForProfilePic(update: true, index: index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin30), color: Theme.of(context).colorScheme.secondary.withOpacity(0.7)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                imageList.value[index].isDefault == false && imageList.value[index].isUpdate == false && imageList.value[index].containsDatabaseImage == true,
                                child: GestureDetector(
                                  onTap: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoConfirmationDialog(
                                        title: getTranslate(APPStrings.textSetAsDefaultPic),
                                        description: getTranslate(APPStrings.textSetAsDefaultPicCnf),
                                        cancelText: getTranslate(APPStrings.textCancel),
                                        confirmText: getTranslate(APPStrings.textOk),
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                        onConfirm: () {
                                          setDefaultProfilePic(imageList.value[index].imageId ?? 0);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin30), color: Theme.of(context).colorScheme.secondary.withOpacity(0.7)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Set as default",
                                            style: getTextStyleFromFont(AppFont.poppins, Dimens.margin15, Theme.of(context).colorScheme.onPrimary, FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                // Add button
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      showPopUpForProfilePic(update: false);
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300], // Background color for the add button
                      ),
                      child: Center(
                        child: Icon(Icons.add, size: 50, color: Colors.grey[700]), // Add icon
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: Dimens.margin10,
          ),
          Visibility(visible: isProfilePicUpdated.value, child: saveButton())
        ],
      ),
    );
  }

  final PageController _pageController = PageController();
  Widget containerDetails() {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "About Me",
              style: getTextStyleFromFont(
                shadow: <Shadow>[
                  const Shadow(
                    // offset: Offset(5.0, 5.0),
                    blurRadius: Dimens.margin25,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
                AppFont.poppins,
                Dimens.margin30,
                Theme.of(context).primaryColor,
                FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimens.margin30), topRight: Radius.circular(Dimens.margin30)), color: Theme.of(context).primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: Dimens.margin200,
                  child: CustomProgressBar(
                    totalSteps: 3,
                    currentSteps: pageIndex.value + 1,
                  ),
                ),
                const SizedBox(
                  height: Dimens.margin10,
                ),
                Expanded(
                  child: PageView.custom(
                    onPageChanged: (value) {
                      pageIndex.value = value;
                    },
                    controller: _pageController,
                    childrenDelegate: SliverChildListDelegate(
                      [pageOne(), pageTwo(), pageThree()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  Widget getBody() {
    return Stack(
      children: [
        // Visibility(
        //   visible: !imageList.value.first.isUpdate!,
        //   replacement: // Image.asset(
        //       imageList.value.first.imageFile != null
        //           ? Image.file(
        //               imageList.value.first.imageFile!,
        //               width: double.maxFinite,
        //               height: MediaQuery.of(context).size.height / 1.7,
        //               fit: BoxFit.cover,
        //             )
        //           : Image.asset(
        //               APPImages
        //                   .icDummyProfile, // Replace with your actual image path
        //               fit: BoxFit.cover,
        //               width: double.maxFinite,
        //               height: MediaQuery.of(context).size.height / 1.7,
        //             ),
        //   child: (userDetail.userData?.profileImages ?? []).isNotEmpty
        //       ? Image.network(
        //           (userDetail.userData?.profileImages ?? []).first.imageUrl ??
        //               '', // Replace with your actual image path
        //           fit: BoxFit.cover,
        //           width: double.maxFinite,
        //           height: MediaQuery.of(context).size.height / 1.7,
        //         )
        //       : Image.asset(
        //           APPImages
        //               .icDummyProfile, // Replace with your actual image path
        //           fit: BoxFit.cover,
        //           width: double.maxFinite,
        //           height: MediaQuery.of(context).size.height / 1.7,
        //         ),
        // ),
        Visibility(
            visible: imageToShow.value.isNotEmpty,
            replacement: Image.asset(
              APPImages.icDummyProfile, // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            ),
            child: Image.network(
              imageToShow.value, // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            )),
        SafeArea(child: navigationWithLogo()),
        containerDetails(),
        Visibility(
            visible: isApiLoading.value,
            child: const Center(
              child: CommonLoadingAnimation(),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [pageIndex, isApiLoading, isLoadingAnimation, isLoadingButton, modelQuestionAnswers, imageList, imageToShow, isProfilePicUpdated],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<GetUserProfilePrefBloc, GetUserProfilePrefState>(
                listener: (context, state) {
                  isApiLoading.value = state is GetUserProfilePrefLoading;
                  if (state is GetUserProfilePrefFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is GetUserProfilePrefResponse) {
                    getQueAns();
                    displayNameController.text = state.modelUserEditProfilePrefs.data?.username ?? '';
                    bioController.text = state.modelUserEditProfilePrefs.data?.bio ?? '';
                    hintDateText = state.modelUserEditProfilePrefs.data?.dob ?? '';
                    locationController.text = state.modelUserEditProfilePrefs.data?.location ?? '';
                    // for dob
                    if (state.modelUserEditProfilePrefs.data?.dob != null) {
                      pickedDateTime = convertToDateTime(state.modelUserEditProfilePrefs.data?.dob ?? '');
                    }
                    // for gender
                    if (state.modelUserEditProfilePrefs.data?.gender != null && state.modelUserEditProfilePrefs.data?.gender is String) {
                      gender.genderString = gendersList[gendersList.indexWhere(
                            (element) => element.type == int.parse(state.modelUserEditProfilePrefs.data?.gender ?? ''),
                      )]
                          .genderString;
                    }
                    // for smoke
                    if (state.modelUserEditProfilePrefs.data?.isSmoke != null && state.modelUserEditProfilePrefs.data?.isSmoke is String) {
                      smoke.smoke = smokeList[smokeList.indexWhere(
                            (element) => element.type == int.parse(state.modelUserEditProfilePrefs.data?.isSmoke ?? ''),
                      )]
                          .smoke;
                    }
                    // for drink
                    if (state.modelUserEditProfilePrefs.data?.isDrink != null && state.modelUserEditProfilePrefs.data?.isDrink is String) {
                      drinkText.drink = drinksList[drinksList.indexWhere(
                            (element) => element.type == int.parse(state.modelUserEditProfilePrefs.data?.isDrink ?? ''),
                      )]
                          .drink;
                    }
                  }
                },
              ),
              BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
                listener: (context, state) {
                  isLoadingButton.value = state is UpdateUserProfileLoading;
                  if (state is UpdateUserProfileFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is UpdateUserProfileResponse) {
                    ToastController.showToast(context, state.modelUpdatedProfileData.message ?? '', true);
                    _pageController.animateToPage(pageIndex.value + 1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                  }
                },
              ),
              BlocListener<GetUserQueAnsBloc, GetUserQueAnsState>(
                listener: (context, state) {
                  isApiLoading.value = state is GetUserQueAnsLoading;
                  if (state is GetUserQueAnsFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is GetUserQueAnsResponse) {
                    modelQuestionAnswers.value = state.modelQuestionAnswers;
                    for (int i = 0; i < (state.modelQuestionAnswers.data ?? []).length; i++) {
                      isEditing.add(false);
                      queAndAns.add(QuestionsWithAnswers(answer: state.modelQuestionAnswers.data?[i].answer ?? ''));
                      qaControllers.add(TextEditingController(text: state.modelQuestionAnswers.data?[i].answer ?? ''));
                    }
                  }
                },
              ),
              BlocListener<PostUserQueAnsBloc, PostUserQueAnsState>(
                listener: (context, state) {
                  isApiLoading.value = state is PostUserQueAnsLoading;
                  if (state is PostUserQueAnsFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is PostUserQueAnsResponse) {
                    ToastController.showToast(context, state.modelQueAnsPostResponse.message ?? '', true);
                    _pageController.animateToPage(pageIndex.value + 1, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                  }
                },
              ),
              BlocListener<PostProfilePictureBloc, PostProfilePictureState>(
                listener: (context, state) {
                  isLoadingButton.value = state is PostProfilePictureLoading;
                  if (state is PostProfilePictureFailure) {
                    if (state.error.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.error.generalError ?? '', false);
                    }
                  }
                  if (state is PostProfilePictureResponse) {
                    isProfilePicUpdated.value = false;
                    ToastController.showToast(context, state.response.message ?? '', true);
                    getUserProfilePictures();
                  }
                },
              ),
              BlocListener<GetUserProfilePicBloc, GetUserProfilePicState>(
                listener: (context, state) {
                  isApiLoading.value = state is GetUserProfilePicLoading;
                  if (state is GetUserProfilePicFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is GetUserProfilePicResponse) {
                    // ToastController.showToast(context, state.modelGetImages.message ?? '', true);
                    userDetail.userData?.profileImages?.clear();
                    for (int i = 0; i < (state.modelGetImages.data ?? []).length; i++) {
                      userDetail.userData?.profileImages?.add(ProfileImages(
                          imageId: state.modelGetImages.data?[i].id, imageUrl: state.modelGetImages.data?[i].imagePath, isDefault: state.modelGetImages.data?[i].isDefault));
                      if (state.modelGetImages.data?[i].isDefault == true) {
                        userDetail.userData?.defaultProfilePic = state.modelGetImages.data?[i].imagePath;
                      }
                    }
                    PreferenceHelper.setString(PreferenceHelper.userData, json.encode(userDetail));

                    getImages();
                  }
                },
              ),
              BlocListener<SetDefaultProfilePicBloc, SetDefaultProfilePicState>(
                listener: (context, state) {
                  isLoadingButton.value = state is SetDefaultProfilePicLoading;
                  if (state is SetDefaultProfilePicFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is SetDefaultProfilePicResponse) {
                    ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                    getUserProfilePictures();
                  }
                },
              ),
            ],
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                // backgroundColor: Colors.white,
                body: IgnorePointer(ignoring: isApiLoading.value, child: getBody())),
          );
        });
  }

  /// this widget is used to get location lat lng and location description
  showLocationDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
            valueListenable: isLoadingAnimation,
            builder: (context, value, child) {
              return Dialog(
                insetPadding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(Dimens.margin30),
                ),
                child: Stack(
                  children: [
                    Visibility(
                      visible: isLoadingAnimation.value,
                      child: const Center(child: CommonLoadingAnimation()),
                    ),
                    IgnorePointer(
                      ignoring: isLoadingAnimation.value,
                      child: Column(
                        children: [
                          navigationWithLogo(),
                          Padding(
                            padding: const EdgeInsets.all(Dimens.margin16),
                            child: GooglePlaceAutoCompleteTextField(
                                containerHorizontalPadding: Dimens.margin10,
                                boxDecoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(Dimens.margin10)),
                                debounceTime: 300,

                                inputDecoration: InputDecoration(
                                    hintStyle: getTextStyleFromFont(
                                      AppFont.poppins,
                                      Dimens.margin17,
                                      Theme.of(context).colorScheme.onPrimary,
                                      FontWeight.w600,
                                    ),
                                    hintText: "Search",
                                    contentPadding: const EdgeInsets.all(Dimens.margin5),
                                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                                textStyle: getTextStyleFromFont(
                                  AppFont.poppins,
                                  Dimens.margin17,
                                  Theme.of(context).colorScheme.onPrimary,
                                  FontWeight.w600,
                                ),
                                getPlaceDetailWithLatLng: (postalCodeResponse) {
                                  locationController.text = postalCodeResponse.description.toString();
                                  latitudeSelected = postalCodeResponse.lat  ?? '';
                                  longitudeSelected = postalCodeResponse.lat ?? '';
                                  Navigator.pop(context);
                                },
                                textEditingController: locationController,
                                itemClick: (postalCodeResponse) {},
                                itemBuilder: (context, index, prediction) {
                                  return Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Expanded(
                                              child: Text(
                                                prediction.description ?? "",
                                                style: getTextStyleFromFont(
                                                  AppFont.poppins,
                                                  Dimens.margin17,
                                                  Theme.of(context).colorScheme.onPrimary,
                                                  FontWeight.w600,
                                                ),
                                              ))
                                        ],
                                      ));
                                },
                                googleAPIKey: AppConfig.googleMapApiKey),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimens.margin15),
                            child: CommonButton(
                              onTap: () {
                                _getCurrentPosition();
                              },
                              text: "Get Current Location",
                              textStyle: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, Theme.of(context).primaryColor, FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: Dimens.margin10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ToastController.showToast(context, 'Location services are disabled. Please enable the services', false);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    latitudeSelected = '';
    longitudeSelected = '';
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    isLoadingAnimation.value = true;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        printWrapped("current address = $_currentAddress");
        printWrapped("!.latitude = ${_currentPosition!.latitude}");
        printWrapped("!.longitude = ${_currentPosition!.longitude}");
        locationController.text = _currentAddress.toString();
        isLoadingAnimation.value = false;
        Navigator.pop(context);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  /// This dialog contains pop up regarding getting methods for profile pictures
  showPopUpForProfilePic({required bool update, int? index}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(color: CupertinoColors.systemBackground.resolveFrom(context), borderRadius: BorderRadius.circular(Dimens.margin15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select a photo",
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin17,
                        Theme.of(context).colorScheme.secondary,
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                CupertinoButton(
                  child: Text(
                    "Open Camera",
                    style: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, CupertinoColors.activeBlue, FontWeight.w600),
                  ),
                  onPressed: () async {
                    await getImageCameraForVerification(update: update, index: index);
                  },
                ),
                const Divider(),
                CupertinoButton(
                  child: Text(
                    "Select from Gallery",
                    style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue, FontWeight.w600),
                  ),
                  onPressed: () async {
                    await getImageGalleryForVerification(update: update, index: index);
                  },
                ),
                const Divider(),
                CupertinoButton(
                  child: Text(
                    "Cancel",
                    style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.systemRed, FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> photoPermission({required bool update, int? index}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 90, ratioY: 90),
        // : CropStyle.rectangle,
        compressQuality: 70,
      );
      // imageFile?.value = File(croppedFile!.path);
      imageFile?.value = File(croppedFile!.path);
      if (update == false) {
        imageList.value.add(ProfilePictureModel(containsDatabaseImage: false, imageFile: imageFile!.value));
      } else {
        var bool = imageList.value[index!].containsDatabaseImage;
        var isDefault = imageList.value[index].isDefault;
        var id = imageList.value[index].imageId;
        imageList.value[index] = ProfilePictureModel(containsDatabaseImage: bool, imageFile: imageFile!.value, isDefault: isDefault, imageId: id, isUpdate: true);
      }
      isProfilePicUpdated.value = true;
      setState(() {});
    }
  }

  Future<void> cameraPermission({required bool update, int? index}) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 90, ratioY: 90),
        // : CropStyle.rectangle,
        compressQuality: 70,
      );
      imageFile?.value = File(croppedFile!.path);
      if (update == false) {
        imageList.value.add(ProfilePictureModel(containsDatabaseImage: false, imageFile: imageFile!.value));
      } else {
        var bool = imageList.value[index!].containsDatabaseImage;
        var isDefault = imageList.value[index].isDefault;
        var id = imageList.value[index].imageId;
        imageList.value[index] = ProfilePictureModel(containsDatabaseImage: bool, isDefault: isDefault, imageFile: imageFile!.value, imageId: id, isUpdate: true);
      }
      isProfilePicUpdated.value = true;
      setState(() {});
    }
  }

  ///[getImageCameraForVerification] it is used for image picker in mobile platform from camera
  /*Future getImageCameraForVerification({required bool update, int? index}) async {
    Navigator.pop(context);
    await Permission.camera.isGranted.then((value) async {
      /// if Permission is granted
      if (value) {
        cameraPermission(update: update,index: index);
      } else {
        await Permission.camera.request().then((permission){
          if(permission.isLimited || permission.isGranted){
            cameraPermission(update: update,index: index);
          }
        });
      }
    });
    if (await Permission.camera.isPermanentlyDenied || await Permission.camera.isDenied || await Permission.camera.isRestricted) {
      ToastController.showToast(context, 'Storage permission denied.', false);
    }
  }*/
  ///[getImageCameraForVerification] it is used for image picker in mobile platform from camera
  Future getImageCameraForVerification({required bool update, int? index}) async {
    Navigator.pop(context);
    if (Platform.isAndroid) {
      /// initialize device info package only for Android
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      print("deviceInfo.version.sdkInt :${deviceInfo.version.sdkInt}");

      /// Ask for permissions regarding storage
      if (await Permission.storage.isDenied) {
        if (deviceInfo.version.sdkInt > 32) {
          await Permission.photos.request();
        } else {
          await Permission.storage.request();
        }
      }
    } else

      /// for ios
    {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
    }

    /// if Permission is granted
    if (await Permission.storage.isGranted || await Permission.photos.isGranted || await Permission.storage.isLimited || await Permission.photos.isLimited) {
      cameraPermission(update: update, index: index);
    } else {
      ToastController.showToast(context, 'Storage permission denied.', false);
    }
  }

  ///[getImageGalleryForVerification] it is used for image picker in mobile platform from gallery
  Future getImageGalleryForVerification({required bool update, int? index}) async {
    Navigator.pop(context);
    if (Platform.isAndroid) {
      /// initialize device info package only for Android
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;

      /// Ask for permissions regarding storage
      if (await Permission.storage.isDenied) {
        if (deviceInfo.version.sdkInt > 32) {
          await Permission.photos.request();
        } else {
          await Permission.storage.request();
        }
      }
    } else

      /// for ios
    {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
    }
    print("await Permission.photos.isGranted :${await Permission.photos.status}");

    /// if Permission is granted
    if (await Permission.storage.isGranted || await Permission.photos.isGranted || await Permission.storage.isLimited || await Permission.photos.isLimited) {
      photoPermission(update: update, index: index);
    } else {
      ToastController.showToast(context, 'Storage permission denied.', false);
    }
  }

  /// This is for getting user data for tab one
  void getUserPref() {
    BlocProvider.of<GetUserProfilePrefBloc>(context).add(GetUserProfilePref(url: AppUrls.apiGetProfilePrefs(getUser().userData?.id ?? 0)));
  }

  void updateUserProfile() {
    Map<String, dynamic> body = {};

// Conditionally add entries
    if (getUser().userData?.id != null) {
      body[AppConfig.paramUserId] = getUser().userData?.id;
    }
    if (displayNameController.text.isNotEmpty) {
      body[AppConfig.paramName] = displayNameController.text.trim();
    }
    if (hintDateText != null) {
      body[AppConfig.paramDOB] = hintDateText;
    }
    if (bioController.text.trim().isNotEmpty) {
      body[AppConfig.paramBio] = bioController.text.trim();
    }
    if (gender.type != null) {
      body[AppConfig.paramGender] = gender.type.toString();
    }
    if (drinkText.type != null) {
      body[AppConfig.paramIsDrink] = drinkText.type;
    }
    if (smoke.type != null) {
      body[AppConfig.paramIsSmoke] = smoke.type;
    }
    if (locationController.text.isNotEmpty) {
      body[AppConfig.paramLocation] = locationController.text;
    }
    if (latitudeSelected.isNotEmpty) {
      body[AppConfig.paramLatitude] = latitudeSelected;
    }
    if (longitudeSelected.isNotEmpty) {
      body[AppConfig.paramLongitude] = longitudeSelected;
    }
    if (_currentPosition?.latitude != null) {
      body[AppConfig.paramLatitude] = _currentPosition?.latitude.toString();
    }
    if (_currentPosition?.longitude != null) {
      body[AppConfig.paramLongitude] = _currentPosition?.longitude.toString();
    }
    BlocProvider.of<UpdateUserProfileBloc>(context).add(UpdateUserProfile(body: body, url: AppUrls.apiEditUserProfile));
  }

  // Method to get user question and answers
  void getQueAns() {
    BlocProvider.of<GetUserQueAnsBloc>(context).add(GetUserQueAns(url: AppUrls.apiFetchUserQueAns(getUser().userData?.id ?? 0)));
  }

  void validateQueAns() {
    bool isValid = true;
    setState(() {
      for (int i = 0; i < isEditing.length; i++) {
        if (isEditing[i]) {
          isValid = false;
          isEditing[i] = false;
          queAndAns[i].answer = qaControllers[i].text.trim();
          queAndAns[i].questionId = modelQuestionAnswers.value.data?[i].questionId;
        }
      }
    });
    // if (isValid) {
    //   uploadQuestionAnswers();
    // } else {
    //   ToastController.showToast(context, "Please submit your answers to continue", false);
    // }
    uploadQuestionAnswers();
  }

  // Method to post user questions and answers
  void uploadQuestionAnswers() {
    List<QuestionsWithAnswers> mList = [];
    for (QuestionsWithAnswers data in queAndAns) {
      if (data.questionId != null) {
        mList.add(data);
      }
    }

    Map<String, dynamic> body = {AppConfig.paramQueAns: mList.map((v) => v.toJson()).toList()};
    BlocProvider.of<PostUserQueAnsBloc>(context).add(PostUserQueAns(body: body, url: AppUrls.apiPostUserQueAns));
  }

  // Method to get user profile pictures after user updates the pictures
  void getUserProfilePictures() {
    printWrapped("======================= calling profile pictures");
    BlocProvider.of<GetUserProfilePicBloc>(context).add(GetUserProfilePic(url: AppUrls.apiGetProfilePicture));
  }

  // Method to set a profile picture default
  void setDefaultProfilePic(int id) {
    Map<String, dynamic> body = {"image_id": id};
    BlocProvider.of<SetDefaultProfilePicBloc>(context).add(SetDefaultProfilePic(url: AppUrls.apiSetDefaultProfilePicture, body: body));
  }
}
