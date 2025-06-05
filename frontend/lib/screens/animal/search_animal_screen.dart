import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';
import '../../models/animal_image.dart';

// Helper function for status style and label
Map<String, dynamic> getStatusStyle(String? status) {
  switch (status) {
    case 'available':
      return {'label': 'Disponible', 'color': AppColors.deepGreen};
    case 'not_available':
      return {'label': 'No disponible', 'color': Colors.redAccent};
    case 'adopted':
      return {'label': 'Adoptado', 'color': Colors.blueAccent};
    case 'fostered':
      return {'label': 'Acogida', 'color': AppColors.terracotta};
    case 'in_shelter':
      return {'label': 'En refugio', 'color': AppColors.deepGreen};
    default:
      return {'label': 'Desconocido', 'color': Colors.grey};
  }
}

class SearchAnimalScreen extends StatefulWidget {
  final String userName;
  final String userId;
  final String bearerToken;

  const SearchAnimalScreen({
    super.key,
    required this.userName,
    required this.userId,
    required this.bearerToken,
  });

  @override
  State<SearchAnimalScreen> createState() => _SearchAnimalScreenState();
}

class _SearchAnimalScreenState extends State<SearchAnimalScreen> {
  List<Animal> _allAnimals = [];
  List<Animal> _filteredAnimals = [];
  bool _isLoading = false;
  String _searchText = '';
  String _selectedStatus = 'Todos';
  final List<String> _statusOptions = [
    'Todos',
    'available',
    'adopted',
    'fostered',
    'in_shelter',
    'not_available',
  ];

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  Future<void> fetchAnimals() async {
    setState(() => _isLoading = true);
    final response = await http.get(
      Uri.parse('http://10.0.2.2:7105/api/animal'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        _allAnimals = data.map((json) => Animal.fromJson(json)).toList();
        _filteredAnimals = _allAnimals;
        _isLoading = false;
      });
    } else {
      setState(() {
        _allAnimals = [];
        _filteredAnimals = [];
        _isLoading = false;
      });
    }
  }

  void _filterAnimals() {
    setState(() {
      _filteredAnimals = _allAnimals.where((animal) {
        final matchName = animal.animalName.toLowerCase().contains(
          _searchText.toLowerCase(),
        );
        final matchStatus =
            (_selectedStatus == 'Todos') ||
            (animal.animalStatus.toLowerCase() ==
                _selectedStatus.toLowerCase());
        return matchName && matchStatus;
      }).toList();
    });
  }

  Widget _buildAnimalCard(Animal animal) {
    // Get the main image of the animal or use a default image
    AnimalImage? mainImage = animal.images.isNotEmpty
        ? animal.images.firstWhere(
            (img) => img.isMainImage,
            orElse: () => animal.images[0],
          )
        : null;

    // Get translated label and color for the animal status
    final style = getStatusStyle(animal.animalStatus.toLowerCase());

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        // Animal photo with a green border (matches other screens)
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.softGreen, // Use the green from your palette
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepGreen.withAlpha((0.10 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            backgroundImage: mainImage != null
                ? NetworkImage(mainImage.imageUrl)
                : const AssetImage('assets/images/default_animal.png')
                      as ImageProvider,
          ),
        ),
        // Animal name, styled in green
        title: Text(
          animal.animalName,
          style: TextStyle(
            color: AppColors.deepGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        // Breed and age, shown in terracotta, with correct pluralization
        subtitle: Text(
          animal.animalAge != null
              ? '${animal.animalBreed} - ${animal.animalAge} ${animal.animalAge == 1 ? 'año' : 'años'}'
              : animal.animalBreed,
          style: TextStyle(
            color: AppColors.terracotta,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Status as a colored badge
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: style['color'],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            style['label'],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
            ),
          ),
        ),
        // Navigate to the animal profile on tap
        onTap: () {
          Navigator.pushNamed(context, '/animal-profile', arguments: animal);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        centerTitle: true,
        title: const Text(
          'Buscar peluditos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de búsqueda
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.deepGreen,
                        ),
                        filled: true,
                        fillColor: AppColors.softGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                      ),
                      onChanged: (text) {
                        _searchText = text;
                        _filterAnimals();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedStatus,
                    items: _statusOptions
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status == 'Todos'
                                  ? 'Todos'
                                  : status == 'available'
                                  ? 'Disponible'
                                  : status == 'adopted'
                                  ? 'Adoptado'
                                  : status == 'fostered'
                                  ? 'Acogida'
                                  : status == 'in_shelter'
                                  ? 'En refugio'
                                  : status == 'not_available'
                                  ? 'No disponible'
                                  : status,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                        _filterAnimals();
                      });
                    },
                    dropdownColor: AppColors.softGreen,
                    underline: Container(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredAnimals.isEmpty
                    ? Center(
                        child: Text(
                          'No hay animales que coincidan con la búsqueda.',
                          style: TextStyle(
                            color: AppColors.terracotta,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredAnimals.length,
                        itemBuilder: (context, index) =>
                            _buildAnimalCard(_filteredAnimals[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
      // Botonera igual que el resto
      bottomNavigationBar: AnimalListNavigationBar(
        userName: widget.userName,
        userId: widget.userId,
        bearerToken: widget.bearerToken,
      ),
    );
  }
}

// Puedes reutilizar la misma botonera homogénea aquí, importándola o copiando el widget
class AnimalListNavigationBar extends StatelessWidget {
  final String userName;
  final String userId;
  final String bearerToken;
  const AnimalListNavigationBar({
    super.key,
    required this.userName,
    required this.userId,
    required this.bearerToken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.15 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: AppColors.deepGreen,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/main',
                arguments: {
                  'userName': userName,
                  'userId': userId,
                  'bearerToken': bearerToken,
                },
              );
            },
            tooltip: 'Inicio',
          ),
          IconButton(
            icon: Icon(Icons.search, color: AppColors.terracotta, size: 32),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/search-animal',
                arguments: {
                  'userName': userName,
                  'userId': userId,
                  'bearerToken': bearerToken,
                },
              );
            },
            tooltip: 'Buscar',
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softGreen,
              boxShadow: [
                BoxShadow(color: AppColors.deepGreen, blurRadius: 14),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.favorite, color: Colors.white, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              tooltip: 'Favoritos',
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.article_outlined,
              color: AppColors.deepGreen,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/requests',
                arguments: {
                  'userName': userName,
                  'userId': userId,
                  'bearerToken': bearerToken,
                },
              );
            },
            tooltip: 'Solicitudes',
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.deepGreen,
              size: 34,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/public-profile');
            },
            tooltip: 'Perfil',
          ),
        ],
      ),
    );
  }
}
