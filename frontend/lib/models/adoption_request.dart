class AdoptionRequest {
  final String adoptionRequestId;
  final DateTime requestDate;
  final DateTime requestUpdateDate;
  final String requestStatus;
  final String? requestMessage;
  final String? requestResponse;
  final DateTime? requestResponseDate;
  final bool requestIsVerified;
  final bool requestIsCompleted;
  final String userId;
  final String animalId;
  final String? animalName; // This will be added later

  // Main constructor
  AdoptionRequest({
    required this.adoptionRequestId,
    required this.requestDate,
    required this.requestUpdateDate,
    required this.requestStatus,
    this.requestMessage,
    this.requestResponse,
    this.requestResponseDate,
    required this.requestIsVerified,
    required this.requestIsCompleted,
    required this.userId,
    required this.animalId,
    this.animalName,
  });

  // Clone with a new animalName (for async fetching)
  AdoptionRequest copyWith({String? animalName}) {
    return AdoptionRequest(
      adoptionRequestId: this.adoptionRequestId,
      requestDate: this.requestDate,
      requestUpdateDate: this.requestUpdateDate,
      requestStatus: this.requestStatus,
      requestMessage: this.requestMessage,
      requestResponse: this.requestResponse,
      requestResponseDate: this.requestResponseDate,
      requestIsVerified: this.requestIsVerified,
      requestIsCompleted: this.requestIsCompleted,
      userId: this.userId,
      animalId: this.animalId,
      animalName: animalName ?? this.animalName,
    );
  }

  // Factory for parsing from JSON
  factory AdoptionRequest.fromJson(Map<String, dynamic> json) {
    return AdoptionRequest(
      adoptionRequestId: json['adoptionRequestId'],
      requestDate: DateTime.parse(json['requestDate']),
      requestUpdateDate: DateTime.parse(json['requestUpdateDate']),
      requestStatus: json['requestStatus'],
      requestMessage: json['requestMessage'],
      requestResponse: json['requestResponse'],
      requestResponseDate: json['requestResponseDate'] != null
          ? DateTime.parse(json['requestResponseDate'])
          : null,
      requestIsVerified: json['requestIsVerified'],
      requestIsCompleted: json['requestIsCompleted'],
      userId: json['userId'],
      animalId: json['animalId'],
      animalName: null, // Will be set later with copyWith
    );
  }
}
