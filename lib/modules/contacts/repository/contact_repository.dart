import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../core/utils/common_import.dart';
import '../model/contact_model.dart';

/// This class used to API and bloc connection
/// This class is used to call the contact api and return the response in the form of ContactModel
class RepositoryContacts {
  static final RepositoryContacts _repository = RepositoryContacts._internal();

  /// `RepositoryContacts()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryContacts` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryContacts() {
    return _repository;
  }

  /// A private constructor.
  RepositoryContacts._internal();

  /// It calls the post method of the ApiProvider class and returns the contact filter response
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request containing phone numbers.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ContactFilterResponse
  Future<ContactFilterResponse> checkContactStatus(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ContactFilterResponse result = ContactFilterResponse.fromJson(jsonDecode(response));
    return result;
  }

  /// It calls the post method of the ApiProvider class to invite a contact
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request containing phone number.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   bool - Success status of invitation
  Future<bool> inviteContact(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    try {
      final response = await mApiProvider.callPostMethod(client, url, body, header);
      final responseData = jsonDecode(response);
      return responseData['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// It calls the post method of the ApiProvider class to connect with a contact
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request containing phone number.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   bool - Success status of connection
  Future<bool> connectWithContact(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    try {
      final response = await mApiProvider.callPostMethod(client, url, body, header);
      final responseData = jsonDecode(response);
      return responseData['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// It calls the get method of the ApiProvider class to get contacts list
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   List<ContactModel>
  Future<List<ContactModel>> getContacts(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    final responseData = jsonDecode(response);
    List<ContactModel> contacts = [];

    if (responseData['data'] != null) {
      for (var contactJson in responseData['data']) {
        contacts.add(ContactModel.fromJson(contactJson));
      }
    }

    return contacts;
  }

  /// It calls the post method of the ApiProvider class to sync device contacts
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request containing contacts data.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   bool - Success status of sync
  Future<bool> syncDeviceContacts(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    try {
      final response = await mApiProvider.callPostMethod(client, url, body, header);
      final responseData = jsonDecode(response);
      return responseData['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Fetch all contacts from device using flutter_contacts - This is a local operation
  ///
  /// Returns:
  ///   List<ContactModel>
  Future<List<ContactModel>> fetchDeviceContacts() async {
    try {
      // Request permission using flutter_contacts
      if (!await FlutterContacts.requestPermission()) {
        throw Exception('Contact permission denied');
      }

      // Get contacts from device with properties
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true, // Enable photos for avatar
      );

      List<ContactModel> contactList = [];

      for (Contact contact in contacts) {
        if (contact.phones.isNotEmpty) {
          String phoneNumber = _cleanPhoneNumber(contact.phones.first.number);

          if (phoneNumber.isNotEmpty) {
            // Handle avatar properly - get photo bytes
            Uint8List? avatarBytes;
            if (contact.photo != null) {
              avatarBytes = contact.photo;
            }

            contactList.add(ContactModel(
              id: contact.id,
              name: contact.displayName.isNotEmpty ? contact.displayName : 'Unknown',
              phoneNumber: phoneNumber,
              email: contact.emails.isNotEmpty
                  ? contact.emails.first.address
                  : null,
              avatar: avatarBytes,
              status: ContactStatus.notConnected,
            ));
          }
        }
      }

      return contactList;
    } catch (e) {
      throw Exception('Failed to fetch contacts: $e');
    }
  }

  /// Update contact status - This is a local operation
  ///
  /// Args:
  ///   contacts (List<ContactModel>): List of contacts to update
  ///   statusResponse (ContactFilterResponse): Status response from API
  ///
  /// Returns:
  ///   List<ContactModel>
  Future<List<ContactModel>> updateContactsWithStatus(
      List<ContactModel> contacts,
      ContactFilterResponse statusResponse,
      ) async {
    Map<String, ContactStatus> statusMap = {};

    for (ContactStatusInfo info in statusResponse.contacts) {
      statusMap[info.phoneNumber] = info.status;
    }

    return contacts.map((contact) {
      ContactStatus newStatus = statusMap[contact.phoneNumber] ?? ContactStatus.notConnected;
      return contact.copyWith(status: newStatus);
    }).toList();
  }

  /// Clean phone number - This is a utility method
  ///
  /// Args:
  ///   phoneNumber (String): Raw phone number string
  ///
  /// Returns:
  ///   String - Cleaned phone number
  String _cleanPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Handle different country code formats
    if (cleaned.startsWith('91') && cleaned.length == 12) {
      // Indian number with country code
      return cleaned.substring(2);
    } else if (cleaned.startsWith('1') && cleaned.length == 11) {
      // US number with country code
      return cleaned.substring(1);
    }

    return cleaned;
  }
}