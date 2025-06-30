import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/profile/model/ImageUploadResponse.dart';
import 'package:equatable/equatable.dart';

import '../../../core/api_service/api_provider.dart';
import '../../../core/api_service/common_service.dart';
import '../../../core/utils/validation_string.dart';
import '../../model/profile_picture_model.dart';
import 'package:http/http.dart' as http;

import '../../repository/repository_profile.dart';

part 'post_profile_picture_event.dart';
part 'post_profile_picture_state.dart';

class PostProfilePictureBloc extends Bloc<PostProfilePictureEvent, PostProfilePictureState> {
  PostProfilePictureBloc({
    required RepositoryProfile repositoryProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryProfile = repositoryProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(PostProfilePictureInitial()) {
    on<PostProfilePictureApi>(updateProfileImage);
  }

  final RepositoryProfile mRepositoryProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateProfileImage(
      PostProfilePictureApi event,
      Emitter<PostProfilePictureState> emit,
      ) async {
    /// Emitting an ProfileLoading state.
    emit(PostProfilePictureLoading());
    try {
      /// This is a way to handle the response from the API call.
      ImageUploadResponse modelUserEditProfilePrefs =
      await mRepositoryProfile.callPostMethodWithImage(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        event.body,
        mApiProvider,
        mClient,
        event.imageList
      );
      if (modelUserEditProfilePrefs.success == true) {
        emit(PostProfilePictureResponse(response: modelUserEditProfilePrefs));
      } else {
        emit(PostProfilePictureFailure(error: modelUserEditProfilePrefs.error ?? ModelError()));
      }
    } on SocketException {
      emit( PostProfilePictureFailure(error: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  PostProfilePictureFailure(error: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  PostProfilePictureFailure(error:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
