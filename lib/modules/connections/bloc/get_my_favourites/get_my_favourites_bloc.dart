import 'package:cennec/modules/connections/model/model_my_favourites.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'get_my_favourites_event.dart';
part 'get_my_favourites_state.dart';

class GetMyFavouritesBloc extends Bloc<GetMyFavouritesEvent, GetMyFavouritesState> {
  GetMyFavouritesBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetMyFavouritesInitial()) {
    on<GetMyFavourites>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      GetMyFavourites event,
      Emitter<GetMyFavouritesState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetMyFavouritesLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelMyFavourites modelMyFavourites =
      await mRepositoryConnections.getFavourites(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelMyFavourites.success == true) {
        emit(GetMyFavouritesResponse(
          modelMyFavourites: modelMyFavourites,
        ));
      } else {
        emit(GetMyFavouritesFailure(errorMessage: modelMyFavourites.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetMyFavouritesFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error = $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetMyFavouritesFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetMyFavouritesFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}