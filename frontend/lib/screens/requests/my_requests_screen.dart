import 'package:flutter/material.dart';
import '../../models/adoption_request.dart';
import '../../utils/app_colors.dart';
import '../../services/adoption_request_service.dart';

class MyRequestsScreen extends StatefulWidget {
  final String userId;
  final String bearerToken;

  const MyRequestsScreen({
    super.key,
    required this.userId,
    required this.bearerToken,
  });

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  late Future<List<AdoptionRequest>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = fetchAdoptionRequests(widget.userId, widget.bearerToken);
  }

  Map<String, dynamic> getStatusInfo(String status) {
    switch (status) {
      case 'pending':
        return {
          'label': 'Pendiente',
          'color': AppColors.terracotta,
          'icon': Icons.hourglass_top,
        };
      case 'approved':
        return {
          'label': 'Aprobada',
          'color': AppColors.deepGreen,
          'icon': Icons.check_circle,
        };
      case 'rejected':
        return {
          'label': 'Rechazada',
          'color': Colors.redAccent,
          'icon': Icons.cancel,
        };
      default:
        return {
          'label': status,
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        title: const Text(
          'Mis Solicitudes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.05,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<AdoptionRequest>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.deepGreen),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: AppColors.terracotta,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline,
                    color: AppColors.terracotta,
                    size: 54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes solicitudes aún.',
                    style: TextStyle(
                      color: AppColors.terracotta,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tus solicitudes aparecerán aquí cuando envíes una.',
                    style: TextStyle(
                      color: AppColors.terracotta.withAlpha(
                        (0.85 * 255).toInt(),
                      ),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final requests = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final req = requests[index];
                final status = getStatusInfo(req.requestStatus);

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/specific-request',
                      arguments: req,
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    elevation: 7,
                    color: Colors.white,
                    shadowColor: AppColors.deepGreen.withAlpha(
                      (0.09 * 255).toInt(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 18,
                      ),
                      child: Row(
                        children: [
                          // Estado
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (status['color'] as Color).withAlpha(30),
                            ),
                            padding: const EdgeInsets.all(7),
                            child: Icon(
                              status['icon'],
                              color: status['color'],
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Nombre del animal
                          Expanded(
                            child: Text(
                              req.animalName ?? 'Animal',
                              style: const TextStyle(
                                color: AppColors.deepGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          // Estado textual
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: status['color'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status['label'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
