import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/feedback/bloc/get_feedback_que/get_feedback_que_bloc.dart';
import 'package:cennec/modules/feedback/bloc/post_feedback/post_feedback_bloc.dart';
import 'package:cennec/modules/feedback/model/model_get_feedback_que.dart';
import 'package:flutter/services.dart';

import '../../core/utils/common_import.dart';

class ScreenFeedback extends StatefulWidget {
  const ScreenFeedback({super.key});

  @override
  State<ScreenFeedback> createState() => _ScreenFeedbackState();
}

class _ScreenFeedbackState extends State<ScreenFeedback> {
  int _rating = 0;
  int? _feedbackType;
  TextEditingController feedbackTextController = TextEditingController();

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> buttonLoading = ValueNotifier(false);
  ValueNotifier<String> errorFeedbackType = ValueNotifier("");
  ValueNotifier<String> errorEmptyController = ValueNotifier("");
  ModelFeedbackQuestions modelQuestions = ModelFeedbackQuestions();

  @override
  void initState() {
    getFeedbackQuestions();
    super.initState();
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _setFeedbackType(int type) {
    setState(() {
      _feedbackType = type;
    });
  }

  Widget navigationWithLogo() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            APPImages.icBack,
            color: Theme.of(context).colorScheme.onSecondary, // Update with your logo path
            height: Dimens.margin30,
            width: Dimens.margin30,
          ),
        ),
        Center(
          child: Image.asset(
            APPImages.icCennecBottom, // Update with your logo path
            height: 40,
          ),
        ),
      ],
    );
  }

  Widget cennecFeedbackTitle(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textCorrectFeedback).toString(),
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin32,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslate(APPStrings.textFeedbackText1),
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, Theme.of(context).colorScheme.secondary, FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Text(
          getTranslate(APPStrings.textFeedbackText2),
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, Theme.of(context).colorScheme.secondary, FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRatingWidget() {
    return Column(
      children: [
        Text(
          getTranslate(APPStrings.textTapToRate),
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin20, Theme.of(context).colorScheme.onSecondary, FontWeight.w600),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                size: 40,
                color: index < _rating ? Colors.amber : Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => _setRating(index + 1),
            );
          }),
        ),
      ],
    );
  }

  int selectedIndex = 0;
  Widget _buildFeedbackTypeSelector() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${getTranslate(APPStrings.textFeedbackText3)}:',
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, Theme.of(context).colorScheme.secondary, FontWeight.w600),
        ),
        Column(
          children: List.generate((modelQuestions.data ?? []).length, (index) {
            return SizedBox(
              height: Dimens.margin40,
              child: RadioListTile(
                splashRadius: 0,
                enableFeedback: false,
                activeColor: Theme.of(context).colorScheme.onPrimary,
                title: Text(
                  modelQuestions.data?[index].feedbackTitle ?? '',
                  style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, Theme.of(context).colorScheme.onPrimary, FontWeight.w600),
                ),
                groupValue: selectedIndex,
                value: modelQuestions.data?[index].id,
                onChanged: (value) {
                  if (errorFeedbackType.value.isNotEmpty) {
                    errorFeedbackType.value = '';
                  }
                  printWrapped(value.toString());
                  selectedIndex = value ?? 0;
                  _setFeedbackType(value ?? 0);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget textFieldSendMessage() {
    return Container(
      height: Dimens.margin200,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.margin20, vertical: Dimens.margin10),
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor,
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
        borderRadius: BorderRadius.circular(Dimens.margin20),
      ),
      child: TextField(
        inputFormatters: feedbackTextController.text.isEmpty ? [AlphanumericAndSpecialCharFormatter(), FilteringTextInputFormatter.deny(RegExp(r'^\s'))] : null,
        keyboardType: TextInputType.multiline,

        onChanged: (value) {
          setState(() {});
          if (errorEmptyController.value.isNotEmpty) {
            errorEmptyController.value = '';
          }
        },
        controller: feedbackTextController,
        maxLength: 500,
        maxLines: 10,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.primary,
          FontWeight.w600,
        ), // Text color inside the TextField
        decoration: const InputDecoration(
          hintText: 'Write something here..',
          border: InputBorder.none, // Removes the border
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CommonButton(isLoading: buttonLoading.value, text: getTranslate(APPStrings.textSend), backgroundColor: Theme.of(context).colorScheme.primary, onTap: () => validate());
  }

  Widget getBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          navigationWithLogo(),
          const SizedBox(height: 20),
          cennecFeedbackTitle(context),
          _buildIntroText(),
          const SizedBox(height: 20),
          _buildRatingWidget(),
          const SizedBox(height: 20),
          _buildFeedbackTypeSelector(),
          Visibility(
              visible: errorFeedbackType.value.isNotEmpty,
              child: BaseTextFieldErrorIndicator(
                errorText: errorFeedbackType.value,
              )),
          const SizedBox(height: 40),
          textFieldSendMessage(),
          Visibility(
              visible: errorEmptyController.value.isNotEmpty,
              child: BaseTextFieldErrorIndicator(
                errorText: errorEmptyController.value,
              )),
          const SizedBox(height: 20),
          _buildSubmitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isLoading, errorEmptyController, errorFeedbackType, buttonLoading],
        builder: (context, values, child) {
          return SafeArea(
            child: MultiBlocListener(
              listeners: [
                BlocListener<GetFeedbackQueBloc, GetFeedbackQueState>(
                  listener: (context, state) {
                    isLoading.value = state is GetFeedbackQueLoading;
                    if (state is GetFeedbackQueFailure) {
                      if (state.errorMessage.generalError!.isNotEmpty) {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                    }
                    if (state is GetFeedbackQueResponse) {
                      modelQuestions = state.modelFeedbackQuestions;
                      _rating = state.modelFeedbackQuestions.givenRating ?? 0;
                    }
                  },
                ),
                BlocListener<PostFeedbackBloc, PostFeedbackState>(
                  listener: (context, state) {
                    buttonLoading.value = state is PostFeedbackLoading;
                    if (state is PostFeedbackFailure) {
                      if (state.errorMessage.generalError!.isNotEmpty) {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                      if (state.errorMessage.feedbackId != null) {
                        ToastController.showToast(context, state.errorMessage.feedbackId ?? '', false);
                      }
                    }
                    if (state is PostFeedbackResponse) {
                      ToastController.showToast(context, state.modelFeedbackResponse.message ?? '', true);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
              child: Scaffold(
                  backgroundColor: Theme.of(context).primaryColor,
                  body: Stack(
                    children: [
                      IgnorePointer(ignoring: isLoading.value || buttonLoading.value, child: getBody()),
                      Visibility(
                        visible: isLoading.value,
                        child: const Center(
                          child: CommonLoadingAnimation(),
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }

  validate() {
    bool isValid = true;
    if (_feedbackType == null && feedbackTextController.text.trim().isNotEmpty) {
      errorFeedbackType.value = getTranslate(ValidationString.textValidateFeedback1);
      isValid = false;
    }
    if (feedbackTextController.text.trim().isEmpty && _feedbackType != null) {
      errorEmptyController.value = getTranslate(ValidationString.textValidateFeedback2);
      isValid = false;
    }
    if (isValid) {
      postFeedbackQuestions();
    }
  }

  void getFeedbackQuestions() {
    BlocProvider.of<GetFeedbackQueBloc>(context).add(GetFeedbackQue(url: AppUrls.apiGetFeedbackQue));
  }

  void postFeedbackQuestions() {
    Map<String, dynamic> body = {
      AppConfig.paramUserId: getUser().userData?.id ?? 0,
      AppConfig.paramRating: _rating,
    };

    if (_feedbackType != null) {
      body[AppConfig.paramFeedbackType] = _feedbackType;
      body[AppConfig.paramComment] = feedbackTextController.text.trim();
    }
    BlocProvider.of<PostFeedbackBloc>(context).add(PostFeedback(url: AppUrls.apiPostFeedback, body: body));
  }
}
