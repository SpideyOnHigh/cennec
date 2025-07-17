import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/core/common/widgets/common_appbar.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/gender_dropdown.dart';
import 'package:cennec/modules/core/utils/app_constant.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/core/utils/parsing_helper.dart';
import 'package:cennec/modules/preferences/bloc/get_user_preference/get_user_preference_bloc.dart';
import 'package:cennec/modules/preferences/bloc/post_user_preference/post_user_preference_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../core/common/widgets/button.dart';
import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/app_config.dart';

class ScreenPreferences extends StatefulWidget {
  const ScreenPreferences({super.key});

  @override
  State<ScreenPreferences> createState() => _ScreenPreferencesState();
}

class _ScreenPreferencesState extends State<ScreenPreferences> {
  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  Widget navigationWithLogo() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      title: Text(
        "Connection Preferences",
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.onSurface,
          FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  ValueNotifier<bool> isLoadingAnimation = ValueNotifier(false);
  ValueNotifier<bool> isApiLoading = ValueNotifier(false);
  ValueNotifier<bool> buttonLoading = ValueNotifier(false);

  // Location variables
  TextEditingController locationController = TextEditingController();
  final double _minDistance = 0.0;
  double _maxDistance = 50.0;
  double _valuesDistance = 50;
  bool showUserAsPerLocation = false;

  // Age variables
  double _minAge = 18.0;
  double _maxAge = 100.0;
  int userAge = 0;
  SfRangeValues _valuesAge = const SfRangeValues(18.0, 100.0);
  bool showUserAsPerAge = false;

  // Interest variables
  final double _minInterests = 0.0;
  double _maxInterests = 10.0;
  double _valuesInterests = 10;
  bool showUserAsPerInterests = false;

  // Gender variables
  GenderModel selectedGender = GenderModel();

  // Privacy variables
  bool showInSearchResults = false;
  bool showInRecommendations = false;

  Widget _buildPreferenceCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.onSurface,
          FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? Theme.of(context).primaryColor : Colors.grey[300],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return _buildPreferenceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Location"),
          Row(
            children: [
              Expanded(
                child: Text(
                  locationController.text.isEmpty ? "Select Location" : locationController.text,
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin16,
                    Theme.of(context).colorScheme.onSurface,
                    FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: showLocationDialog,
                child: Text(
                  "Change",
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin16,
                    Theme.of(context).primaryColor,
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Maximum Distance",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              Text(
                "${_valuesDistance.toStringAsFixed(0)} Miles",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.colorDarkBlue,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.colorDarkBlue,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: _minDistance,
              max: _maxDistance,
              value: _valuesDistance,
              onChanged: (value) {
                setState(() {
                  _valuesDistance = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Only show users in this range",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              _buildCustomSwitch(
                value: showUserAsPerLocation,
                onChanged: (value) {
                  setState(() {
                    showUserAsPerLocation = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSection() {
    return _buildPreferenceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Age"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Age Range",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              Text(
                "${_valuesAge.start.toStringAsFixed(0)}-${_valuesAge.end.toStringAsFixed(0)}",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.colorDarkBlue,
              inactiveTrackColor: AppColors.colorCardBackgroundProfile,
              thumbColor: AppColors.colorDarkBlue,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: RangeSlider(
              min: _minAge,
              max: _maxAge,
              values: RangeValues(ParsingHelper.parseDoubleMethod(_valuesAge.start), ParsingHelper.parseDoubleMethod(_valuesAge.end)),
              onChanged: (RangeValues values) {
                setState(() {
                  _valuesAge = SfRangeValues(values.start, values.end);
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Only show users in this range",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              _buildCustomSwitch(
                value: showUserAsPerAge,
                onChanged: (value) {
                  setState(() {
                    showUserAsPerAge = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    return _buildPreferenceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Interests"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Minimum Mutual Interests",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              Text(
                _valuesInterests.toStringAsFixed(0),
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.colorDarkBlue,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.colorDarkBlue,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              min: _minInterests,
              max: _maxInterests,
              value: _valuesInterests,
              onChanged: (value) {
                setState(() {
                  _valuesInterests = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Only show users in this range",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              _buildCustomSwitch(
                value: showUserAsPerInterests,
                onChanged: (value) {
                  setState(() {
                    showUserAsPerInterests = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSection() {
    return _buildPreferenceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Gender"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: gendersList[0].type ?? '',
                      activeColor: Theme.of(context).primaryColor,
                      groupValue: selectedGender.type,
                      onChanged: (value) => setState(() => selectedGender.type = value as int?),
                    ),
                    Text(
                      gendersList[0].genderString ?? '',
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin16,
                        Theme.of(context).colorScheme.onSurface,
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: gendersList[1].type ?? '',
                      activeColor: Theme.of(context).primaryColor,
                      groupValue: selectedGender.type,
                      onChanged: (value) => setState(() => selectedGender.type = value as int?),
                    ),
                    Text(
                      gendersList[1].genderString ?? '',
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin16,
                        Theme.of(context).colorScheme.onSurface,
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: gendersList[2].type ?? '',
                      groupValue: selectedGender.type,
                      onChanged: (value) => setState(() => selectedGender.type = value as int?),
                    ),
                    Text(
                      gendersList[2].genderString ?? '',
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin16,
                        Theme.of(context).colorScheme.onSurface,
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return _buildPreferenceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Show Me"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "In Search Results",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              _buildCustomSwitch(
                value: showInSearchResults,
                onChanged: (value) {
                  setState(() {
                    showInSearchResults = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "In Recommendations",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin16,
                  Theme.of(context).colorScheme.onSurface,
                  FontWeight.w500,
                ),
              ),
              _buildCustomSwitch(
                value: showInRecommendations,
                onChanged: (value) {
                  setState(() {
                    showInRecommendations = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        // navigationWithLogo(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildLocationSection(),
                _buildAgeSection(),
                _buildInterestsSection(),
                _buildGenderSection(),
                _buildPrivacySection(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: buttonLoading.value ? null : postPreferences,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: buttonLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      "Apply Filters",
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin16,
                        Colors.white,
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isApiLoading, isLoadingAnimation,buttonLoading],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<GetUserPreferenceBloc, GetUserPreferenceState>(
                listener: (context, state) {
                  isApiLoading.value = state is GetUserPreferenceLoading;
                  if (state is GetUserPreferenceFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }

                  }
                  if (state is GetUserPreferenceResponse) {
                    selectedGender.type =
                        state.modelPreferences.data?.genderPreference != null?
                        int.parse(state.modelPreferences.data!.genderPreference.toString()) : null;
                    locationController.text = state.modelPreferences.data?.location ?? '';
                    _maxDistance = state.modelPreferences.data?.maxDistancePref?.toDouble() ?? 50.0;
                    _valuesDistance = state.modelPreferences.data?.distancePreference?.toDouble() ?? 50.0;
                    showUserAsPerLocation = state.modelPreferences.data?.isDistancePreference ?? false;
                    _minAge = state.modelPreferences.data?.minAgePreference?.toDouble() ?? 50.0;
                    _maxAge = state.modelPreferences.data?.maxAgePreference?.toDouble() ?? 50.0;
                    userAge = state.modelPreferences.data?.age ?? 50;
                    _valuesAge = SfRangeValues(state.modelPreferences.data?.fromAgePreference ?? 18, state.modelPreferences.data?.toAgePreference ?? 100);
                    showUserAsPerAge = state.modelPreferences.data?.isAgePreference ?? false;
                    _maxInterests = state.modelPreferences.data?.maxMutualInterestPref?.toDouble() ?? 10;
                    _valuesInterests = state.modelPreferences.data?.minMutualInterest?.toDouble() ?? 10;
                    showUserAsPerInterests = state.modelPreferences.data?.isMutualInterestPreference ?? false;
                    showInSearchResults = state.modelPreferences.data?.isDisplayInSearch ?? false;
                    showInRecommendations = state.modelPreferences.data?.isDisplayInRecommendation ?? false;
                  }
                },
              ),
              BlocListener<PostUserPreferenceBloc, PostUserPreferenceState>(
                listener: (context, state) {
                  buttonLoading.value = state is PostUserPreferenceLoading;
                  if (state is PostUserPreferenceFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                    if(state.errorMessage.genderPreference != null)
                    {
                      ToastController.showToast(context, state.errorMessage.genderPreference ?? '', false);
                    }
                  }
                  if(state is PostUserPreferenceResponse)
                    {
                      ToastController.showToast(context,state.modelPreferences.message ?? '', true);
                    }
                },
              ),
            ],
            child: Scaffold(
              appBar: CommonAppBar(title: "Connection Prefrence",),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Stack(
                children: [
                  IgnorePointer(ignoring: isApiLoading.value || buttonLoading.value, child: getBody()),
                  Visibility(
                    visible: isApiLoading.value,
                    child: const Center(
                      child: CommonLoadingAnimation(),
                    ),
                  ),
                ],
              ),
            ),
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
                                  printWrapped("postalCodeResponse = ${postalCodeResponse.lat}");
                                  printWrapped("postalCodeResponse = ${postalCodeResponse.lng}");
                                  printWrapped("postalCodeResponse = ${postalCodeResponse.description}");
                                  locationController.text = postalCodeResponse.description.toString();
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

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 355,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(color: CupertinoColors.systemBackground.resolveFrom(context), borderRadius: BorderRadius.circular(Dimens.margin15)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CupertinoDatePicker(
                        // initialDateTime: widget.initialDateTime ?? DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.mdy,
                        // minimumDate: widget.minimumDate,
                        // maximumDate: widget.maximumDate,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            // _selectedDate = newDate;
                          });
                        },
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    CupertinoButton(
                      child: Text('Confirm', style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue, FontWeight.w600)),
                      onPressed: () {
                        // widget.onDateTimeChanged?.call(_selectedDate);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Dimens.margin5,
              ),
              Container(
                decoration: BoxDecoration(color: CupertinoColors.systemBackground.resolveFrom(context), borderRadius: BorderRadius.circular(Dimens.margin15)),
                height: 50,
                width: double.maxFinite,
                child: CupertinoButton(
                  child: Text('Cancel', style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue, FontWeight.w700)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// for getting user preferences
  getPreferences() {
    BlocProvider.of<GetUserPreferenceBloc>(context).add(GetUserPreference(url: AppUrls.apiGetUserPReference));
  }

  // post preferences
  postPreferences() {
    Map<String, dynamic> body = {
      if(_currentPosition?.latitude != null)
        "latitude" : _currentPosition?.latitude ?? '',
        if(locationController.text.trim().isNotEmpty)
      "location" : locationController.text,
      if(_currentPosition?.longitude != null)
      "longitude" : _currentPosition?.longitude ?? '',

      "is_distance_preference": showUserAsPerLocation,
      "distance_preference": _valuesDistance,
      // "dob": "1985-05-15",
      "is_age_preference": showUserAsPerAge,
      "from_age_preference": int.parse(_valuesAge.start.toStringAsFixed(0)),
      "to_age_preference": int.parse(_valuesAge.end.toStringAsFixed(0)),
      "is_mutual_interest_preference": showUserAsPerInterests,
      "min_mutual_interest": _valuesInterests,
      if(selectedGender.type != null)
          "gender_preference": selectedGender.type.toString(),
      "is_display_in_search": showInSearchResults,
      "is_display_in_recommendation": showInRecommendations,
      "age": userAge,
    };
    BlocProvider.of<PostUserPreferenceBloc>(context).add(PostUserPreference(body: body, url: AppUrls.apiPostUserPReference));
  }
}
