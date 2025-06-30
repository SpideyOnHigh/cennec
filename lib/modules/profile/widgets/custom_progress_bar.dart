

import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

///[CustomProgressBar] This class use to Custom ProgressIndicator
class CustomProgressBar extends StatelessWidget {
  CustomProgressBar({Key? key, required this.totalSteps, required this.currentSteps}) : super(key: key);

  int totalSteps;
  int currentSteps;

  @override
  Widget build(BuildContext context) {
    return StepProgressIndicator(
      totalSteps: totalSteps,
      currentStep: currentSteps,

      selectedColor: Theme.of(context).colorScheme.onSecondary,
      unselectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
      roundedEdges: const Radius.circular(Dimens.margin10),
    );
  }
}