import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/cms_pages/repository/repository_cms.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/common_import.dart';

part 'user_readed_about_us_event.dart';
part 'user_readed_about_us_state.dart';

class UserReadedAboutUsBloc extends Bloc<UserReadedAboutUsEvent, UserReadedAboutUsState> {
  UserReadedAboutUsBloc({
    required RepositoryGetCmsPage repositoryGetCmsPage,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryGetCmsPage = repositoryGetCmsPage,
        mApiProvider = apiProvider,
        mClient = client,
        super(UserReadedAboutUsInitial()) {
    on<UserReadedAboutUs>(_getUserReadedAboutUs);
  }

  final RepositoryGetCmsPage mRepositoryGetCmsPage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getUserReadedAboutUs(
      UserReadedAboutUs event,
      Emitter<UserReadedAboutUsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(UserReadedAboutUsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryGetCmsPage.postUserAcceptedPolicy(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(UserReadedAboutUsResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        emit(UserReadedAboutUsFailure(errorMessage: ModelError()));
      }
    } on SocketException {
      emit(  UserReadedAboutUsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  UserReadedAboutUsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  UserReadedAboutUsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}