// view/screen_notifications.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/contact/contact_bloc.dart';
import '../bloc/contact/contact_event.dart';
import '../bloc/contact/contact_state.dart';
import '../model/contact_model.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isPermissionDialogShown = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    context.read<ContactBloc>().add(LoadContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Connect',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              context.read<ContactBloc>().add(RefreshContacts());
            },
          ),
        ],
      ),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactPermissionDenied && !_isPermissionDialogShown) {
            _showPermissionDialog();
          } else if (state is ContactActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is ContactActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ContactInitial || state is ContactLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B3674)),
              ),
            );
          }

          if (state is ContactPermissionDenied) {
            return _buildPermissionDeniedView();
          }

          if (state is ContactError && state.contacts == null) {
            return _buildErrorView(state.message);
          }

          if (state is ContactLoaded ||
              state is ContactError ||
              state is ContactActionLoading ||
              state is ContactActionSuccess ||
              state is ContactActionError) {
            List<ContactModel> contacts = [];
            bool isLoading = false;
            String? loadingContactId;
            ContactActionType? actionType;

            if (state is ContactLoaded) {
              contacts = state.filteredContacts;
              isLoading = state.isCheckingStatus;
            } else if (state is ContactError) {
              contacts = state.contacts ?? [];
            } else if (state is ContactActionLoading) {
              contacts = state.contacts;
              loadingContactId = state.contactId;
              actionType = state.actionType;
            } else if (state is ContactActionSuccess) {
              contacts = state.contacts;
            } else if (state is ContactActionError) {
              contacts = state.contacts;
            }

            return Column(
              children: [
                _buildSearchHeader(isLoading),
                Expanded(
                  child: contacts.isEmpty
                      ? _buildEmptyView()
                      : _buildContactList(contacts, loadingContactId, actionType),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchHeader(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<ContactBloc>().add(SearchContacts(value));
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search contacts...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2B3674),
                borderRadius: BorderRadius.circular(22),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                onPressed: () {
                  _showFilterDialog();
                },
              ),
            ),
          ],
        ),
        if (isLoading) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B3674)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Checking contact status...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ]),
    );
  }

  Widget _buildContactList(
      List<ContactModel> contacts, String? loadingContactId, ContactActionType? actionType) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isActionLoading = loadingContactId == contact.id;

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF2B3674).withOpacity(0.1),
              backgroundImage: contact.avatar != null ? MemoryImage(contact.avatar!) : null,
              child: contact.avatar == null
                  ? Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Color(0xFF2B3674),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    )
                  : null,
            ),
            title: Text(
              contact.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  contact.phoneNumber,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (contact.email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    contact.email!,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _buildStatusChip(contact.status),
              ],
            ),
            trailing: _buildActionButton(contact, isActionLoading, actionType),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(ContactStatus status) {
    Color chipColor;
    String statusText;
    IconData icon;

    switch (status) {
      case ContactStatus.connected:
        chipColor = Colors.green;
        statusText = 'Connected';
        icon = Icons.check_circle;
        break;
      case ContactStatus.invited:
        chipColor = Colors.orange;
        statusText = 'Invited';
        icon = Icons.schedule;
        break;
      case ContactStatus.notConnected:
        chipColor = Colors.grey;
        statusText = 'Not Connected';
        icon = Icons.person_add;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: chipColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ContactModel contact, bool isLoading, ContactActionType? actionType) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            actionType == ContactActionType.invite ? Colors.blue : Colors.green,
          ),
        ),
      );
    }

    switch (contact.status) {
      case ContactStatus.notConnected:
        return ElevatedButton(
          onPressed: () {
            context.read<ContactBloc>().add(InviteContact(contact.id));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Invite',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        );
      case ContactStatus.invited:
        return ElevatedButton(
          onPressed: () {
            context.read<ContactBloc>().add(ConnectWithContact(contact.id));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Connect',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        );
      case ContactStatus.connected:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: const Text(
            'Connected',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
    }
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.contacts_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No contacts found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try refreshing or check your contact permissions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ContactBloc>().add(RefreshContacts());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B3674),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Refresh Contacts'),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Contact Permission Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To connect with your contacts, we need access to your device contacts. This helps you find friends who are already using the app.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B3674),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Open Settings'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<ContactBloc>().add(LoadContacts());
              },
              child: const Text(
                'Try Again',
                style: TextStyle(color: Color(0xFF2B3674)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<ContactBloc>().add(RefreshContacts());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B3674),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDialog() {
    setState(() {
      _isPermissionDialogShown = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Contact Permission Required',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'To help you connect with friends, we need access to your contacts. Your contact information will be kept secure and private.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isPermissionDialogShown = false;
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() {
                _isPermissionDialogShown = false;
              });
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B3674),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.people, color: Color(0xFF2B3674)),
              title: const Text('All Contacts'),
              onTap: () {
                context.read<ContactBloc>().add(FilterContacts(null));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Connected'),
              onTap: () {
                context.read<ContactBloc>().add(FilterContacts(ContactStatus.connected));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.orange),
              title: const Text('Invited'),
              onTap: () {
                context.read<ContactBloc>().add(FilterContacts(ContactStatus.invited));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.grey),
              title: const Text('Not Connected'),
              onTap: () {
                context.read<ContactBloc>().add(FilterContacts(ContactStatus.notConnected));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
