import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/data/repositories/movimiento_repository.dart';
import 'package:wallet/presentation/pages/add_gasto_page.dart';
import 'presentation/pages/add_ingreso_page.dart';
import 'presentation/pages/edit_ingreso_page.dart';
import 'presentation/pages/edit_gasto_page.dart';
import 'core/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wallet/core/services/firebase_service.dart';
import 'presentation/screens/main_screen.dart';
import 'core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseService()),
        ProxyProvider<FirebaseService, MovimientoRepository>(
          update: (_, firebaseService, __) =>
              MovimientoRepository(firebaseService),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/add-gasto': (context) => const AddGastoPage(),
        '/add-ingreso': (context) => const AddIngresoPage(),
        '/edit-gasto': (context) => const EditGastoPage(),
        '/edit-ingreso': (context) => const EditIngresoPage(),
      },
    );
  }
}
