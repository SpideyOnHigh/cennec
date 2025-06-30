import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/interests/model/model_update_interests.dart';
import 'package:cennec/modules/interests/repository/interests_repository.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'update_user_interests_event.dart';
part 'update_user_interests_state.dart';

class UpdateUserInterestsBloc extends Bloc<UpdateUserInterestsEvent, UpdateUserInterestsState> {
  UpdateUserInterestsBloc({
    required RepositoryInterests repositoryInterests,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryInterests = repositoryInterests,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdateUserInterestsInitial()) {
    on<UpdateUserInterests>(_updateInterests);
  }

  final RepositoryInterests mRepositoryInterests;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _updateInterests(
      UpdateUserInterests event,
      Emitter<UpdateUserInterestsState> emit,
      ) async {
    /// Emitting an InterestsLoading state.
    emit(UpdateUserInterestsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelUpdateInterests modelUpdateInterests =
      await mRepositoryInterests.updateInterests(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelUpdateInterests.success == true) {
        emit(UpdateUserInterestsResponse(
          modelUpdateInterests: modelUpdateInterests,
        ));
      } else {
        emit(UpdateUserInterestsFailure(errorMessage: modelUpdateInterests.error ?? ModelError()));
      }
    } on SocketException {
      emit( UpdateUserInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  UpdateUserInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  UpdateUserInterestsFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}