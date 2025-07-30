// bloc/contact_state.dart
import 'package:equatable/equatable.dart';
import '../../../core/api_service/error_model.dart';
import '../../model/contact_model.dart';
import 'contact_event.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<ContactModel> allContacts;
  final List<ContactModel> filteredContacts;
  final String searchQuery;
  final ContactStatus? currentFilter;
  final bool isCheckingStatus;

  const ContactLoaded({
    required this.allContacts,
    required this.filteredContacts,
    this.searchQuery = '',
    this.currentFilter,
    this.isCheckingStatus = false,
  });

  ContactLoaded copyWith({
    List<ContactModel>? allContacts,
    List<ContactModel>? filteredContacts,
    String? searchQuery,
    ContactStatus? currentFilter,
    bool? isCheckingStatus,
  }) {
    return ContactLoaded(
      allContacts: allContacts ?? this.allContacts,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      currentFilter: currentFilter ?? this.currentFilter,
      isCheckingStatus: isCheckingStatus ?? this.isCheckingStatus,
    );
  }

  @override
  List<Object?> get props => [
    allContacts,
    filteredContacts,
    searchQuery,
    currentFilter,
    isCheckingStatus,
  ];
}

class ContactPermissionDenied extends ContactState {
  final String message;

  const ContactPermissionDenied(this.message);

  @override
  List<Object> get props => [message];
}

class ContactError extends ContactState {
  final String message;
  final List<ContactModel>? contacts;

  const ContactError(this.message, {this.contacts});

  @override
  List<Object?> get props => [message, contacts];
}

// Contact Status Check States
class ContactStatusChecking extends ContactState {}

class ContactStatusCheckSuccess extends ContactState {
  final List<ContactModel> allContacts;
  final List<ContactModel> filteredContacts;
  final String searchQuery;
  final ContactStatus? currentFilter;
  final ContactFilterResponse contactFilterResponse;

  const ContactStatusCheckSuccess({
    required this.allContacts,
    required this.filteredContacts,
    this.searchQuery = '',
    this.currentFilter,
    required this.contactFilterResponse,
  });

  ContactStatusCheckSuccess copyWith({
    List<ContactModel>? allContacts,
    List<ContactModel>? filteredContacts,
    String? searchQuery,
    ContactStatus? currentFilter,
    ContactFilterResponse? contactFilterResponse,
  }) {
    return ContactStatusCheckSuccess(
      allContacts: allContacts ?? this.allContacts,
      filteredContacts: filteredContacts ?? this.filteredContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      currentFilter: currentFilter ?? this.currentFilter,
      contactFilterResponse: contactFilterResponse ?? this.contactFilterResponse,
    );
  }

  @override
  List<Object?> get props => [
    allContacts,
    filteredContacts,
    searchQuery,
    currentFilter,
    contactFilterResponse,
  ];
}

class ContactStatusCheckFailure extends ContactState {
  final ModelError errorMessage;
  final List<ContactModel> contacts;

  const ContactStatusCheckFailure({
    required this.errorMessage,
    required this.contacts,
  });

  @override
  List<Object> get props => [errorMessage, contacts];
}

// Contact Sync States
class ContactSyncLoading extends ContactState {}

class ContactSyncSuccess extends ContactState {
  final String message;
  final List<ContactModel> contacts;

  const ContactSyncSuccess({
    required this.message,
    required this.contacts,
  });

  @override
  List<Object> get props => [message, contacts];
}

class ContactSyncFailure extends ContactState {
  final ModelError errorMessage;
  final List<ContactModel> contacts;

  const ContactSyncFailure({
    required this.errorMessage,
    required this.contacts,
  });

  @override
  List<Object> get props => [errorMessage, contacts];
}

// Contact Action States (existing)
class ContactActionLoading extends ContactState {
  final List<ContactModel> contacts;
  final String contactId;
  final ContactActionType actionType;

  const ContactActionLoading({
    required this.contacts,
    required this.contactId,
    required this.actionType,
  });

  @override
  List<Object> get props => [contacts, contactId, actionType];
}

class ContactActionSuccess extends ContactState {
  final List<ContactModel> contacts;
  final String contactId;
  final ContactActionType actionType;
  final String message;

  const ContactActionSuccess({
    required this.contacts,
    required this.contactId,
    required this.actionType,
    required this.message,
  });

  @override
  List<Object> get props => [contacts, contactId, actionType, message];
}

class ContactActionError extends ContactState {
  final List<ContactModel> contacts;
  final String contactId;
  final ContactActionType actionType;
  final String message;

  const ContactActionError({
    required this.contacts,
    required this.contactId,
    required this.actionType,
    required this.message,
  });

  @override
  List<Object> get props => [contacts, contactId, actionType, message];
}