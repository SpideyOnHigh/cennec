import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/interests/model/model_add_or_remove_interests.dart';
import 'package:cennec/modules/interests/repository/interests_repository.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'add_remove_interests_event.dart';
part 'add_remove_interests_state.dart';

class AddRemoveInterestsBloc extends Bloc<AddRemoveInterestsEvent, AddRemoveInterestsState> {
  AddRemoveInterestsBloc({
    required RepositoryInterests repositoryInterests,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryInterests = repositoryInterests,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddRemoveInterestsInitial()) {
    on<AddRemoveInterests>(updateInterests);
  }

  final RepositoryInterests mRepositoryInterests;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateInterests(
      AddRemoveInterests event,
      Emitter<AddRemoveInterestsState> emit,
      ) async {
    /// Emitting an InterestsLoading state.
    emit(AddRemoveInterestsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelAddOrRemoveInterests modelAddOrRemoveInterests =
      await mRepositoryInterests.addRemoveInts(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelAddOrRemoveInterests.success == true) {
        emit(AddRemoveInterestsResponse(
          modelAddOrRemoveInterests: modelAddOrRemoveInterests,
        ));
      } else {
        emit(AddRemoveInterestsFailure(errorMessage: modelAddOrRemoveInterests.error ?? ModelError()));
      }
    } on SocketException {
      emit( AddRemoveInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  AddRemoveInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  AddRemoveInterestsFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}