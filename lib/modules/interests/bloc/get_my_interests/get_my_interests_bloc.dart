import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
import '../../repository/interests_repository.dart';

part 'get_my_interests_event.dart';
part 'get_my_interests_state.dart';

class GetMyInterestsBloc extends Bloc<GetMyInterestsEvent, GetMyInterestsState> {
  GetMyInterestsBloc({
    required RepositoryInterests repositoryInterests,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryInterests = repositoryInterests,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetMyInterestsInitial()) {
    on<GetMyInterests>(_getInterests);
  }

  final RepositoryInterests mRepositoryInterests;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getInterests(
      GetMyInterests event,
      Emitter<GetMyInterestsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetMyInterestsLoading());
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
        emit(GetMyInterestsResponse(
          modelInterestsList: modelInterestsList,
        ));
      } else {
        emit(GetMyInterestsFailure(errorMessage: modelInterestsList.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetMyInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetMyInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetMyInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}