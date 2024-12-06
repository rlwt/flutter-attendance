import 'package:flutter/material.dart';
import 'package:flutter_attendance/models/clinic.dart';
import 'package:flutter_attendance/screens/src/clinic_detail_screen.dart';
import 'package:flutter_attendance/services/api_client.dart';
import 'package:provider/provider.dart';

class ClinicsScreen extends StatefulWidget {
  static const String routeName = "/clinics";

  const ClinicsScreen({super.key});
  @override
  State<StatefulWidget> createState() => _ClinicsScreen();
}

class _ClinicsScreen extends State<ClinicsScreen> {
  List<Clinic> clinics = [];
  Future<void> getClinics() async {
    clinics = await context.read<ApiClient>().getPanelClinicListing();
    setState(() {});
  }

  @override
  void initState() {
    getClinics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinics"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ClinicDetailScreen.routeName,
                arguments: clinic);
          },
          child: Card(
            child: Column(
              children: [
                Hero(
                  tag: clinic.hashCode,
                  child: Image.network(
                    clinic.clinicThumbnail,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text(
                        clinic.clinicName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: clinics.length,
    );
  }
}
