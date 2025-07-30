// bloc/contact_bloc.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../core/api_service/api_provider.dart';
import '../../../core/api_service/error_model.dart';
import '../../../core/utils/app_urls.dart';
import '../../../core/utils/common_import.dart';
import '../../model/contact_model.dart';
import '../../repository/contact_repository.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final RepositoryContacts mRepositoryContacts;
  final ApiProvider mApiProvider;
  final http.Client mClient;
  List<ContactModel> _allContacts = [];

  // URL endpoint - this should come from your config
  static const String _checkStatusEndpoint = "/contact-number-filter";
  static const String _inviteEndpoint = "/invite-contact";
  static const String _connectEndpoint = "/connect-contact";
  static const String _getContactsEndpoint = "/contacts";
  static const String _syncContactsEndpoint = "/sync-contacts";

  ContactBloc({
    required RepositoryContacts repositoryContacts,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryContacts = repositoryContacts,
        mApiProvider = apiProvider,
        mClient = client,
        super(ContactInitial()) {

    on<LoadContacts>(_onLoadContacts);
    on<RefreshContacts>(_onRefreshContacts);
    on<CheckContactStatus>(_onCheckContactStatus);
    on<SearchContacts>(_onSearchContacts);
    on<InviteContact>(_onInviteContact);
    on<ConnectWithContact>(_onConnectWithContact);
    on<UpdateContactStatus>(_onUpdateContactStatus);
    on<FilterContacts>(_onFilterContacts);
    on<ClearSearch>(_onClearSearch);
    on<SyncDeviceContacts>(_onSyncDeviceContacts);
  }

  Future<void> _onLoadContacts(
      LoadContacts event,
      Emitter<ContactState> emit,
      ) async {
    emit(ContactLoading());

    try {
      // Load contacts from device using repository method
      final contacts = await mRepositoryContacts.fetchDeviceContacts();
      _allContacts = contacts;

      emit(ContactLoaded(
        allContacts: contacts,
        filteredContacts: contacts,
        searchQuery: '',
        currentFilter: null,
        isCheckingStatus: false,
      ));

      // Check status for all contacts
      if (contacts.isNotEmpty) {
        final phoneNumbers = contacts.map((c) => c.phoneNumber).toList();
        add(CheckContactStatus(phoneNumbers));
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        emit(ContactPermissionDenied(e.toString()));
      } else {
        emit(ContactError(e.toString()));
      }
    }
  }

  Future<void> _onRefreshContacts(
      RefreshContacts event,
      Emitter<ContactState> emit,
      ) async {
    try {
      final currentState = state;
      ContactStatus? currentFilter;
      String currentSearch = '';

      if (currentState is ContactLoaded) {
        currentFilter = currentState.currentFilter;
        currentSearch = currentState.searchQuery;
        emit(currentState.copyWith(isCheckingStatus: true));
      }

      // Fetch fresh contacts from device
      final contacts = await mRepositoryContacts.fetchDeviceContacts();
      _allContacts = contacts;

      // Apply current filters
      final filteredContacts = _applyFilters(
        allContacts: contacts,
        filter: currentFilter,
        searchQuery: currentSearch,
      );

      emit(ContactLoaded(
        allContacts: contacts,
        filteredContacts: filteredContacts,
        searchQuery: currentSearch,
        currentFilter: currentFilter,
        isCheckingStatus: true,
      ));

      // Check status for all contacts
      if (contacts.isNotEmpty) {
        final phoneNumbers = contacts.map((c) => c.phoneNumber).toList();
        add(CheckContactStatus(phoneNumbers));
      }
    } catch (e) {
      emit(ContactError(e.toString(), contacts: _allContacts));
    }
  }

  Future<void> _onCheckContactStatus(
      CheckContactStatus event,
      Emitter<ContactState> emit,
      ) async {
    /// Emitting a ContactStatusChecking state.
    emit(ContactStatusChecking());

    try {
      // Prepare URL with base URL from API provider
      final url = "${AppUrls.baseUrl}$_checkStatusEndpoint";

      // Prepare body according to API specification
      final body = {
        'contacts': event.phoneNumbers,
      };

      /// This is a way to handle the response from the API call.
      ContactFilterResponse contactFilterResponse =
      await mRepositoryContacts.checkContactStatus(
        url,
        body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );

      if (contactFilterResponse.success) {
        // Update contacts with status using repository method
        final updatedContacts = await mRepositoryContacts.updateContactsWithStatus(
          _allContacts,
          contactFilterResponse,
        );

        _allContacts = updatedContacts;

        // Get current state to preserve filters
        final currentState = state;
        ContactStatus? currentFilter;
        String currentSearch = '';

        if (currentState is ContactLoaded) {
          currentFilter = currentState.currentFilter;
          currentSearch = currentState.searchQuery;
        }

        // Apply current filters to updated contacts
        final filteredContacts = _applyFilters(
          allContacts: updatedContacts,
          filter: currentFilter,
          searchQuery: currentSearch,
        );

        emit(ContactStatusCheckSuccess(
          allContacts: updatedContacts,
          filteredContacts: filteredContacts,
          searchQuery: currentSearch,
          currentFilter: currentFilter,
          contactFilterResponse: contactFilterResponse,
        ));
      } else {
        emit(ContactStatusCheckFailure(
          errorMessage:  ModelError(),
          contacts: _allContacts,
        ));
      }
    } on SocketException {
      emit(ContactStatusCheckFailure(
        errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound),
        contacts: _allContacts,
      ));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(ContactStatusCheckFailure(
          errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound),
          contacts: _allContacts,
        ));
      } else {
        emit(ContactStatusCheckFailure(
          errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue),
          contacts: _allContacts,
        ));
      }
    }
  }

  void _onSearchContacts(
      SearchContacts event,
      Emitter<ContactState> emit,
      ) {
    final currentState = state;
    if (currentState is ContactLoaded) {
      final filteredContacts = _applyFilters(
        allContacts: _allContacts,
        filter: currentState.currentFilter,
        searchQuery: event.query,
      );

      emit(currentState.copyWith(
        filteredContacts: filteredContacts,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onInviteContact(
      InviteContact event,
      Emitter<ContactState> emit,
      ) async {
    final currentState = state;
    if (currentState is! ContactLoaded) return;

    // Find the contact to get phone number
    final contact = _allContacts.firstWhere(
          (c) => c.id == event.contactId,
      orElse: () => throw Exception('Contact not found'),
    );

    emit(ContactActionLoading(
      contacts: currentState.allContacts,
      contactId: event.contactId,
      actionType: ContactActionType.invite,
    ));

    try {
      // Prepare URL with base URL from API provider
      final url = "${AppUrls.baseUrl}$_inviteEndpoint";

      // Prepare body
      final body = {
        'phoneNumber': contact.phoneNumber,
      };

      /// This is a way to handle the response from the API call.
      final success = await mRepositoryContacts.inviteContact(
        url,
        body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );

      if (success) {
        // Update contact status to invited
        final updatedContacts = _allContacts.map((c) {
          if (c.id == event.contactId) {
            return c.copyWith(status: ContactStatus.invited);
          }
          return c;
        }).toList();

        _allContacts = updatedContacts;

        // Apply current filters
        final filteredContacts = _applyFilters(
          allContacts: updatedContacts,
          filter: currentState.currentFilter,
          searchQuery: currentState.searchQuery,
        );

        emit(ContactActionSuccess(
          contacts: updatedContacts,
          contactId: event.contactId,
          actionType: ContactActionType.invite,
          message: 'Invitation sent successfully',
        ));

        // Return to loaded state with updated contacts
        emit(ContactLoaded(
          allContacts: updatedContacts,
          filteredContacts: filteredContacts,
          searchQuery: currentState.searchQuery,
          currentFilter: currentState.currentFilter,
          isCheckingStatus: false,
        ));
      } else {
        emit(ContactActionError(
          contacts: currentState.allContacts,
          contactId: event.contactId,
          actionType: ContactActionType.invite,
          message: 'Failed to send invitation',
        ));
      }
    } on SocketException {
      emit(ContactActionError(
        contacts: currentState.allContacts,
        contactId: event.contactId,
        actionType: ContactActionType.invite,
        message: ValidationString.validationNoInternetFound,
      ));
    } catch (e) {
      printWrapped("error $e");
      String errorMessage = ValidationString.validationInternalServerIssue;
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        errorMessage = ValidationString.validationNoInternetFound;
      }

      emit(ContactActionError(
        contacts: currentState.allContacts,
        contactId: event.contactId,
        actionType: ContactActionType.invite,
        message: errorMessage,
      ));
    }
  }

  Future<void> _onConnectWithContact(
      ConnectWithContact event,
      Emitter<ContactState> emit,
      ) async {
    final currentState = state;
    if (currentState is! ContactLoaded) return;

    // Find the contact to get phone number
    final contact = _allContacts.firstWhere(
          (c) => c.id == event.contactId,
      orElse: () => throw Exception('Contact not found'),
    );

    emit(ContactActionLoading(
      contacts: currentState.allContacts,
      contactId: event.contactId,
      actionType: ContactActionType.connect,
    ));

    try {
      // Prepare URL with base URL from API provider
      final url = "${AppUrls.baseUrl}$_connectEndpoint";

      // Prepare body
      final body = {
        'phoneNumber': contact.phoneNumber,
      };

      /// This is a way to handle the response from the API call.
      final success = await mRepositoryContacts.connectWithContact(
        url,
        body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );

      if (success) {
        // Update contact status to connected
        final updatedContacts = _allContacts.map((c) {
          if (c.id == event.contactId) {
            return c.copyWith(status: ContactStatus.connected);
          }
          return c;
        }).toList();

        _allContacts = updatedContacts;

        // Apply current filters
        final filteredContacts = _applyFilters(
          allContacts: updatedContacts,
          filter: currentState.currentFilter,
          searchQuery: currentState.searchQuery,
        );

        emit(ContactActionSuccess(
          contacts: updatedContacts,
          contactId: event.contactId,
          actionType: ContactActionType.connect,
          message: 'Connected successfully',
        ));

        // Return to loaded state with updated contacts
        emit(ContactLoaded(
          allContacts: updatedContacts,
          filteredContacts: filteredContacts,
          searchQuery: currentState.searchQuery,
          currentFilter: currentState.currentFilter,
          isCheckingStatus: false,
        ));
      } else {
        emit(ContactActionError(
          contacts: currentState.allContacts,
          contactId: event.contactId,
          actionType: ContactActionType.connect,
          message: 'Failed to connect',
        ));
      }
    } on SocketException {
      emit(ContactActionError(
        contacts: currentState.allContacts,
        contactId: event.contactId,
        actionType: ContactActionType.connect,
        message: ValidationString.validationNoInternetFound,
      ));
    } catch (e) {
      printWrapped("error $e");
      String errorMessage = ValidationString.validationInternalServerIssue;
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        errorMessage = ValidationString.validationNoInternetFound;
      }

      emit(ContactActionError(
        contacts: currentState.allContacts,
        contactId: event.contactId,
        actionType: ContactActionType.connect,
        message: errorMessage,
      ));
    }
  }

  void _onUpdateContactStatus(
      UpdateContactStatus event,
      Emitter<ContactState> emit,
      ) {
    final updatedContacts = _allContacts.map((contact) {
      if (contact.id == event.contactId) {
        return contact.copyWith(status: event.status);
      }
      return contact;
    }).toList();

    _allContacts = updatedContacts;

    final currentState = state;
    if (currentState is ContactLoaded) {
      final filteredContacts = _applyFilters(
        allContacts: updatedContacts,
        filter: currentState.currentFilter,
        searchQuery: currentState.searchQuery,
      );

      emit(currentState.copyWith(
        allContacts: updatedContacts,
        filteredContacts: filteredContacts,
      ));
    }
  }

  void _onFilterContacts(
      FilterContacts event,
      Emitter<ContactState> emit,
      ) {
    final currentState = state;
    if (currentState is ContactLoaded) {
      final filteredContacts = _applyFilters(
        allContacts: _allContacts,
        filter: event.status,
        searchQuery: currentState.searchQuery,
      );

      emit(currentState.copyWith(
        filteredContacts: filteredContacts,
        currentFilter: event.status,
      ));
    }
  }

  void _onClearSearch(
      ClearSearch event,
      Emitter<ContactState> emit,
      ) {
    final currentState = state;
    if (currentState is ContactLoaded) {
      final filteredContacts = _applyFilters(
        allContacts: _allContacts,
        filter: currentState.currentFilter,
        searchQuery: '',
      );

      emit(currentState.copyWith(
        filteredContacts: filteredContacts,
        searchQuery: '',
      ));
    }
  }

  Future<void> _onSyncDeviceContacts(
      SyncDeviceContacts event,
      Emitter<ContactState> emit,
      ) async {
    /// Emitting a ContactSyncLoading state.
    emit(ContactSyncLoading());

    try {
      // Prepare contact data for syncing
      final contactsData = _allContacts.map((contact) => {
        'id': contact.id,
        'name': contact.name,
        'phoneNumber': contact.phoneNumber,
        'email': contact.email,
      }).toList();

      // Prepare URL with base URL from API provider
      final url = "${AppUrls.baseUrl}$_syncContactsEndpoint";

      // Prepare body
      final body = {
        'contacts': contactsData,
      };

      /// This is a way to handle the response from the API call.
      final success = await mRepositoryContacts.syncDeviceContacts(
        url,
        body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );

      if (success) {
        emit(ContactSyncSuccess(
          message: 'Contacts synced successfully',
          contacts: _allContacts,
        ));

        // Optionally refresh contact status after sync
        final phoneNumbers = _allContacts.map((c) => c.phoneNumber).toList();
        add(CheckContactStatus(phoneNumbers));
      } else {
        emit(ContactSyncFailure(
          errorMessage: ModelError(generalError: 'Failed to sync contacts'),
          contacts: _allContacts,
        ));
      }
    } on SocketException {
      emit(ContactSyncFailure(
        errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound),
        contacts: _allContacts,
      ));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(ContactSyncFailure(
          errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound),
          contacts: _allContacts,
        ));
      } else {
        emit(ContactSyncFailure(
          errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue),
          contacts: _allContacts,
        ));
      }
    }
  }

  // Helper method to apply both filter and search
  List<ContactModel> _applyFilters({
    required List<ContactModel> allContacts,
    ContactStatus? filter,
    String searchQuery = '',
  }) {
    List<ContactModel> filtered = allContacts;

    // Apply status filter
    if (filter != null) {
      filtered = filtered.where((contact) => contact.status == filter).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((contact) {
        return contact.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            contact.phoneNumber.contains(searchQuery) ||
            (contact.email?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    return filtered;
  }

  @override
  Future<void> close() {
    mClient.close();
    return super.close();
  }
}