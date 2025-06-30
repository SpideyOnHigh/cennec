import 'package:flutter/material.dart';

class AppFont {
  static const poppins = 'Poppins';
  static const visby = 'Visby';

  static const regular = TextStyle(fontFamily: poppins);
  static const bold = TextStyle(fontFamily: poppins, fontWeight: FontWeight.bold);
  static const italic = TextStyle(fontFamily: poppins, fontStyle: FontStyle.italic);
  static const semiBold = TextStyle(fontFamily: poppins, fontWeight: FontWeight.w600);

  ///-------REGULAR-------------
  // ///colorRed
  // static final colorRed = regular.copyWith(color: AppColors.colorRed);
  //
  // ///colorWhite-------
  // // static final colorWhite = bold.copyWith(color: AppColors.colorWhite);
  //
  // ///-------BOLD-------------
  // ///colorBlack-------
  // static final boldBlack = bold.copyWith(color: AppColors.colorBlack);
  //
  // ///boldBlack54-------
  // static final boldBlack54 = bold.copyWith(color: AppColors.colorBlack54);
  //
  // ///-------SEMI BOLD-------------
  // ///semiBoldBlack-------
  // static final semiBoldBlack = semiBold.copyWith(color: AppColors.colorBlack);
  //
  // ///-------ITALIC-------------
  // ///italicBlack-------
  // static final italicBlack = italic.copyWith(color: AppColors.colorBlack);
  //
  // ///Visby Regular
  // static const visbyRegular = TextStyle(fontFamily: visby);
  //
  // ///Visby Regular Black
  // static final visbyRegularBlack = visbyRegular.copyWith(color: AppColors.colorBlack);
}
