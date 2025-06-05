import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../utils/app_colors.dart';
import '../../services/adoption_request_service.dart';

class AdoptionRequestScreen extends StatefulWidget {
  final String userId;
  final String bearerToken;
  final List<Animal> adoptableAnimals; // List of animals from backend

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
  late final List<Animal> availableAnimals;

  @override
  void initState() {
    super.initState();
    // Only keep animals available for adoption
    availableAnimals = widget.adoptableAnimals
        .where(
          (animal) =>
              animal.animalStatus == "available" ||
              animal.animalStatus == "in_shelter" ||
              animal.animalStatus == "fostered",
        )
        .toList();

    if (availableAnimals.isNotEmpty) {
      selectedAnimal = availableAnimals.first;
    }
  }

  // Send adoption request to backend and show feedback
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Solicitud enviada con éxito!'),
          backgroundColor: AppColors.deepGreen,
        ),
      );
      Navigator.of(context).pop(true); // To trigger refresh if needed
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar la solicitud: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 22,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: availableAnimals.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(Icons.pets, color: AppColors.terracotta, size: 60),
                    const SizedBox(height: 24),
                    Text(
                      'Actualmente no hay animales disponibles para adoptar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.terracotta,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Vuelve a intentarlo más tarde o contacta con la protectora.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.terracotta.withAlpha(170),
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Selecciona el animal:',
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Animal>(
                      value: selectedAnimal,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.deepGreen,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      items: availableAnimals.map((animal) {
                        return DropdownMenuItem<Animal>(
                          value: animal,
                          child: Text(
                            animal.animalName,
                            style: TextStyle(
                              color: AppColors.deepGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Animal? newAnimal) {
                        setState(() => selectedAnimal = newAnimal);
                      },
                    ),
                    const SizedBox(height: 18),
                    if (selectedAnimal != null)
                      Center(
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.softGreen,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.deepGreen.withAlpha(33),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: (selectedAnimal!.images.isNotEmpty)
                                ? NetworkImage(
                                    selectedAnimal!.images.first.imageUrl,
                                  )
                                : const AssetImage(
                                        'assets/images/default_animal.png',
                                      )
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
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: '¿Por qué quieres adoptar a este animal?',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      icon: _isSubmitting
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.2,
                              ),
                            )
                          : Icon(Icons.send, color: Colors.white),
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
                    const SizedBox(height: 14),
                    Text(
                      'Una vez enviada, podrás consultar el estado de tu solicitud desde la sección "Mis Solicitudes".',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.terracotta,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
