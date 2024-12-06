import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/models/clinic.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicDetailScreen extends StatelessWidget {
  static const String routeName = "/clinic-detail";
  final Clinic clinic;
  const ClinicDetailScreen({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clinic.clinicName),
      ),
      body: ListView(
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
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTile(
                  title: "Address",
                  content: clinic.address,
                ),
                const Divider(height: 12),
                CustomTile(
                  title: "Map",
                  content: clinic.googleMap,
                  tapable: true,
                  onTap: () {
                    launchUrl(Uri.parse(clinic.googleMap));
                  },
                ),
                const Divider(height: 12),
                CustomTile(
                  title: "Phone Number",
                  content: clinic.phoneNumber,
                  tapable: true,
                  onTap: () async {
                    final uri = Uri(scheme: "tel", path: clinic.phoneNumber);
                    bool ok = await canLaunchUrl(uri);
                    log("canLaunchUrl $ok");
                    // launchUrl(Uri(scheme: "tel", path: clinic.phoneNumber));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String content;
  final bool tapable;
  final VoidCallback? onTap;
  const CustomTile({
    super.key,
    required this.title,
    required this.content,
    this.tapable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              onTap?.call();
            },
            child: Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: tapable ? TextDecoration.underline : null,
                decorationColor: tapable ? Colors.blue : null,
                color: tapable ? Colors.blue : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class CustomTile extends StatelessWidget {
//   final String title;
//   final String content;
//   final bool underline;
//   final VoidCallback? contentOnTap;
//   final Color? contentTextColor;
//   const CustomTile({
//     super.key,
//     required this.title,
//     required this.content,
//     this.underline = false,
//     this.contentTextColor,
//     this.contentOnTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(title),
//         ),
//         Expanded(
//           flex: 2,
//           child: GestureDetector(
//             onTap: contentOnTap,
//             child: Text(
//               content,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   decorationColor: contentTextColor,
//                   decoration: underline ? TextDecoration.underline : null,
//                   color: contentTextColor),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
