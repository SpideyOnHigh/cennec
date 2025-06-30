import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'remove_from_favourite_event.dart';
part 'remove_from_favourite_state.dart';

class RemoveFromFavouriteBloc extends Bloc<RemoveFromFavouriteEvent, RemoveFromFavouriteState> {
  RemoveFromFavouriteBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(RemoveFromFavouriteInitial()) {
    on<RemoveFromFavourite>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      RemoveFromFavourite event,
      Emitter<RemoveFromFavouriteState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(RemoveFromFavouriteLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryConnections.removeFavourite(
        event.url,
        {},
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(RemoveFromFavouriteResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        emit(RemoveFromFavouriteFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  RemoveFromFavouriteFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  RemoveFromFavouriteFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  RemoveFromFavouriteFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
