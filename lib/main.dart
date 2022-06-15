import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instragram_jakk_app/providers/user_provider.dart';
import 'package:instragram_jakk_app/responsive/mobile_screen_layout.dart';
import 'package:instragram_jakk_app/responsive/responsive_layout.dart';
import 'package:instragram_jakk_app/responsive/web_screen_layout.dart';
import 'package:instragram_jakk_app/screens/login_screen.dart';
import 'package:instragram_jakk_app/screens/signup_screen.dart';
import 'package:instragram_jakk_app/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAfCqAwUqqjflG0vbTPzK-uXwiHloaSQnM',
        appId: '1:498708352160:web:0591410525b6c39be58dc5',
        messagingSenderId: '498708352160',
        projectId: 'instagram-clone-71918',
        storageBucket: 'instagram-clone-71918.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //get mobileBackgroundColor => null;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Jakk Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //home: const ResponsiveLayout(
        //mobileScreenLayout: MobileScreenLayout(),
        //webScreenLayout: WebScreenLayout(),
        //),

        //home: const LoginScreen(),
        //home: const SignupScreen(),
        home: StreamBuilder(
          //stream: FirebaseAuth.instance.idTokenChanges(),
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
