import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/common_import.dart';


part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  FavouritesBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(FavouritesInitial()) {
    on<AddToFavourites>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      AddToFavourites event,
      Emitter<FavouritesState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(FavouritesLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryConnections.addToFavourites(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(FavouritesResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        printWrapped("errrrr");
        emit(FavouritesFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  FavouritesFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  FavouritesFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  FavouritesFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}