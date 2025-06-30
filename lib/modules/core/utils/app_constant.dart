//library MyConstant;
import 'package:cennec/modules/core/common/widgets/drink_dropdown.dart';
import 'package:cennec/modules/core/common/widgets/smoke_dropdown.dart';
import '../common/widgets/gender_dropdown.dart';

int isMainUpload = 0;
int isUploadDone = 0;

// gender List
final List<GenderModel> gendersList = [
  GenderModel(genderString: "Male", type: 1),
  GenderModel(genderString: "Female", type: 2),
  GenderModel(genderString: "Others", type: 3),
];

// smoke list
final List<SmokeModel> smokeList = [//todo to set dynamic
  SmokeModel(smoke: "No", type: 0),
  SmokeModel(smoke: "Yes", type: 1),
  SmokeModel(smoke: "Prefer not to say", type: 2),
];

// drink List
final List<DrinkModel> drinksList = [
  DrinkModel(drink: "No", type: 0),
  DrinkModel(drink: "Socially", type: 1),
  DrinkModel(drink: "Private", type: 2),
  DrinkModel(drink: "Prefer not to say", type: 3),
];