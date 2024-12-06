class Clinic {
  final String clinicId;
  final String clinicName;
  final String phoneNumber;
  final String address;
  final String googleMap;
  final String clinicThumbnail;

  Clinic({
    required this.clinicId,
    required this.clinicName,
    required this.phoneNumber,
    required this.address,
    required this.googleMap,
    required this.clinicThumbnail,
  });

  factory Clinic.fromMap(Map<String, dynamic> map) {
    return Clinic(
      clinicId: map["clinic_id"],
      clinicName: map["clinic_name"],
      phoneNumber: map["phone_number"],
      address: map["address"],
      googleMap: map["google_map"],
      clinicThumbnail: map["clinic_thumbnail"],
    );
  }
}
