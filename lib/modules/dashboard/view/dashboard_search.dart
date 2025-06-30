import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/interests/bloc/get_interests/get_interests_lists_bloc.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';

class DashboardSearch extends StatefulWidget {
  const DashboardSearch({super.key});

  @override
  State<DashboardSearch> createState() => _DashboardSearchState();
}

class _DashboardSearchState extends State<DashboardSearch> {
  TextEditingController searchController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    getInterests();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  ValueNotifier<List<ModelInterests>> modelInterestList = ValueNotifier([]);
  ValueNotifier<List<ModelInterests>> filterList = ValueNotifier([]);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Widget logo() {
    return Image.asset(
      APPImages.icCennecBottom, // Update with your logo path
      height: 40,
    );
  }

  Widget searchForNewTitle(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textSearchForNewInterests).toString(),
      // "Search for new interests",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin25,
        Theme.of(context).hintColor,
        FontWeight.w700,
      ),
    );
  }

  Widget selectTagTexts(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textSelectTagInstruction).toString(),
      // "Select a tag to add to your list of interests, find people with mutual interests and see related categories",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin15,
        Theme.of(context).colorScheme.primary,
        FontWeight.w600,
      ),
    );
  }

  Widget searchField(BuildContext context) {
    return BaseTextFormFieldRounded(
      borderRadius: Dimens.margin15,
      hintText: getTranslate(APPStrings.textSearchForNewInterests),
      controller: searchController,
      focusNode: _focusNode,
      onChange: () {
        searchAlgo();
      },
      onSubmit: () {
        FocusScope.of(context).unfocus();
      },
      // hintText: "Search for new interests",
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
              // FocusScope.of(context).unfocus();
              _focusNode.unfocus();

              Navigator.pushNamed(context, AppRoutes.routesScreenRecommendationOfInterests,
                  arguments: ModelInterestsDataTransfer(interestId: filterList.value[index].id, interestName: filterList.value[index].interestName)).then(
                (value) {
                  if(value == true)
                    {
                      getInterests();
                    }
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.margin11),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.3,
                  ),
                  color: filterList.value[index].isInterestAdded == true
                      ? hexToColor(filterList.value[index].interestColor ?? '')
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(Dimens.margin8),
                child: Text(
                  filterList.value[index].interestName ?? '',
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin18,
                    Theme.of(context).colorScheme.primary,
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

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.margin10),
          logo(),
          const SizedBox(height: Dimens.margin20),
          searchForNewTitle(context),
          selectTagTexts(context),
          const SizedBox(height: 20),
          searchField(context),
          const SizedBox(height: 10),
          Expanded(
              child: Visibility(
            visible: filterList.value.isNotEmpty,
            replacement: Center(
                child: Text(
              getTranslate(isLoading.value? APPStrings.textLoadingInterests : APPStrings.textNoInterests),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [isLoading, modelInterestList, filterList],
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
                        modelInterestList.value.clear();
                        filterList.value.clear();
                        for (ModelInterests modelInterests in state.modelInterestsList.data ?? []) {
                          modelInterestList.value.add(ModelInterests(
                              id: modelInterests.id,
                              interestName: modelInterests.interestName,
                              interestColor: modelInterests.interestColor,
                              isInterestAdded: modelInterests.isInterestAdded));
                          filterList.value.add(ModelInterests(
                              id: modelInterests.id,
                              interestName: modelInterests.interestName,
                              interestColor: modelInterests.interestColor,
                              isInterestAdded: modelInterests.isInterestAdded));
                        }
                        // modelInterestList.value = state.modelInterestsList.data ?? [];
                        // filterList.value = state.modelInterestsList.data ?? [];
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

  void getInterests()  {
    BlocProvider.of<GetInterestsListsBloc>(context).add(GetInterestsLists(url: AppUrls.apiGetInterests));
  }
}
