import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/interests/bloc/get_interests/get_interests_lists_bloc.dart';
import 'package:cennec/modules/interests/bloc/update_user_interests/update_user_interests_bloc.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import '../../core/utils/common_import.dart';

class ScreenSignupInterests extends StatefulWidget {
  const ScreenSignupInterests({super.key});

  @override
  State<ScreenSignupInterests> createState() => _ScreenSignupInterestsState();
}

class _ScreenSignupInterestsState extends State<ScreenSignupInterests> {
  Widget logo() {
    return Image.asset(
      APPImages.icLogoWithName, // Update with your logo path
      height: 80,
    );
  }

  ValueNotifier<List<ModelInterests>> modelInterestList = ValueNotifier([]);
  ValueNotifier<List<ModelInterests>> filterList = ValueNotifier([]);
  TextEditingController searchController = TextEditingController();

  List<int> selectedInterests = [];

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isUpdating = ValueNotifier(false);

  @override
  void initState() {
    printWrapped("init called========================================================================");
    getInterests();
    super.initState();
  }

  Widget selectInterestsTitle(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textSelectInterests).toString(),
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin25,
        Theme.of(context).colorScheme.primary,
        FontWeight.w700,
      ),
    );
  }

  Widget chooseOneTexts(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textChooseOne).toString(),
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin16,
        Theme.of(context).colorScheme.primary,
        FontWeight.w600,
      ),
    );
  }

  Widget searchField(BuildContext context) {
    return BaseTextFormFieldRounded(
      controller: searchController,
      borderRadius: Dimens.margin15,
      hintText: getTranslate(APPStrings.textSearchTypingPh),
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: Dimens.margin5,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(APPImages.icSearch),
          ),
        ],
      ),
      onChange: () {
        searchAlgo();
      },
      // onSubmit: ()
      // {
      //   FocusScope.of(context).unfocus();
      // },
      // focusNode: FocusNode(),
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor.withOpacity(0.9),
        FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
      ),
    );
  }

  /// This is the local search algorithm which is used for searching specific interests
  searchAlgo() {
    setState(() {
      if (searchController.text.length > 1) {
        filterList.value.clear();
        filterList.value.addAll(
            modelInterestList.value.where((interest) => (interest.interestName ?? '').toLowerCase().contains(searchController.text.toLowerCase())).toList());
      }
      if (searchController.text.length < 2) {
        for (int i = 0; i < modelInterestList.value.length; i++) {
          for (int j = 0; j < filterList.value.length; j++) {
            if (modelInterestList.value[i].id == filterList.value[j].id && filterList.value[j].isSelected == true) {
              modelInterestList.value[i].isSelected = filterList.value[j].isSelected;
            }
          }
        }
        filterList.value.clear();
        for (ModelInterests item in modelInterestList.value) {
          filterList.value.add(item);
        }
      }
    });
  }

  Widget interestGridview() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: Dimens.margin5,
      children: [
        ...List.generate(
          filterList.value.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                filterList.value[index].isSelected = !filterList.value[index].isSelected!;
                if (selectedInterests.contains(filterList.value[index].id ?? 0)) {
                  selectedInterests.remove(filterList.value[index].id ?? 0);
                } else {
                  selectedInterests.add(filterList.value[index].id ?? 0);
                }
                // interests[index].color = getRandomColor();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.margin11),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.3,
                  ),
                  color:
                      (filterList.value[index].isSelected ?? false) ? hexToColor(filterList.value[index].interestColor ?? '') : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(Dimens.margin8),
                child: Text(
                  filterList.value[index].interestName ?? '',
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin18,
                    Theme.of(context).colorScheme.onSecondary,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

/*  Widget nextButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: Dimens.margin50,
      child: ElevatedButton(
        onPressed: () {
          // Navigator.pushNamed(context, AppRoutes.routesScreenCommunityGuidelines);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          getTranslate(APPStrings.textNext),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).primaryColor,
            FontWeight.w600,
          ),
        ),
      ),
    );
  } */

  Widget nextButton(BuildContext context) {
    return CommonButton(
      isLoading: isUpdating.value,
      text: getTranslate(APPStrings.textNext),
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        validate();
        // Navigator.pushNamed(context, AppRoutes.routesScreenFindConnectionsSignUp);
      },
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.margin10),
          logo(),
          const SizedBox(height: Dimens.margin20),
          selectInterestsTitle(context),
          chooseOneTexts(context),
          const SizedBox(height: 20),
          searchField(context),
          const SizedBox(height: 10),
          Expanded(
              child: Visibility(
            visible: filterList.value.isNotEmpty,
            replacement: Center(
                child: Text(
              getTranslate(APPStrings.textNoInterests),
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin18,
                Theme.of(context).hintColor.withOpacity(0.9),
                FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
              ),
            )),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  child: interestGridview(),
                )),
          )),
          const SizedBox(height: Dimens.margin25),
          nextButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [isLoading, modelInterestList, filterList, isUpdating],
            builder: (context, values, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<GetInterestsListsBloc, GetInterestsListsState>(
                    listener: (context, state) {
                      isLoading.value = state is GetInterestsListsLoading;
                      if (state is GetInterestsListsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is GetInterestsListsResponse) {
                        for (ModelInterests modelInterests in state.modelInterestsList.data ?? []) {
                          modelInterestList.value.add(
                              ModelInterests(id: modelInterests.id, interestName: modelInterests.interestName, interestColor: modelInterests.interestColor,isInterestAdded:modelInterests.isInterestAdded));
                          filterList.value.add(
                              ModelInterests(id: modelInterests.id, interestName: modelInterests.interestName, interestColor: modelInterests.interestColor,isInterestAdded:modelInterests.isInterestAdded));
                        }
                        // modelInterestList.value = state.modelInterestsList.data ?? [];
                        // filterList.value = state.modelInterestsList.data ?? [];
                      }
                    },
                  ),
                  BlocListener<UpdateUserInterestsBloc, UpdateUserInterestsState>(
                    listener: (context, state) {
                      isUpdating.value = state is UpdateUserInterestsLoading;
                      if (state is UpdateUserInterestsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                        if (state.errorMessage.interestId != null) {
                          ToastController.showToast(context, state.errorMessage.interestId ?? '', false);
                        }
                      }
                      if (state is UpdateUserInterestsResponse) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.routesScreenFindConnectionsSignUp,
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: IgnorePointer(
                      ignoring: isLoading.value,
                      child: Stack(
                        children: [
                          getBody(context),
                          Visibility(
                              visible: isLoading.value,
                              child: const Center(
                                child: CommonLoadingAnimation(),
                              ))
                        ],
                      )),
                ),
              );
            }));
  }

  validate() {
    if (selectedInterests.isEmpty) {
      ToastController.showToast(context, getTranslate(ValidationString.textValidateOneInterests), false);
    } else {
      updateInterests();
    }
  }

  void getInterests()  {
    BlocProvider.of<GetInterestsListsBloc>(context).add(GetInterestsLists(url: AppUrls.apiGetInterests));
  }

  void updateInterests()  {
    Map<String, dynamic> body = {AppConfig.paramUserId: getUser().userData?.id ?? 0, AppConfig.paramInterestsId: selectedInterests.toList()};
    BlocProvider.of<UpdateUserInterestsBloc>(context).add(UpdateUserInterests(url: AppUrls.apiUpdateUserInterests, body: body));
  }
}
