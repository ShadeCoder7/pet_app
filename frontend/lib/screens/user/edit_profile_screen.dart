import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../utils/app_colors.dart';
import '../../services/user_service.dart';
import 'package:intl/intl.dart';

// EditProfileScreen allows the user to update their profile (PATCH, partial update)
class EditProfileScreen extends StatefulWidget {
  final User user; // Full user object to edit
  final String userId; // ID to PATCH
  final String bearerToken; // Auth token

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.userId,
    required this.bearerToken,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for user input fields
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  DateTime? _selectedBirthDate;
  String? _profilePictureUrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.user.userFirstName,
    );
    _lastNameController = TextEditingController(text: widget.user.userLastName);
    _phoneController = TextEditingController(text: widget.user.userPhoneNumber);
    _addressController = TextEditingController(text: widget.user.userAddress);
    _selectedBirthDate = widget.user.userBirthDate;
    _profilePictureUrl = widget.user.userProfilePicture;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Send PATCH request to update user's profile (only changed fields)
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> updates = {};

    // Only add fields that have changed
    if (_firstNameController.text.trim() != widget.user.userFirstName) {
      updates['userFirstName'] = _firstNameController.text.trim();
    }
    if (_lastNameController.text.trim() != widget.user.userLastName) {
      updates['userLastName'] = _lastNameController.text.trim();
    }
    if (_phoneController.text.trim() != widget.user.userPhoneNumber) {
      updates['userPhoneNumber'] = _phoneController.text.trim();
    }
    if (_addressController.text.trim() != widget.user.userAddress) {
      updates['userAddress'] = _addressController.text.trim();
    }
    // userBirthDate and userProfilePicture are not editable here

    if (updates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No has realizado ningún cambio.')),
      );
      return;
    }

    // Confirm before saving
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar cambios'),
        content: const Text(
          '¿Estás seguro de que quieres guardar los cambios en tu perfil?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSaving = true);

    try {
      // PATCH user profile
      await UserService.patchUserProfile(
        widget.userId,
        updates,
        widget.bearerToken,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil actualizado correctamente.'),
          backgroundColor: AppColors.deepGreen,
        ),
      );
      Navigator.of(context).pop(true); // Return true to refresh profile
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar el perfil: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Shows a SnackBar when trying to change profile picture
  Future<void> _showNotAvailableFeature() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Esta funcionalidad estará disponible próximamente.'),
        backgroundColor: AppColors.terracotta,
      ),
    );
  }

  // Handles cancel action: shows confirmation and closes the screen if confirmed
  void _handleCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar edición'),
        content: const Text('¿Seguro que quieres descartar los cambios?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(
        context,
      ).pop(false); // Cierra la pantalla y no guarda cambios
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
          'Editar perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.1,
          ),
        ),
        // No close (X) button in actions
      ),
      body: GestureDetector(
        onTap: () {
          // Hide keyboard when tapping outside any field
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: _isSaving
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile picture and edit icon
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 58,
                                backgroundColor: AppColors.softGreen,
                                backgroundImage:
                                    (_profilePictureUrl != null &&
                                        _profilePictureUrl!.isNotEmpty)
                                    ? NetworkImage(_profilePictureUrl!)
                                    : null,
                                child:
                                    (_profilePictureUrl == null ||
                                        _profilePictureUrl!.isEmpty)
                                    ? Icon(
                                        Icons.person,
                                        color: AppColors.deepGreen,
                                        size: 68,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _showNotAvailableFeature,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.deepGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(7),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // First name field
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.deepGreen,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(100),
                                width: 1.1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(70),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.deepGreen.withAlpha(180),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'El nombre es obligatorio.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // Last name field
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.deepGreen,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(100),
                                width: 1.1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(70),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.deepGreen.withAlpha(180),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Los apellidos son obligatorios.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // Phone number field
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: AppColors.deepGreen,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(100),
                                width: 1.1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(70),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.deepGreen.withAlpha(180),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return null;
                            final phoneReg = RegExp(r'^[0-9+\-\s]{7,15}$');
                            if (!phoneReg.hasMatch(val.trim())) {
                              return 'Introduce un número de teléfono válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Address field
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Dirección',
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: AppColors.deepGreen,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(100),
                                width: 1.1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(70),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.deepGreen.withAlpha(180),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Birth date field (disabled)
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Fecha de nacimiento',
                            prefixIcon: Icon(
                              Icons.cake,
                              color: AppColors.deepGreen.withAlpha(140),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppColors.softGreen.withAlpha(60),
                                width: 1,
                              ),
                            ),
                          ),
                          controller: TextEditingController(
                            text: _selectedBirthDate != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(_selectedBirthDate!)
                                : '',
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Save and Cancel buttons in a column (vertical layout, avoids overflow)
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Guardar cambios',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.deepGreen,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 22,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: _isSaving ? null : _saveProfile,
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                icon: Icon(
                                  Icons.cancel,
                                  color: AppColors.terracotta,
                                ),
                                label: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    color: AppColors.terracotta,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  side: BorderSide(
                                    color: AppColors.terracotta,
                                    width: 1.5,
                                  ),
                                ),
                                onPressed: _isSaving ? null : _handleCancel,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
