import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/app_colors.dart';
import '../../models/animal.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({Key? key}) : super(key: key);

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
                      subtitle: Text('${animal.breed} - ${animal.gender}'),
                      trailing: Text(animal.status),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
