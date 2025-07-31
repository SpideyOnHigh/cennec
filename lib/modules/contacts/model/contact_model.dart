// model/contact_model.dart
import 'dart:typed_data';
import 'package:cennec/modules/core/utils/parsing_helper.dart';
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
  final bool isInvited;

  const ContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.avatar,
    this.status = ContactStatus.notConnected,
    this.isInvited = false
  });

  ContactModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    Uint8List? avatar,
    ContactStatus? status,
    bool? isInvited,
  }) {
    return ContactModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        status: status ?? this.status,
        isInvited: isInvited ?? this.isInvited
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
      isInvited: ParsingHelper.parseBoolMethod(json['exists']),
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
      "exists": isInvited
    };
  }

  @override
  List<Object?> get props => [id, name, phoneNumber, email, avatar, status, isInvited];
}

class ContactStatusInfo extends Equatable {
  final String phoneNumber;
  final ContactStatus status;
  final bool exists; // Added to match API response

  const ContactStatusInfo({
    required this.phoneNumber,
    required this.status,
    required this.exists,
  });

  factory ContactStatusInfo.fromJson(Map<String, dynamic> json) {
    final exists = json['exists'] ?? false;

    return ContactStatusInfo(
      phoneNumber: json['contact'] ?? json['phoneNumber'] ?? json['phone_number'] ?? '',
      exists: exists,
      status: exists ? ContactStatus.invited : ContactStatus.notConnected,
    );
  }

  @override
  List<Object> get props => [phoneNumber, status, exists];
}

class ContactFilterResponse extends Equatable {
  final List<ContactStatusInfo> contacts;
  final bool success;
  final String? message;
  final int? code;

  const ContactFilterResponse({
    required this.contacts,
    this.success = true,
    this.message,
    this.code,
  });

  factory ContactFilterResponse.fromJson(Map<String, dynamic> json) {
    List<ContactStatusInfo> contacts = [];

    // Handle the API response structure: {"code":200,"message":"...","data":[{"contact":"7874519680","exists":false}]}
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
      success: json['code'] == 200 || json['success'] == true,
      message: json['message'],
      code: json['code'],
    );
  }

  @override
  List<Object?> get props => [contacts, success, message, code];
}