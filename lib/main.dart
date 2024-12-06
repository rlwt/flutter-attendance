import 'package:flutter/material.dart';
import 'package:flutter_attendance/models/clinic.dart';
import 'package:flutter_attendance/screens/screens.dart';
import 'package:flutter_attendance/services/api_client.dart';
import 'package:flutter_attendance/services/database_service.dart';
import 'package:flutter_attendance/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SharedPreferencesService>(
          create: (_) => SharedPreferencesService(sharedPreferences),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case SplashScreen.routeName:
                builder = (_) => const SplashScreen();
                break;
              case LoginScreen.routeName:
                builder = (_) => const LoginScreen();
                break;
              case RegisterScreen.routeName:
                builder = (_) => const RegisterScreen();
                break;
              case StudentHomeScreen.routeName:
                builder = (_) => const StudentHomeScreen();
                break;
              case ClinicsScreen.routeName:
                builder = (_) => const ClinicsScreen();
                break;
              case ClinicDetailScreen.routeName:
                final clinic = settings.arguments as Clinic;
                builder = (_) => ClinicDetailScreen(
                      clinic: clinic,
                    );
                break;
              default:
                return null;
            }
            return MaterialPageRoute(builder: builder);
          }
          // routes: {
          //   SplashScreen.routeName: (_) => const SplashScreen(),
          //   LoginScreen.routeName: (_) => const LoginScreen(),
          //   RegisterScreen.routeName: (_) => const RegisterScreen(),
          //   StudentHomeScreen.routeName: (_) => const StudentHomeScreen(),
          //   ClinicsScreen.routeName: (_) => const ClinicsScreen(),
          // },
          ),
    );
  }
}
