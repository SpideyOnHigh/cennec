// model/contact_model.dart
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

enum ContactStatus {
  connected,
  invited,
  notConnected;

  static ContactStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return ContactStatus.connected;
      case 'invited':
        return ContactStatus.invited;
      case 'not_connected':
      case 'notconnected':
        return ContactStatus.notConnected;
      default:
        return ContactStatus.notConnected;
    }
  }

  String get displayName {
    switch (this) {
      case ContactStatus.connected:
        return 'Connected';
      case ContactStatus.invited:
        return 'Invited';
      case ContactStatus.notConnected:
        return 'Not Connected';
    }
  }
}

class ContactModel extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final Uint8List? avatar;
  final ContactStatus status;

  const ContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.avatar,
    this.status = ContactStatus.notConnected,
  });

  ContactModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    Uint8List? avatar,
    ContactStatus? status,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
    );
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone_number'] ?? '',
      email: json['email'],
      avatar: json['avatar'] != null
          ? Uint8List.fromList(json['avatar'].cast<int>())
          : null,
      status: ContactStatus.fromString(json['status'] ?? 'not_connected'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'avatar': avatar?.toList(),
      'status': status.name,
    };
  }

  @override
  List<Object?> get props => [id, name, phoneNumber, email, avatar, status];
}

class ContactStatusInfo extends Equatable {
  final String phoneNumber;
  final ContactStatus status;

  const ContactStatusInfo({
    required this.phoneNumber,
    required this.status,
  });

  factory ContactStatusInfo.fromJson(Map<String, dynamic> json) {
    return ContactStatusInfo(
      phoneNumber: json['phoneNumber'] ?? json['phone_number'] ?? '',
      status: ContactStatus.fromString(json['status'] ?? 'not_connected'),
    );
  }

  @override
  List<Object> get props => [phoneNumber, status];
}

class ContactFilterResponse extends Equatable {
  final List<ContactStatusInfo> contacts;
  final bool success;
  final String? message;

  const ContactFilterResponse({
    required this.contacts,
    this.success = true,
    this.message,
  });

  factory ContactFilterResponse.fromJson(Map<String, dynamic> json) {
    List<ContactStatusInfo> contacts = [];

    if (json['data'] != null && json['data'] is List) {
      contacts = (json['data'] as List)
          .map((contact) => ContactStatusInfo.fromJson(contact))
          .toList();
    } else if (json['contacts'] != null && json['contacts'] is List) {
      contacts = (json['contacts'] as List)
          .map((contact) => ContactStatusInfo.fromJson(contact))
          .toList();
    }

    return ContactFilterResponse(
      contacts: contacts,
      success: json['success'] ?? true,
      message: json['message'],
    );
  }

  @override
  List<Object?> get props => [contacts, success, message];
}