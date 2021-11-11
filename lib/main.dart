import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            theme: ThemeData(
              textTheme: Theme.of(context).textTheme.copyWith(
                    headline1: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                    backgroundColor: Colors.pink,
                  ),
              primarySwatch: Colors.pink,
              backgroundColor: Colors.pink,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    secondary: Colors.deepPurple,
                    // brightness: Brightness.dark,
                  ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    // buttonColor: Colors.pink,
                    // textTheme: ButtonTextTheme.primary,
                    shape:
                        MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      );
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (_) => Colors.pink)),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (_) => Colors.pink),
                ),
              ),
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  return const ChatScreen();
                }
                return const AuthScreen();
              },
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
