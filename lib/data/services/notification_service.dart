// import 'dart:io';

// import 'package:mafs/main.dart';
// import 'package:mafs/utils/routes/app_pages.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static const platform = MethodChannel('com.example.app/notification');

//   Future<void> initialize() async {
//     await Firebase.initializeApp();
//     await _requestPermission();
//     await _initializeLocalNotifications();
//     setupForegroundNotificationHandler();
//     _setupBackgroundNotificationHandler();
//     _setupTokenRefreshHandler();

//     // Handle notification when the app is terminated
//     _handleTerminatedNotification();

//     platform.setMethodCallHandler(_handleNotificationMethodCall);
//   }

//   Future<void> _handleNotificationMethodCall(MethodCall call) async {
//     BuildContext context = navigatorKey.currentContext!;
//     context.pushNamed(AppRoutes.notificationScreen);
//     // context.push(AppRoutes.NOTIFICATION_SCREEN);
//   }

//   Future<void> _requestPermission() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings iosInitializationSettings =
//         DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           defaultPresentAlert: true,
//           defaultPresentBadge: true,
//           defaultPresentSound: true,
//         );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: androidInitializationSettings,
//           iOS: iosInitializationSettings,
//         );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         print("User tappedffdffff on notification: ${response.payload}");
//         print("#########################################");
//         _handleNotificationTap(response);
//       },
//     );
//   }

//   void setupForegroundNotificationHandler() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//   }

//   void _setupBackgroundNotificationHandler() {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//     RemoteMessage message,
//   ) async {
//     await Firebase.initializeApp();
//     print("Handling a background message: ${message.messageId}");
//   }

//   Future<void> _showNotification(RemoteMessage message) async {
//     print("R###########################");
//     print("Foreground Notification Payload: ${message.data}");
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'default_channel',
//           'Default',
//           importance: Importance.max,
//           priority: Priority.high,
//         );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       sound: "default", // Explicitly set sound
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       message.notification?.title ?? 'Notification',
//       message.notification?.body ?? '',
//       details,
//     );
//   }

//   void _handleNotificationTap(NotificationResponse response) {
//     // Delay navigation until context is ready

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _navigateToNotificationScreen();
//     });
//   }

//   void _navigateToNotificationScreen() {
//     final context = navigatorKey.currentContext; // Access the context
//     if (context != null) {
//       print("Navigating to the notification screen");
//       context.pushNamed(AppRoutes.notificationScreen);
//       // context.push(AppRoutes.NOTIFICATION_SCREEN);
//     } else {
//       print("Navigator context is null, can't navigate");
//     }
//   }

//   Future<String?> getToken() async {
//     //String? token = await _firebaseMessaging.getToken();
//     String? token = "k";
//     print("FCM Token: $token");
//     return token;
//   }

//   void _setupTokenRefreshHandler() {
//     _firebaseMessaging.onTokenRefresh.listen((newToken) {
//       print("Refreshed FCM Token: $newToken");
//     });
//   }

//   void _handleTerminatedNotification() {
//     FirebaseMessaging.instance.getInitialMessage().then((
//       RemoteMessage? message,
//     ) {
//       if (message != null) {
//         print(
//           "App launched from terminated state by notification: ${message.data}",
//         );
//         _navigateToNotificationScreen(); // Modify based on your app's requirements
//       }
//     });
//   }
// }
