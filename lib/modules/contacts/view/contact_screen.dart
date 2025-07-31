// view/screen_notifications.dart
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/contact/contact_bloc.dart';
import '../bloc/contact/contact_event.dart';
import '../bloc/contact/contact_state.dart';
import '../model/contact_model.dart';

class ContactScreen extends StatefulWidget {
  final Function()? onContinueTap;
  const ContactScreen({Key? key, this.onContinueTap}) : super(key: key);

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

    // Add listener to update UI when text changes
    _searchController.addListener(() {
      setState(() {});
    });
  }

  void _loadContacts() {
    context.read<ContactBloc>().add(LoadContacts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        // Handle permission denied
        if (state is ContactPermissionDenied && !_isPermissionDialogShown) {
          _showPermissionDialog();
        }

        // Handle success messages
        if (state is ContactActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Handle error messages
        if (state is ContactActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Handle status check success - automatically transition to ContactLoaded
        if (state is ContactStatusCheckSuccess) {
          // The BLoC should handle this transition, but we can add any UI-specific logic here
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Cennec with Contacts',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: () {
                  context.read<ContactBloc>().add(RefreshContacts());
                },
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            child: CommonButton(
              text: "Continue",
              onTap: widget.onContinueTap,
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ContactState state) {
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

    if (state is ContactError && (state.contacts?.isEmpty ?? true)) {
      return _buildErrorView(state.message);
    }

    // Handle loaded states (including ContactStatusCheckSuccess)
    if (state is ContactLoaded || state is ContactStatusCheckSuccess) {
      List<ContactModel> contacts = [];
      bool isCheckingStatus = false;
      String currentSearch = '';

      if (state is ContactLoaded) {
        contacts = state.filteredContacts;
        isCheckingStatus = state.isCheckingStatus;
        currentSearch = state.searchQuery;
      } else if (state is ContactStatusCheckSuccess) {
        contacts = state.filteredContacts;
        isCheckingStatus = false;
        currentSearch = state.searchQuery;
      }

      return Column(
        children: [
          // _buildSearchHeader(isCheckingStatus, currentSearch),
          Expanded(
            child: contacts.isEmpty
                ? _buildEmptyView()
                : _buildContactList(contacts, state),
          ),
        ],
      );
    }

    // Handle action loading states
    if (state is ContactActionLoading) {
      return Column(
        children: [
          // _buildSearchHeader(false, ''),
          Expanded(
            child: _buildContactList(state.contacts, state),
          ),
        ],
      );
    }

    // Handle status checking
    if (state is ContactStatusChecking) {
      return Column(
        children: [
          // _buildSearchHeader(true, ''),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B3674)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Checking contact status...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return _buildEmptyView();
  }

  Widget _buildSearchHeader(bool isLoading, String currentSearch) {
    // Update search controller if the search query changed from BLoC
    if (_searchController.text != currentSearch) {
      _searchController.text = currentSearch;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.colorRoundedBgContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    onSubmitted: (value) {
                      // Search when user presses Enter
                      context.read<ContactBloc>().add(SearchContacts(value));
                    },
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ContactBloc>().add(ClearSearch());
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                  icon: const Icon(Icons.search, color: Colors.white, size: 20),
                  onPressed: () {
                    // Trigger search when button is pressed
                    context.read<ContactBloc>().add(SearchContacts(_searchController.text));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
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
        ],
      ),
    );
  }

  Widget _buildContactList(List<ContactModel> contacts, ContactState state) {
    String? loadingContactId;
    ContactActionType? actionType;

    if (state is ContactActionLoading) {
      loadingContactId = state.contactId;
      actionType = state.actionType;
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isActionLoading = loadingContactId == contact.id;

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF2B3674).withOpacity(0.1),
              backgroundImage: contact.avatar != null
                  ? MemoryImage(contact.avatar!)
                  : null,
              child: contact.avatar == null
                  ? Text(
                contact.name.isNotEmpty
                    ? contact.name[0].toUpperCase()
                    : '?',
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
                // if (contact.email != null) ...[
                //   const SizedBox(height: 2),
                //   Text(
                //     contact.email!,
                //     style: TextStyle(
                //       color: Colors.grey[500],
                //       fontSize: 12,
                //     ),
                //   ),
                // ],
                // const SizedBox(height: 8),
                // _buildStatusChip(contact.status),
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

  Widget _buildActionButton(
      ContactModel contact,
      bool isLoading,
      ContactActionType? actionType,
      ) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.colorPrimary,
          ),
        ),
      );
    }

    // Check if contact exists (invited) or not (not connected)
    if (contact.isInvited == true) {
      // Contact exists - show Connect button
      return ElevatedButton(
        onPressed: () {
          context.read<ContactBloc>().add(ConnectWithContact(contact.id));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppColors.colorPrimary),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Connect',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.colorPrimary,
          ),
        ),
      );
    } else {
      // Contact doesn't exist - show Invite button
      return ElevatedButton(
        onPressed: () {
          context.read<ContactBloc>().add(InviteContact(contact.id));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppColors.colorPrimary),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Invite',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.colorPrimary,
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