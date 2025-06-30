// import 'package:bloc/bloc.dart';
// import 'package:cennec/modules/auth/model/model_verify_sign_up_otp.dart';
// import 'package:equatable/equatable.dart';
// import 'package:cennec/modules/auth/repository/repository_auth.dart';
// import 'package:cennec/modules/core/api_service/api_provider.dart';
// import 'package:cennec/modules/core/api_service/common_service.dart';
// import 'package:cennec/modules/core/utils/validation_string.dart';
// import 'package:http/http.dart' as http;
// import '../../../core/utils/common_import.dart';
//
// part 'forgot_password_otp_verify_event.dart';
// part 'forgot_password_otp_verify_state.dart';
//
// class ForgotPasswordOtpVerifyBloc extends Bloc<ForgotPasswordOtpVerifyEvent, ForgotPasswordOtpVerifyState> {
//   ForgotPasswordOtpVerifyBloc({
//     required RepositoryAuth repositoryAuth,
//     required ApiProvider apiProvider,
//     required http.Client client,
//   })  : mRepositoryAuth = repositoryAuth,
//         mApiProvider = apiProvider,
//         mClient = client,
//         super(ForgotPasswordOtpVerifyInitial()) {
//     on<VerifyForgotPwdOtp>(_verifyOtp);
//   }
//
//   final RepositoryAuth mRepositoryAuth;
//   final ApiProvider mApiProvider;
//   final http.Client mClient;
//
//   void _verifyOtp(
//       VerifyForgotPwdOtp event,
//       Emitter<ForgotPasswordOtpVerifyState> emit,
//       ) async {
//     /// Emitting an AuthLoading state.
//     emit(ForgotPasswordOtpVerifyLoading());
//     try {
//       /// This is a way to handle the response from the API call.
//       ModelOtpResetLink modelOtpResetLink =
//       await mRepositoryAuth.fetchResetLink(
//         event.url,
//         event.body,
//         await mApiProvider.getHeaderValue(),
//         mApiProvider,
//         mClient,
//       );
//       if (modelOtpResetLink.success == true) {
//         emit(ForgotPasswordOtpVerifyResponse(
//           modelOtpResetLink: modelOtpResetLink,
//         ));
//       } else {
//         emit(ForgotPasswordOtpVerifyFailure(errorMessage: modelOtpResetLink.message ?? ''));
//       }
//     } on SocketException {
//       emit( const ForgotPasswordOtpVerifyFailure(errorMessage: ValidationString.validationNoInternetFound));
//     } catch (e) {
//       if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
//         emit( const ForgotPasswordOtpVerifyFailure(errorMessage: ValidationString.validationNoInternetFound));
//       } else {
//         emit( const ForgotPasswordOtpVerifyFailure(errorMessage: ValidationString.validationInternalServerIssue));
//       }
//     }
//   }
// }