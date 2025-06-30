import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/gender_dropdown.dart';
import 'package:cennec/modules/core/utils/app_constant.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
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
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
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

  Widget textWidget(String text) {
    return Text(
      text,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).colorScheme.onSecondary,
        FontWeight.w600,
      ),
    );
  }

  ValueNotifier<bool> isLoadingAnimation = ValueNotifier(false);
  ValueNotifier<bool> isApiLoading = ValueNotifier(false);
  ValueNotifier<bool> buttonLoading = ValueNotifier(false);

  final bool _notificationsEnabled = true;

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        getTranslate(title),
        // title,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin22,
          Theme.of(context).hintColor,
          FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        getTranslate(title),
        // title,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin20,
          Theme.of(context).colorScheme.onSecondary,
          FontWeight.w600,
        ),
      ),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  // ============== widgets regarding location ===================
  TextEditingController locationController = TextEditingController();
  final double _minDistance = 0.0;
  double _maxDistance = 50.0;
  double _valuesDistance = 50;
  bool showUserAsPerLocation = false;

  Widget locationTitleText(BuildContext context) {
    return Row(
      children: [
        Text(
          getTranslate(APPStrings.textLocation),
          // "Location",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin24,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget locationChangeRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            // getTranslate(APPStrings.),
            locationController.text,
            overflow: TextOverflow.ellipsis,
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin20,
              Theme.of(context).colorScheme.onPrimary,
              FontWeight.w700,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showLocationDialog();
          },
          child: Text(
            getTranslate(APPStrings.textChangeLocation),
            // "Change Location",
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin20,
              Theme.of(context).hintColor,
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget locationMenuContainer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: locationTitleText(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: Dimens.margin10),
          child: locationChangeRow(),
        ),
      ],
    );
  }

  Widget maxDistanceMenuContainer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(APPStrings.textMaxDistance),
            Text(
              // getTranslate(APPStrings.),
              "${_valuesDistance.toStringAsFixed(0)} miles",
              overflow: TextOverflow.ellipsis,
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin20,
                Theme.of(context).hintColor,
                FontWeight.w700,
              ),
            ),
          ],
        ),
        Slider(
          min: _minDistance,
          max: _maxDistance,
          value: _valuesDistance,
          onChanged: (value) {
            setState(() {
              _valuesDistance = value;
            });
          },
        ),
        _buildSwitchTile(
          title: APPStrings.textUserInRange,
          value: showUserAsPerLocation,
          onChanged: (value) {
            setState(() {
              showUserAsPerLocation = value;
            });
          },
        ),
      ],
    );
  }

  // ================ widgets regarding age ====================
  double _minAge = 18.0;
  double _maxAge = 100.0;
  int userAge = 0;
  SfRangeValues _valuesAge = const SfRangeValues(18, 100);
  bool showUserAsPerAge = false;

  Widget ageChangeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          // getTranslate(APPStrings.),
          // "Age $userAge",
          "Age",
          overflow: TextOverflow.ellipsis,
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin20,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
        InkWell(
          onTap: () {
            _showDatePicker(context);
          },
          child: Text(
            getTranslate(APPStrings.textChangeAge),
            // "Change age",
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin20,
              Theme.of(context).hintColor,
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget ageRangeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getTranslate(APPStrings.textAgeRange),
          // "Age Range",
          overflow: TextOverflow.ellipsis,
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin20,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
        InkWell(
          onTap: () {
            _showDatePicker(context);
          },
          child: Text(
            // getTranslate(APPStrings.),
            "${_valuesAge.start.toStringAsFixed(0)}-${_valuesAge.end.toStringAsFixed(0)}",
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin20,
              Theme.of(context).hintColor,
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget ageMenuContainer() {
    return Column(
      children: [
        // ageChangeRow(),
        // const SizedBox(
        //   height: Dimens.margin10,
        // ),
        ageRangeRow(),
        SfRangeSlider(
          min: _minAge,
          max: _maxAge,
          values: _valuesAge,
          onChanged: (SfRangeValues value) {
            setState(() {
              _valuesAge = value;
            });
          },
        ),
        _buildSwitchTile(
          title: APPStrings.textUserInRange,
          value: showUserAsPerAge,
          onChanged: (value) {
            setState(() {
              showUserAsPerAge = value;
            });
          },
        ),
      ],
    );
  }

  // ================== widgets regarding interests ===================
  final double _minInterests = 0.0;
  double _maxInterests = 10.0;
  double _valuesInterests = 10;
  bool showUserAsPerInterests = false;

  Widget minimumMutualInterestsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getTranslate(APPStrings.textMinMutualInts),
          // "Minimum mutual interests",
          overflow: TextOverflow.ellipsis,
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin20,
            Theme.of(context).colorScheme.onPrimary,
            FontWeight.w700,
          ),
        ),
        Text(
          // getTranslate(APPStrings.),
          _valuesInterests.toStringAsFixed(0),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin20,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget mutualInterestMenuContainer() {
    return Column(
      children: [
        _buildSectionTitle(APPStrings.textInterests),
        const SizedBox(
          height: Dimens.margin5,
        ),
        minimumMutualInterestsRow(),
        const SizedBox(
          height: Dimens.margin10,
        ),
        Slider(
          min: _minInterests,
          max: _maxInterests,
          value: _valuesInterests,
          onChanged: (value) {
            setState(() {
              _valuesInterests = value;
            });
          },
        ),
        _buildSwitchTile(
          title: APPStrings.textUserInRange,
          value: showUserAsPerInterests,
          onChanged: (value) {
            setState(() {
              showUserAsPerInterests = value;
            });
          },
        ),
      ],
    );
  }

  // ===================== widgets regarding gender ======================
  GenderModel selectedGender = GenderModel();
  Widget genderRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(APPStrings.textGender),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Radio(
              value: gendersList[0].type ?? '',
              activeColor: Theme.of(context).colorScheme.onPrimary,
              groupValue: selectedGender.type,
              onChanged: (value) => setState(() => selectedGender.type = value as int?),
            ),
            Text(
              gendersList[0].genderString ?? '',
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin15,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),
            Radio(
              value: gendersList[1].type ?? '',
              activeColor: Theme.of(context).colorScheme.onPrimary,
              groupValue: selectedGender.type,
              onChanged: (value) => setState(() => selectedGender.type = value as int?),
            ),
            Text(
              gendersList[1].genderString ?? '',
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin15,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),
            Radio(
              activeColor: Theme.of(context).colorScheme.onPrimary,
              value: gendersList[2].type ?? '',
              groupValue: selectedGender.type,
              onChanged: (value) => setState(() => selectedGender.type = value as int?),
            ),
            Text(
              gendersList[2].genderString ?? '',
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin15,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ======================== widgets regarding privacy and visibility ===================
  bool showInSearchResults = false;
  bool showInRecommendations = false;

  Widget showMeMenuContainer() {
    return Column(
      children: [
        _buildSectionTitle(APPStrings.textShowMe),
        _buildSwitchTile(
          title: APPStrings.textInSearchResult,
          value: showInSearchResults,
          onChanged: (value) {
            setState(() {
              showInSearchResults = value;
            });
          },
        ),
        _buildSwitchTile(
          title: APPStrings.textInRecConnection,
          value: showInRecommendations,
          onChanged: (value) {
            setState(() {
              showInRecommendations = value;
            });
          },
        ),
      ],
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        Visibility(
            visible: (getUser().userData ?? UserData()).defaultProfilePic != null,
            replacement: Image.asset(
              APPImages.icDummyProfile, // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            ),
            child: Image.network(
              (getUser().userData ?? UserData()).defaultProfilePic ?? '', // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            )),
        SafeArea(child: navigationWithLogo()),
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                getTranslate(APPStrings.textPreferences),
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
          Container(
            height: Dimens.margin500,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimens.margin30), topRight: Radius.circular(Dimens.margin30)),
                color: Theme.of(context).primaryColor),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  locationMenuContainer(),
                  const SizedBox(
                    height: Dimens.margin10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        maxDistanceMenuContainer(),
                        const Divider(
                          thickness: Dimens.margin2,
                        ),
                        const SizedBox(
                          height: Dimens.margin15,
                        ),
                        ageMenuContainer(),
                        const Divider(
                          thickness: Dimens.margin2,
                        ),
                        const SizedBox(
                          height: Dimens.margin10,
                        ),
                        mutualInterestMenuContainer(),
                        const Divider(
                          thickness: Dimens.margin2,
                        ),
                        const SizedBox(
                          height: Dimens.margin10,
                        ),
                        genderRow(),
                        const Divider(
                          thickness: Dimens.margin2,
                        ),
                        const SizedBox(
                          height: Dimens.margin10,
                        ),
                        showMeMenuContainer(),
                        const SizedBox(
                          height: Dimens.margin10,
                        ),
                        CommonButton(
                          isLoading: buttonLoading.value,
                          text: getTranslate(APPStrings.textApplyFilter),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            postPreferences();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
        // Bottom Navigation Bar
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
