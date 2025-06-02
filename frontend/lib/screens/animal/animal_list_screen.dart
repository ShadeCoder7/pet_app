import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';

class AnimalListScreen extends StatefulWidget {
  final String userName;
  const AnimalListScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _AnimalListScreenState createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  List<Animal> animals = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  // Load all animals in one go for MVP (no pagination)
  Future<void> fetchAnimals() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse('http://10.0.2.2:7105/api/animal'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        animals = data.map((json) => Animal.fromJson(json)).toList();
      });
    } else {
      throw Exception('Error cargando animales');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        centerTitle: true,
        title: const Text(
          'Listado de Animales',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : animals.isEmpty
            ? const Center(child: Text('No hay animales para mostrar'))
            : ListView.builder(
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  Animal animal = animals[index];
                  return Card(
                    child: ListTile(
                      // Show image or placeholder if empty
                      leading: CircleAvatar(
                        backgroundImage: animal.imageUrl.isNotEmpty
                            ? NetworkImage(animal.imageUrl)
                            : const AssetImage(
                                    'assets/images/default_animal.png',
                                  )
                                  as ImageProvider,
                      ),
                      title: Text(animal.name),
                      subtitle: Text(
                        animal.age != null
                            ? '${animal.breed} - ${animal.age} años'
                            : animal.breed,
                      ),
                      trailing: Text(animal.status),
                    ),
                  );
                },
              ),
      ),
      // Pasa userName a la barra
      bottomNavigationBar: AnimalListNavigationBar(userName: widget.userName),
    );
  }
}

// Bottom navigation bar with 5 buttons: Favoritos (center), Inicio, Buscar, Solicitudes, Perfil
class AnimalListNavigationBar extends StatelessWidget {
  final String userName;
  const AnimalListNavigationBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Botón de inicio (izquierda)
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: AppColors.deepGreen,
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/main', arguments: userName);
            },
            tooltip: 'Inicio',
          ),
          // Botón de búsqueda
          IconButton(
            icon: Icon(Icons.search, color: AppColors.terracotta, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/buscar');
            },
            tooltip: 'Buscar',
          ),
          // Botón de favoritos (central destacado)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softGreen,
              boxShadow: [
                BoxShadow(color: AppColors.deepGreen, blurRadius: 10),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.favorite, color: Colors.white, size: 36),
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              tooltip: 'Favoritos',
            ),
          ),
          // Botón de solicitudes
          IconButton(
            icon: Icon(
              Icons.article_outlined,
              color: AppColors.deepGreen,
              size: 28,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/requests');
            },
            tooltip: 'Solicitudes',
          ),
          // Botón de perfil
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: AppColors.terracotta,
              size: 28,
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
