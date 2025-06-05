import 'package:flutter/material.dart';
import '../../models/adoption_request.dart';
import '../../utils/app_colors.dart';

// Shows the details of a specific adoption request
class SpecificRequestScreen extends StatelessWidget {
  final AdoptionRequest request;

  const SpecificRequestScreen({super.key, required this.request});

  // Formats a date as dd/MM/yyyy
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Get status info (color, icon, label)
    final statusInfo =
        {
          'pending': {
            'label': 'Pendiente',
            'color': AppColors.terracotta,
            'icon': Icons.hourglass_top,
          },
          'approved': {
            'label': 'Aprobada',
            'color': AppColors.deepGreen,
            'icon': Icons.check_circle,
          },
          'rejected': {
            'label': 'Rechazada',
            'color': Colors.redAccent,
            'icon': Icons.cancel,
          },
        }[request.requestStatus] ??
        {
          'label': request.requestStatus,
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };

    return Scaffold(
      backgroundColor: AppColors.lightBlueWhite,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        title: const Text(
          'Detalle de solicitud',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.05,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          color: Colors.white,
          shadowColor: AppColors.deepGreen.withAlpha(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Estado general, grande y centrado
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (statusInfo['color'] as Color).withAlpha(30),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          statusInfo['icon'] as IconData,
                          color: statusInfo['color'] as Color,
                          size: 45,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        statusInfo['label'].toString(),
                        style: TextStyle(
                          color: statusInfo['color'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Animal name (always present in adoption requests)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, color: AppColors.deepGreen, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        request.animalName ?? 'Animal',
                        style: TextStyle(
                          color: AppColors.deepGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fecha de la solicitud
                Row(
                  children: [
                    Icon(Icons.event, size: 20, color: AppColors.terracotta),
                    const SizedBox(width: 8),
                    Text(
                      'Fecha:',
                      style: TextStyle(
                        color: AppColors.terracotta,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.7,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      formatDate(request.requestDate),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.7,
                      ),
                    ),
                  ],
                ),

                // Mensaje de la solicitud
                if (request.requestMessage != null &&
                    request.requestMessage!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          color: AppColors.terracotta,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            request.requestMessage!,
                            style: TextStyle(
                              color: AppColors.terracotta,
                              fontSize: 16.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Respuesta de la protectora (opcional)
                if (request.requestResponse != null &&
                    request.requestResponse!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.reply_outlined,
                          color: AppColors.deepGreen,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            request.requestResponse!,
                            style: const TextStyle(
                              color: AppColors.deepGreen,
                              fontSize: 16.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
