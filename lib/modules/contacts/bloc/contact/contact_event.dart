// bloc/contact_event.dart
import 'package:equatable/equatable.dart';
import '../../model/contact_model.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class LoadContacts extends ContactEvent {}

class RefreshContacts extends ContactEvent {}

class CheckContactStatus extends ContactEvent {
  final List<String> phoneNumbers;

  const CheckContactStatus(this.phoneNumbers);

  @override
  List<Object> get props => [phoneNumbers];
}

class SearchContacts extends ContactEvent {
  final String query;

  const SearchContacts(this.query);

  @override
  List<Object> get props => [query];
}

class FilterContacts extends ContactEvent {
  final ContactStatus? status;

  const FilterContacts(this.status);

  @override
  List<Object?> get props => [status];
}

class InviteContact extends ContactEvent {
  final String contactId;

  const InviteContact(this.contactId);

  @override
  List<Object> get props => [contactId];
}

class ConnectWithContact extends ContactEvent {
  final String contactId;

  const ConnectWithContact(this.contactId);

  @override
  List<Object> get props => [contactId];
}

class UpdateContactStatus extends ContactEvent {
  final String contactId;
  final ContactStatus status;

  const UpdateContactStatus({
    required this.contactId,
    required this.status,
  });

  @override
  List<Object> get props => [contactId, status];
}

class ClearSearch extends ContactEvent {}

class SyncDeviceContacts extends ContactEvent {}

// Enum for contact action types
enum ContactActionType {
  invite,
  connect,
}