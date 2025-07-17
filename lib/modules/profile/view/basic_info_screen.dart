import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/common/widgets/drink_dropdown.dart';
import '../../core/common/widgets/gender_dropdown.dart';
import '../../core/common/widgets/smoke_dropdown.dart';
import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/app_config.dart';
import '../../core/utils/app_urls.dart';
import '../../core/utils/common_import.dart';
import '../bloc/get_user_profile_pref/get_user_profile_pref_bloc.dart';
import '../bloc/update_user_profile/update_user_profile_bloc.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  // Controllers
  TextEditingController displayNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Loading states
  final ValueNotifier<bool> isApiLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoadingButton = ValueNotifier<bool>(false);

  // Date picker variables
  DateTime? pickedDateTime;
  String hintDateText = "Select Date";

  // Gender variables
  GenderModel gender = GenderModel();
  List<GenderModel> gendersList = [
    GenderModel(type: 1, genderString: "Male"),
    GenderModel(type: 2, genderString: "Female"),
  ];

  // Smoke variables
  SmokeModel smoke = SmokeModel();
  List<SmokeModel> smokeList = [
    SmokeModel(type: 1, smoke: "Yes"),
    SmokeModel(type: 2, smoke: "No"),
    SmokeModel(type: 3, smoke: "Occasionally"),
  ];

  // Drink variables
  DrinkModel drinkText = DrinkModel();
  List<DrinkModel> drinksList = [
    DrinkModel(type: 1, drink: "Yes"),
    DrinkModel(type: 2, drink: "No"),
    DrinkModel(type: 3, drink: "Occasionally"),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  void _fetchUserProfile() {
    BlocProvider.of<GetUserProfilePrefBloc>(context).add(GetUserProfilePref(url: AppUrls.apiGetProfilePrefs(getUser().userData?.id ?? 0)));
  }

  void _updateProfile() {
    if (formKey.currentState?.validate() ?? false) {
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
      // if (latitudeSelected.isNotEmpty) {
      //   body[AppConfig.paramLatitude] = latitudeSelected;
      // }
      // if (longitudeSelected.isNotEmpty) {
      //   body[AppConfig.paramLongitude] = longitudeSelected;
      // }
      // if (_currentPosition?.latitude != null) {
      //   body[AppConfig.paramLatitude] = _currentPosition?.latitude.toString();
      // }
      // if (_currentPosition?.longitude != null) {
      //   body[AppConfig.paramLongitude] = _currentPosition?.longitude.toString();
      // }
      BlocProvider.of<UpdateUserProfileBloc>(context).add(UpdateUserProfile(body: body, url: AppUrls.apiEditUserProfile));

    }
  }

  int _getGenderType() {
    return gendersList.firstWhere(
          (element) => element.genderString == gender.genderString,
      orElse: () => gendersList.first,
    ).type ?? 1;
  }

  int _getSmokeType() {
    return smokeList.firstWhere(
          (element) => element.smoke == smoke.smoke,
      orElse: () => smokeList.first,
    ).type ?? 1;
  }

  int _getDrinkType() {
    return drinksList.firstWhere(
          (element) => element.drink == drinkText.drink,
      orElse: () => drinksList.first,
    ).type ?? 1;
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  DateTime? convertToDateTime(String dateString) {
    try {
      List<String> parts = dateString.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      print("Error parsing date: $e");
    }
    return null;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickedDateTime ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        pickedDateTime = picked;
        hintDateText = _formatDate(picked) ?? "Select Date";
      });
    }
  }

  Widget _topSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "Basic Info",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildDisplayNameField() {
    return CommonTextFormField(
      label: "Display Name",
      controller: displayNameController,
      suffixIcon: const Icon(Icons.person_outline),
      validator: (String? val) {
        if (val?.isEmpty ?? true) {
          return "Please enter your display name";
        }
        return null;
      },
    );
  }

  Widget _buildLocationField() {
    return CommonTextFormField(
      label: "Location",
      controller: locationController,
      suffixIcon: const Icon(Icons.location_on_outlined),
      validator: (String? val) {
        if (val?.isEmpty ?? true) {
          return "Please enter your location";
        }
        return null;
      },
    );
  }

  Widget _buildBioField() {
    return CommonTextFormField(
      label: "Write about yourself",
      controller: bioController,
      maxLines: 4,
      maxLength: 300,
      validator: (String? val) {
        if (val?.isEmpty ?? false) {
          return "Please enter your bio";
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date of Birth",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.colorBlack60,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.colorCardBackgroundProfile,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.colorBlack60),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hintDateText,
                  style: TextStyle(
                    fontSize: 16,
                    color: hintDateText == "Select Date"
                        ? AppColors.colorBlack60
                        : AppColors.colorDarkBlue,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.colorBlack60,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: gendersList.map((genderItem) {
            bool isSelected = gender.genderString == genderItem.genderString;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    gender.genderString = genderItem.genderString;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.colorDarkBlue
                                : AppColors.colorBlack60,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.colorDarkBlue,
                            ),
                          ),
                        )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        genderItem.genderString ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String title, String value, List<String> items, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            // color: AppColors.colorBlack60,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            // color: AppColors.colorTextFieldBg,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: AppColors.coloBor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: const Text("Select"),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimens.margin30),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDisplayNameField(),
            const SizedBox(height: Dimens.margin20),

            _buildLocationField(),
            const SizedBox(height: Dimens.margin20),

            _buildBioField(),
            const SizedBox(height: Dimens.margin20),

            _buildDateField(),
            const SizedBox(height: Dimens.margin20),

            _buildGenderField(),
            const SizedBox(height: Dimens.margin20),

            _buildDropdownField(
              "Do You Smoke?",
              smoke.smoke ?? '',
              smokeList.map((e) => e.smoke ?? '').toList(),
                  (value) {
                setState(() {
                  smoke.smoke = value;
                });
              },
            ),
            const SizedBox(height: Dimens.margin20),

            _buildDropdownField(
              "Do You Drink?",
              drinkText.drink ?? '',
              drinksList.map((e) => e.drink ?? '').toList(),
                  (value) {
                setState(() {
                  drinkText.drink = value;
                });
              },
            ),
            const SizedBox(height: Dimens.margin30),

            ValueListenableBuilder<bool>(
              valueListenable: isLoadingButton,
              builder: (context, isLoading, child) {
                return CommonButton(
                  backgroundColor: AppColors.colorDarkBlue,
                  onTap: isLoading ? null : _updateProfile,
                  text: isLoading ? "Saving..." : "Save",
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Loading profile..."),
        ],
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        _topSection(),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: isApiLoading,
            builder: (context, isLoading, child) {
              return isLoading ? _buildLoadingView() : _buildFormContent();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorRoundedBgContainer,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<GetUserProfilePrefBloc, GetUserProfilePrefState>(
              listener: (context, state) {
                isApiLoading.value = state is GetUserProfilePrefLoading;

                if (state is GetUserProfilePrefFailure) {
                  if (state.errorMessage.generalError!.isNotEmpty) {
                    ToastController.showToast(
                        context,
                        state.errorMessage.generalError ?? '',
                        false
                    );
                  }
                }

                if (state is GetUserProfilePrefResponse) {
                  displayNameController.text = state.modelUserEditProfilePrefs.data?.username ?? '';
                  bioController.text = state.modelUserEditProfilePrefs.data?.bio ?? '';
                  hintDateText = state.modelUserEditProfilePrefs.data?.dob ?? 'Select Date';
                  locationController.text = state.modelUserEditProfilePrefs.data?.location ?? '';

                  // for dob
                  if (state.modelUserEditProfilePrefs.data?.dob != null) {
                    pickedDateTime = convertToDateTime(state.modelUserEditProfilePrefs.data?.dob ?? '');
                  }

                  // for gender
                  if (state.modelUserEditProfilePrefs.data?.gender != null && state.modelUserEditProfilePrefs.data?.gender is String) {
                    gender.genderString = gendersList[gendersList.indexWhere(
                          (element) => element.type == int.parse(state.modelUserEditProfilePrefs.data?.gender ?? ''),
                    )].genderString;
                  }

                  // for smoke
                  if (state.modelUserEditProfilePrefs.data?.isSmoke != null && state.modelUserEditProfilePrefs.data?.isSmoke is String) {
                    smoke.smoke = smokeList[smokeList.indexWhere(
                          (element) => element.type == int.parse(state.modelUserEditProfilePrefs.data?.isSmoke ?? ''),
                    )].smoke;
                  }

                  // for drink
                  if (state.modelUserEditProfilePrefs.data?.isDrink != null && state.modelUserEditProfilePrefs.data?.isDrink is String) {
                    drinkText.drink = drinksList[drinksList.indexWhere(
                          (element) => element.type == int.parse(state.modelUserEditProfilePrefs.data?.isDrink ?? ''),
                    )].drink;
                  }
                }
              },
            ),

            BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
              listener: (context, state) {
                isLoadingButton.value = state is UpdateUserProfileLoading;

                if (state is UpdateUserProfileFailure) {
                  if (state.errorMessage.generalError!.isNotEmpty) {
                    ToastController.showToast(
                        context,
                        state.errorMessage.generalError ?? '',
                        false
                    );
                  }
                }

                if (state is UpdateUserProfileResponse) {
                  ToastController.showToast(
                      context,
                      state.modelUpdatedProfileData.message ?? 'Profile updated successfully!',
                      true
                  );

                  // Navigate to next screen or pop
                  Navigator.pop(context);
                }
              },
            ),
          ],
          child: getBody(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    displayNameController.dispose();
    locationController.dispose();
    bioController.dispose();
    isApiLoading.dispose();
    isLoadingButton.dispose();
    super.dispose();
  }
}

// // Model classes
// class GenderModel {
//   int? type;
//   String? genderString;
//
//   GenderModel({this.type, this.genderString});
// }
//
// class SmokeModel {
//   int? type;
//   String? smoke;
//
//   SmokeModel({this.type, this.smoke});
// }
//
// class DrinkModel {
//   int? type;
//   String? drink;
//
//   DrinkModel({this.type, this.drink});
// }