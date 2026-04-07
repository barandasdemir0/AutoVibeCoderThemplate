// ============================================
// Dosya: main.dart
// Amaç: Uygulama giriş noktası — Firebase init, Provider setup, GoRouter
// Bağımlılıklar: firebase_options.dart, app_router.dart, app_theme.dart, tüm provider'lar
// ============================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// TODO: Firebase yapılandırması yapıldıktan sonra bu import'u aktif et
// import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env dosyasını yükle
  await dotenv.load(fileName: ".env");

  // Firebase başlat
  // TODO: flutterfire configure çalıştırdıktan sonra bu satırı aktif et
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        // TODO: Yeni ViewModel'ler buraya eklenecek
        // ChangeNotifierProvider(create: (_) => ProductViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: dotenv.env['APP_NAME'] ?? '{{PROJECT_NAME}}',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
