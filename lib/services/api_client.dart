import 'dart:convert';

import 'package:flutter_attendance/models/clinic.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<List<Clinic>> getPanelClinicListing() async {
    http.Response response = await http.get(Uri.parse(
      "https://agmoacademy.com/flutter_dec2024/panel_clinic_list.php",
    ));
    final decodedBody = json.decode(response.body);
    List<dynamic> list = decodedBody["panel_clinics_data"];
    return list.map((e) => Clinic.fromMap(e)).toList();
  }
}
