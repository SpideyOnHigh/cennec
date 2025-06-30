import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
import '../../repository/interests_repository.dart';


part 'get_interests_lists_event.dart';
part 'get_interests_lists_state.dart';

class GetInterestsListsBloc extends Bloc<GetInterestsListsEvent, GetInterestsListsState> {
  GetInterestsListsBloc({
    required RepositoryInterests repositoryInterests,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryInterests = repositoryInterests,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetInterestsListsInitial()) {
    on<GetInterestsLists>(_getInterests);
  }

  final RepositoryInterests mRepositoryInterests;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getInterests(
      GetInterestsLists event,
      Emitter<GetInterestsListsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetInterestsListsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelInterestsList modelInterestsList =
      await mRepositoryInterests.getInterests(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelInterestsList.success == true) {
        emit(GetInterestsListsResponse(
          modelInterestsList: modelInterestsList,
        ));
      } else {
        emit(GetInterestsListsFailure(errorMessage: modelInterestsList.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetInterestsListsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetInterestsListsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetInterestsListsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}