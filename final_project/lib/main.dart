import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/sign_in.dart';
import 'firebase_options.dart';


  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
      // argument for `webProvider`
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. Debug provider
      // 2. Safety Net provider
      // 3. Play Integrity provider
      androidProvider: AndroidProvider.debug,
      // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. Debug provider
      // 2. Device Check provider
      // 3. App Attest provider
      // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
      appleProvider: AppleProvider.appAttest,
    );


    runApp(
      MaterialApp(
        title: 'Hyper Garage Sale',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.teal,
          ).copyWith(secondary: Colors.amber),
          textTheme: ThemeData
              .light()
              .textTheme
              .copyWith(
            displayLarge:
            TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            displayMedium:
            TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyLarge:
            TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
            bodyMedium:
            TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            titleTextStyle:
            TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeData
                  .light()
                  .colorScheme
                  .primary,
              textStyle: const TextStyle(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12.0),
          ),
        ),
        home: SignIn(),
      ),
    );
  }
