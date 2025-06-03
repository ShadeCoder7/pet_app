import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

// Foster home request form with consistent app style
class FosterHomeRequestScreen extends StatefulWidget {
  final String? userId; // Optional, pass if you want to relate to a user

  const FosterHomeRequestScreen({super.key, this.userId});

  @override
  State<FosterHomeRequestScreen> createState() =>
      _FosterHomeRequestScreenState();
}

class _FosterHomeRequestScreenState extends State<FosterHomeRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isSubmitting = false;

  // Handles form submission
  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Here, you would call your backend service to send the foster home request

    // For now, just show success message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('¡Solicitud enviada con éxito!')));
    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Solicitud Casa de Acogida',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        // This GestureDetector allows to dismiss the keyboard when tapping outside input fields
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            children: [
              // Visual header with icon, title, and description
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepGreen.withAlpha(
                        (0.11 * 255).toInt(),
                      ),
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.softGreen.withAlpha((0.38 * 255).toInt()),
                    width: 1.1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 18,
                ),
                margin: const EdgeInsets.only(bottom: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: AppColors.softGreen,
                      size: 56,
                    ),
                    const SizedBox(height: 13),
                    Text(
                      '¡Hazte Casa de Acogida!',
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 23,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Ofrece tu hogar como casa de acogida temporal para animales que lo necesiten. Rellena el formulario y nos pondremos en contacto contigo.',
                      style: TextStyle(
                        color: AppColors.terracotta,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // The main form card
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepGreen.withAlpha(
                          (0.11 * 255).toInt(),
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 22,
                  ),
                  child: Column(
                    children: [
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        // This makes the user's input bold
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold, // <- Bold style for input text
                          color: AppColors
                              .deepGreen, // Optional: you can set the color too
                          fontSize: 16.2, // Optional: adjust size if needed
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nombre de la casa de acogida',
                          filled: true,
                          fillColor: AppColors.lightBlueWhite,
                          prefixIcon: Icon(
                            Icons.house_outlined,
                            color: AppColors.deepGreen,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.softGreen.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.deepGreen,
                              width: 1.7,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.7,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          filled: true,
                          fillColor: AppColors.lightBlueWhite,
                          prefixIcon: Icon(
                            Icons.text_snippet_outlined,
                            color: AppColors.terracotta,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.softGreen.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.deepGreen,
                              width: 1.7,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.7,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      // Capacity field
                      TextFormField(
                        controller: _capacityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Capacidad máxima',
                          filled: true,
                          fillColor: AppColors.lightBlueWhite,
                          prefixIcon: Icon(
                            Icons.people_outline,
                            color: AppColors.softGreen,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.softGreen.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.deepGreen,
                              width: 1.7,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.7,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obligatorio';
                          }
                          final n = int.tryParse(value);
                          if (n == null || n < 1) {
                            return 'Debe ser un número mayor a 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      // Website field (optional)
                      TextFormField(
                        controller: _websiteController,
                        decoration: InputDecoration(
                          labelText: 'Página web (opcional)',
                          filled: true,
                          fillColor: AppColors.lightBlueWhite,
                          prefixIcon: Icon(
                            Icons.language,
                            color: AppColors.deepGreen,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.softGreen.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.deepGreen,
                              width: 1.7,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Address field
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Dirección',
                          filled: true,
                          fillColor: AppColors.lightBlueWhite,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.terracotta,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.softGreen.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.deepGreen,
                              width: 1.7,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.7,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      // Phone number field
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono de contacto',
                          filled: true,
                          fillColor: AppColors.lightBlueWhite,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColors.deepGreen,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.softGreen.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.deepGreen,
                              width: 1.7,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: AppColors.terracotta,
                              width: 1.7,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      // Submit button (large and centered)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepGreen,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 40,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          icon: Icon(Icons.send, color: Colors.white, size: 26),
                          label: Text(
                            _isSubmitting ? 'Enviando...' : 'Enviar solicitud',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          onPressed: _isSubmitting ? null : _submitRequest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
