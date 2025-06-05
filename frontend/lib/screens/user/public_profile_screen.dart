import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  User? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Loads the current user's profile from the backend
  Future<void> _loadUserProfile() async {
    try {
      final fbUser = fb_auth.FirebaseAuth.instance.currentUser;
      if (fbUser == null) {
        setState(() {
          _error = 'Usuario no autenticado.';
          _isLoading = false;
        });
        return;
      }
      final userData = await UserService.fetchUserByFirebaseUid(fbUser.uid);
      setState(() {
        _user = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar el perfil.';
        _isLoading = false;
      });
    }
  }

  // Builds a styled info row with icon, label, and value (for each user field)
  Widget _buildInfoBox(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: AppColors.deepGreen.withAlpha((0.25 * 255).round()),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.deepGreen, size: 28),
          const SizedBox(width: 18),
          Text(
            '$label:',
            style: TextStyle(
              color: AppColors.terracotta,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.deepGreen, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  // Navigates to the Edit Profile screen, passing all necessary arguments
  Future<void> _goToEditProfile() async {
    if (_user == null) return;

    // Get the user's bearer token from Firebase Auth (for secure API access)
    final fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    final String? bearerToken = await fbUser?.getIdToken();

    if (bearerToken == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo autenticar al usuario.')),
      );
      return;
    }

    // Navigate to EditProfileScreen, passing the user, userId and bearerToken
    if (!mounted) return;
    final result = await Navigator.pushNamed(
      context,
      '/edit-profile',
      arguments: {
        'user': _user!,
        'userId': _user!.userId,
        'bearerToken': bearerToken,
      },
    );
    if (!mounted) return;

    // If profile was successfully updated, reload the profile data
    if (result == true) {
      _loadUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        centerTitle: true,
        title: const Text(
          'Perfil público',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: _isLoading
          // Show loading spinner while loading
          ? const Center(child: CircularProgressIndicator())
          // Show error if occurred
          : _error != null
          ? Center(
              child: Text(
                _error!,
                style: TextStyle(color: AppColors.terracotta, fontSize: 18),
              ),
            )
          // If user data is missing, show info
          : _user == null
          ? Center(
              child: Text(
                'Perfil no disponible.',
                style: TextStyle(color: AppColors.terracotta, fontSize: 18),
              ),
            )
          // Main profile UI
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile photo and name
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: AppColors.softGreen,
                        backgroundImage: _user!.userProfilePicture.isNotEmpty
                            ? NetworkImage(_user!.userProfilePicture)
                            : null,
                        child: _user!.userProfilePicture.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 72,
                                color: AppColors.deepGreen,
                              )
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_user!.userFirstName} ${_user!.userLastName}',
                              style: TextStyle(
                                color: AppColors.deepGreen,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _user!.userRole,
                              style: TextStyle(
                                color: AppColors.terracotta,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Info boxes for each field
                  _buildInfoBox(
                    Icons.email_outlined,
                    'Email',
                    _user!.userEmail,
                  ),
                  _buildInfoBox(
                    Icons.phone_outlined,
                    'Teléfono',
                    _user!.userPhoneNumber,
                  ),
                  _buildInfoBox(
                    Icons.location_on_outlined,
                    'Dirección',
                    _user!.userAddress,
                  ),
                  _buildInfoBox(
                    Icons.cake_outlined,
                    'Fecha de nacimiento',
                    _user!.userBirthDate.toLocal().toIso8601String().split(
                      'T',
                    )[0],
                  ),
                  const SizedBox(height: 30),
                  // Edit profile button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _goToEditProfile,
                      icon: const Icon(Icons.edit, color: AppColors.terracotta),
                      label: const Text(
                        'Editar perfil',
                        style: TextStyle(
                          color: AppColors.deepGreen,
                          fontSize: 20,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
