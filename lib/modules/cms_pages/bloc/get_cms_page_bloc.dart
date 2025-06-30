import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cennec/modules/cms_pages/repository/repository_cms.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:cennec/modules/core/api_service/api_provider.dart';
import 'package:cennec/modules/core/api_service/common_service.dart';
import 'package:cennec/modules/core/utils/validation_string.dart';
import 'package:http/http.dart' as http;


part 'get_cms_page_event.dart';
part 'get_cms_page_state.dart';

class GetCmsPageBloc extends Bloc<GetCmsPageEvent, GetCmsPageState> {
  GetCmsPageBloc({
    required RepositoryGetCmsPage repositoryGetCmsPage,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryGetCmsPage = repositoryGetCmsPage,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetCmsPageInitial()) {
    on<GetCmsPage>(_getGetCmsPage);
  }

  final RepositoryGetCmsPage mRepositoryGetCmsPage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getGetCmsPage(
      GetCmsPage event,
      Emitter<GetCmsPageState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetCmsPageLoading());
    try {
      /// This is a way to handle the response from the API call.
      String modelGetCmsPageList =
      await mRepositoryGetCmsPage.getPage(
        event.url,
        await mApiProvider.getHeaderValue(),
        mApiProvider,
        mClient,
      );
      if (modelGetCmsPageList.isNotEmpty) {
        emit(GetCmsPageResponse(
          modelCms: modelGetCmsPageList,
        ));
      } else {
        emit(GetCmsPageFailure(errorMessage: ModelError()));
      }
    } on SocketException {
      emit(  GetCmsPageFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetCmsPageFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetCmsPageFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}