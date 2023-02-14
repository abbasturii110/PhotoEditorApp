import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quotes_maker/View/DirectionScreen.dart';

import 'Controller/CreateQuotesController.dart';
import 'Model/FavoriteImageModel.dart';
import 'Model/FavoriteModel.dart';

void main() async {
  // Directory document = await getApplicationDocumentsDirectory();
  // Hive.init(document.path);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteQuoteModelAdapter());
  await Hive.openBox<FavoriteQuoteModel>('favoriteModel');

  Hive.registerAdapter(FavoriteImageModelAdapter());
  // await Hive.openBox<FavoriteImageModel>('favoriteImageModel');
  await Hive.openBox<String>('imageFav');

  await Hive.openBox<String>("ScreenShot");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  CreateQuotesController controller = Get.put(CreateQuotesController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.blue,
      ),
      // home: HomeScreen(),
      home: AnimatedSplashScreen(
          duration: 3000,
          splash: Image.asset("assets/images/4419.jpg"),
          nextScreen: DirectionScreen(),
          splashIconSize: 200,
          splashTransition: SplashTransition.fadeTransition,
          // pageTransitionType: PageTransitionType.scale,
          backgroundColor: Colors.black38),
    );
  }
}
