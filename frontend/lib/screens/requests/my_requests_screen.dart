import 'package:flutter/material.dart';
import '../../models/adoption_request.dart';
import '../../utils/app_colors.dart';
import '../../services/adoption_request_service.dart';

// MyRequestsScreen displays the list of adoption requests for the current user.
// Requires userId (from backend or Firebase) and bearerToken (for secured requests).
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

  // Returns display info for each request status: label, color, and icon.
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

  // Formats a date as dd/MM/yyyy (for Spanish UI)
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
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
            // Loading indicator with color accent
            return const Center(
              child: CircularProgressIndicator(color: AppColors.deepGreen),
            );
          } else if (snapshot.hasError) {
            // Error message with app colors and icon
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightPeach,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.terracotta, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.terracotta.withAlpha(
                        (0.15 * 255).toInt(),
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.terracotta,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(
                          color: AppColors.terracotta,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // No requests found - friendly message with icon
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
            // Show the list of requests with consistent card style
            final requests = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final req = requests[index];
                final status = getStatusInfo(req.requestStatus);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 7,
                  color: Colors.white,
                  shadowColor: AppColors.deepGreen.withAlpha(
                    (0.09 * 255).toInt(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row with icon, animal name, and status chip
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (status['color'] as Color).withAlpha(
                                  (0.11 * 255).toInt(),
                                ),
                              ),
                              padding: const EdgeInsets.all(7),
                              child: Icon(
                                status['icon'],
                                color: status['color'],
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Text(
                                req.animalName ?? 'Animal',
                                style: const TextStyle(
                                  color: AppColors.deepGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              size: 19,
                              color: AppColors.deepGreen.withAlpha(
                                (0.8 * 255).toInt(),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Fecha de solicitud: ',
                              style: TextStyle(
                                color: AppColors.deepGreen.withAlpha(
                                  (0.9 * 255).toInt(),
                                ),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.2,
                              ),
                            ),
                            Text(
                              formatDate(req.requestDate),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.2,
                              ),
                            ),
                          ],
                        ),
                        if (req.requestMessage != null &&
                            req.requestMessage!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 1),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  color: AppColors.terracotta,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Mensaje: ${req.requestMessage}',
                                    style: TextStyle(
                                      color: AppColors.terracotta,
                                      fontSize: 15.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (req.requestResponse != null &&
                            req.requestResponse!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 1),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.reply_outlined,
                                  color: AppColors.deepGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Respuesta: ${req.requestResponse}',
                                    style: const TextStyle(
                                      color: AppColors.deepGreen,
                                      fontSize: 15.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
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
