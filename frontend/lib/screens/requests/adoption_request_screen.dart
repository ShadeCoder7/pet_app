import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../utils/app_colors.dart';
import '../../services/adoption_request_service.dart'; // Ajusta la importación si tienes el método de enviar

class AdoptionRequestScreen extends StatefulWidget {
  final String userId;
  final String bearerToken;
  final List<Animal>
  adoptableAnimals; // Lista de animales disponibles para adoptar

  const AdoptionRequestScreen({
    super.key,
    required this.userId,
    required this.bearerToken,
    required this.adoptableAnimals,
  });

  @override
  State<AdoptionRequestScreen> createState() => _AdoptionRequestScreenState();
}

class _AdoptionRequestScreenState extends State<AdoptionRequestScreen> {
  Animal? selectedAnimal;
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.adoptableAnimals.isNotEmpty) {
      selectedAnimal = widget.adoptableAnimals.first;
    }
  }

  Future<void> _submitRequest() async {
    if (selectedAnimal == null || _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, selecciona un animal y escribe un mensaje.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await sendAdoptionRequest(
        userId: widget.userId,
        animalId: selectedAnimal!.animalId,
        message: _messageController.text.trim(),
        bearerToken: widget.bearerToken,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('¡Solicitud enviada con éxito!')));
      Navigator.of(context).pop(); // Vuelve atrás tras enviar
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la solicitud: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
          'Solicitud de Adopción',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.05,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Hide keyboard on tap outside
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 22,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                18, // Extra for keyboard
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ... El resto de tus widgets igual ...
              // (copia todo lo que ya tienes dentro de tu Column aquí)
              Text(
                'Selecciona el animal:',
                style: TextStyle(
                  color: AppColors.deepGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<Animal>(
                value: selectedAnimal,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.deepGreen,
                ),
                items: widget.adoptableAnimals.map((animal) {
                  return DropdownMenuItem<Animal>(
                    value: animal,
                    child: Text(animal.animalName),
                  );
                }).toList(),
                onChanged: (Animal? newAnimal) {
                  setState(() {
                    selectedAnimal = newAnimal;
                  });
                },
              ),
              const SizedBox(height: 18),
              // Imagen del animal seleccionado
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.softGreen, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepGreen.withAlpha(
                          (0.13 * 255).round(),
                        ),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (selectedAnimal != null &&
                            selectedAnimal!.images.isNotEmpty)
                        ? NetworkImage(selectedAnimal!.images.first.imageUrl)
                        : const AssetImage('assets/images/default_animal.png')
                              as ImageProvider,
                    radius: 52,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Mensaje para la protectora:',
                style: TextStyle(
                  color: AppColors.deepGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '¿Por qué quieres adoptar a este animal?',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(Icons.send, color: Colors.white),
                label: Text(
                  _isSubmitting ? 'Enviando...' : 'Enviar solicitud',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _isSubmitting ? null : _submitRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
