import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';

class SupportAnimalRequestScreen extends StatefulWidget {
  final String? userId;
  final List<Animal> adoptableAnimals; // List of animals to sponsor

  const SupportAnimalRequestScreen({
    super.key,
    this.userId,
    required this.adoptableAnimals,
  });

  @override
  State<SupportAnimalRequestScreen> createState() =>
      _SupportAnimalRequestScreenState();
}

class _SupportAnimalRequestScreenState
    extends State<SupportAnimalRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  Animal? selectedAnimal;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isSubmitting = false;

  // Store only animals with a status allowed for sponsorship
  late List<Animal> _filteredAnimals;

  @override
  void initState() {
    super.initState();

    // Allowed statuses for sponsorship (available, fostered, in_shelter)
    _filteredAnimals = widget.adoptableAnimals.where((animal) {
      final status = animal.animalStatus.toLowerCase();
      return status == 'available' ||
          status == 'fostered' ||
          status == 'in_shelter';
    }).toList();

    // Select the first animal from the filtered list (if exists)
    if (_filteredAnimals.isNotEmpty) {
      selectedAnimal = _filteredAnimals.first;
    }
  }

  // Handle support request submission
  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Here you would send the support request to your backend service

    // For now, just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('¡Solicitud de apadrinamiento enviada!')),
    );
    setState(() => _isSubmitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Get the main image of the selected animal (use as in AnimalProfileScreen)
    AnimalImage? mainImage = selectedAnimal?.images.isNotEmpty == true
        ? selectedAnimal!.images.firstWhere(
            (img) => img.isMainImage,
            orElse: () => selectedAnimal!.images[0],
          )
        : null;

    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Apadrinar Animal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Animal profile image at the top (same style as AnimalProfileScreen)
              Center(
                child: mainImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          mainImage.imageUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.pets, color: AppColors.terracotta, size: 120),
              ),
              const SizedBox(height: 16),
              // Animal name shown below the image
              if (selectedAnimal != null)
                Center(
                  child: Text(
                    selectedAnimal!.animalName,
                    style: TextStyle(
                      color: AppColors.deepGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Dropdown to select the animal to sponsor (filtered)
              Text(
                'Selecciona el animal a apadrinar:',
                style: TextStyle(
                  color: AppColors.deepGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 7),
              DropdownButton<Animal>(
                value: selectedAnimal,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.deepGreen,
                ),
                items: _filteredAnimals.map((animal) {
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
              const SizedBox(height: 16),

              // Text field for donation amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad a donar (€)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  final n = double.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Introduce una cantidad válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Optional message to the shelter
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mensaje (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(Icons.volunteer_activism, color: Colors.white),
                label: Text(
                  _isSubmitting ? 'Enviando...' : 'Apadrinar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
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
