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
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Feedback',
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin20,
          Theme.of(context).colorScheme.onSecondary,
          FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget cennecLogo() {
    return Center(
      child: Image.asset(
        APPImages.icCennecBottom,
        height: 80,
        width: 120,
      ),
    );
  }

  Widget cennecFeedbackTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your opinion is important this.',
          textAlign: TextAlign.center,
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin16,
            Theme.of(context).colorScheme.secondary,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This way we can keep improving our app.',
          textAlign: TextAlign.center,
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin16,
            Theme.of(context).colorScheme.secondary,
            FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your overall satisfaction\nwith Cennec?',
          style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin20,
              Theme.of(context).colorScheme.onSecondary,
              FontWeight.w600
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => _setRating(index + 1),
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  size: 35,
                  color: index < _rating ? Colors.amber : Theme.of(context).colorScheme.secondary,
                ),
              ),
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
          'Select the type of feedback you\'d like to give:',
          style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin18,
              Theme.of(context).colorScheme.onSecondary,
              FontWeight.w600
          ),
        ),
        const SizedBox(height: 20),
        _buildFeedbackOptionsGrid(),
      ],
    );
  }

  Widget _buildFeedbackOptionsGrid() {
    List<Data> feedbackOptions = modelQuestions.data ?? [];

    if (feedbackOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    List<Widget> rows = [];
    for (int i = 0; i < feedbackOptions.length; i += 2) {
      List<Widget> rowChildren = [];

      // First option in row
      rowChildren.add(
        Expanded(
          child: _buildFeedbackOption(
            feedbackOptions[i].id ?? 0,
            feedbackOptions[i].feedbackTitle ?? '',
          ),
        ),
      );

      // Second option in row (if exists)
      if (i + 1 < feedbackOptions.length) {
        rowChildren.add(const SizedBox(width: 16));
        rowChildren.add(
          Expanded(
            child: _buildFeedbackOption(
              feedbackOptions[i + 1].id ?? 0,
              feedbackOptions[i + 1].feedbackTitle ?? '',
            ),
          ),
        );
      } else {
        // If odd number of options, add empty expanded to balance
        rowChildren.add(const SizedBox(width: 16));
        rowChildren.add(const Expanded(child: SizedBox()));
      }

      rows.add(Row(children: rowChildren));

      // Add spacing between rows (except last row)
      if (i + 2 < feedbackOptions.length) {
        rows.add(const SizedBox(height: 16));
      }
    }

    return Column(children: rows);
  }

  Widget _buildFeedbackOption(int value, String title) {
    bool isSelected = selectedIndex == value;
    return GestureDetector(
      onTap: () {
        if (errorFeedbackType.value.isNotEmpty) {
          errorFeedbackType.value = '';
        }
        setState(() {
          selectedIndex = value;
          _feedbackType = value;
        });
        printWrapped(value.toString());
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin16,
                Theme.of(context).colorScheme.onSecondary,
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textFieldSendMessage() {
    return Container(
      height: Dimens.margin200,
      width: double.maxFinite,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        inputFormatters: feedbackTextController.text.isEmpty
            ? [AlphanumericAndSpecialCharFormatter(), FilteringTextInputFormatter.deny(RegExp(r'^\s'))]
            : null,
        keyboardType: TextInputType.multiline,
        onChanged: (value) {
          setState(() {});
          if (errorEmptyController.value.isNotEmpty) {
            errorEmptyController.value = '';
          }
        },
        controller: feedbackTextController,
        maxLength: 500,
        maxLines: null,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin16,
          Theme.of(context).colorScheme.onSecondary,
          FontWeight.w400,
        ),
        decoration: const InputDecoration(
          hintText: 'Write something here..',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: CommonButton(
        isLoading: buttonLoading.value,
        text: 'Send Feedback',
        backgroundColor: const Color(0xFF2C3E50), // Dark blue color from screenshot
        textColor: Colors.white,
        onTap: () => validate(),
      ),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        navigationWithLogo(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cennecLogo(),
                const SizedBox(height: 32),
                cennecFeedbackTitle(context),
                const SizedBox(height: 40),
                _buildRatingWidget(),
                const SizedBox(height: 40),
                _buildFeedbackTypeSelector(),
                Visibility(
                  visible: errorFeedbackType.value.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: BaseTextFieldErrorIndicator(
                      errorText: errorFeedbackType.value,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                textFieldSendMessage(),
                Visibility(
                  visible: errorEmptyController.value.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: BaseTextFieldErrorIndicator(
                      errorText: errorEmptyController.value,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 20),
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
                  IgnorePointer(
                    ignoring: isLoading.value || buttonLoading.value,
                    child: getBody(),
                  ),
                  Visibility(
                    visible: isLoading.value,
                    child: const Center(
                      child: CommonLoadingAnimation(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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