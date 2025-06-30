import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/preferences/model/model_report.dart';
import 'package:cennec/modules/preferences/repository/repository_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'report_user_event.dart';
part 'report_user_state.dart';

class ReportUserBloc extends Bloc<ReportUserEvent, ReportUserState> {
  ReportUserBloc({
    required RepositoryPreferences repositoryPreferences,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryPreferences = repositoryPreferences,
        mApiProvider = apiProvider,
        mClient = client,
        super(ReportUserInitial()) {
    on<ReportUser>(updatePreferences);
  }

  final RepositoryPreferences mRepositoryPreferences;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updatePreferences(
      ReportUser event,
      Emitter<ReportUserState> emit,
      ) async {
    /// Emitting an PreferencesLoading state.
    emit(ReportUserLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelReport modelReport =
      await mRepositoryPreferences.reportUser(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelReport.success == true) {
        emit(ReportUserResponse(
          modelReport: modelReport,
        ));
      } else {
        emit(ReportUserFailure(errorMessage: modelReport.error ?? ModelError()));
      }
    } on SocketException {
      emit( ReportUserFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  ReportUserFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  ReportUserFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}