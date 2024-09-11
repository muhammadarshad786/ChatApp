import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:internship_firebase/Notification/notification.dart';
import 'package:internship_firebase/Screens/loginscreen.dart';
import 'package:internship_firebase/firebase_options.dart';
import 'package:internship_firebase/provider/boolpro.dart';
import 'package:internship_firebase/provider/imageprovider.dart';
import 'package:provider/provider.dart';


Future FirebaseBackGroundNotification(RemoteMessage message) async
{
  if(message.notification !=null)
  {
    print('Some BackGround Notifiation');
    print('background notification are those');
  }

 }

void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
   );
   await PushNotificationFireBase.init();
  FirebaseMessaging.onBackgroundMessage(FirebaseBackGroundNotification);
  PushNotificationFireBase notificationService = PushNotificationFireBase();
  await notificationService.localInit();

    runApp(
      MultiProvider(
      providers: [ 
    ChangeNotifierProvider(create: ((context) => ProviderModel())),
    ChangeNotifierProvider(create: ((context) => ProviderForsinup())),
    ChangeNotifierProvider(create: ((context) => ImageproviderSet()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginScreen(),
    );
  }
}
