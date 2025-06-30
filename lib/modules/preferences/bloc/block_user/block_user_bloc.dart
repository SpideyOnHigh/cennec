import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/preferences/model/model_block.dart';
import 'package:cennec/modules/preferences/repository/repository_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
part 'block_user_event.dart';
part 'block_user_state.dart';

class BlockUserBloc extends Bloc<BlockUserEvent, BlockUserState> {
  BlockUserBloc({
    required RepositoryPreferences repositoryPreferences,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryPreferences = repositoryPreferences,
        mApiProvider = apiProvider,
        mClient = client,
        super(BlockUserInitial()) {
    on<BlockUser>(updatePreferences);
  }

  final RepositoryPreferences mRepositoryPreferences;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updatePreferences(
      BlockUser event,
      Emitter<BlockUserState> emit,
      ) async {
    /// Emitting an PreferencesLoading state.
    emit(BlockUserLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelBlockResponse modelBlockResponse =
      await mRepositoryPreferences.blockUser(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelBlockResponse.success == true) {
        emit(BlockUserResponse(
          modelBlockResponse: modelBlockResponse,
        ));
      } else {
        emit(BlockUserFailure(errorMessage: modelBlockResponse.error ?? ModelError()));
      }
    } on SocketException {
      emit( BlockUserFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  BlockUserFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  BlockUserFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}