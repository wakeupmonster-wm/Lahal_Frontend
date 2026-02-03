// import 'dart:convert';
// import 'package:mafs/features/authentication/repositories/auth_repo.dart';
// import 'package:mafs/utils/constants/stripe_keys.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// import '../../utils/components/snackbar/app_snackbar.dart' show AppSnackBar;

// class StripePaymentService {
//   // Singleton pattern
//   StripePaymentService._privateConstructor();

//   static final StripePaymentService instance =
//       StripePaymentService._privateConstructor();

//   final AuthRepo authRepo = AuthRepo();

//   // Create payment intent on Stripe server
//   Future<Map<String, dynamic>> createPaymentIntent({
//     required String amount,
//     required String currency,
//   }) async {
//     final body = {
//       'amount': calculateAmount(amount),
//       'currency': currency,
//       'payment_method_types[]': 'card',
//     };

//     try {
//       final response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         body: body,
//         headers: {
//           'Authorization': "Bearer $stripeSecretKey",
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//       );

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to create payment intent: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Error creating payment intent: $e');
//     }
//   }

//   // Convert amount string to integer cents (Stripe expects integer amount)
//   String calculateAmount(String amount) {
//     final intAmount = (double.tryParse(amount) ?? 0) * 100;
//     return intAmount.toInt().toString();
//   }

//   // Initialize payment sheet
//   Future<void> initPaymentSheet({
//     required String clientSecret,
//     String merchantDisplayName = 'Trimify Fitness',
//     BuildContext? context,
//   }) async {
//     try {
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: merchantDisplayName,
//           googlePay: PaymentSheetGooglePay(merchantCountryCode: 'US'),
//           style: ThemeMode.system,
//         ),
//       );
//     } catch (e) {
//       if (context != null) {
//         _showErrorDialog(context, 'Failed to initialize payment sheet: $e');
//       }
//       rethrow;
//     }
//   }

//   // Present payment sheet and handle payment result
//   Future<bool> presentPaymentSheet({
//     required String paymentIntentId,
//     required String clientSecret,
//     required String planId,
//     required String amount,
//     required String currency,
//     required BuildContext context,
//   }) async {
//     try {
//       await Stripe.instance.presentPaymentSheet(
//         options: PaymentSheetPresentOptions(),
//       );

//       // Add transaction info to your database after successful payment
//       await addTransactionToDatabase(
//         transactionId: paymentIntentId,
//         amount: amount,
//         currency: currency,
//         status: 'success',
//         planId: planId,
//       );

//       if (context.mounted) {
//         // AppSnackBar.showSnackbar(context: context, title: "Success", message: "Payment successful",type: SnackbarType.success);

//         // _showSuccessDialog(context, 'Payment Successful!');
//       }
//       return true;
//     } on StripeException catch (e) {
//       debugPrint('Stripe error: ${e.error.localizedMessage}');

//       if (e.error.localizedMessage == 'The payment flow has been canceled' ||
//           e.error.localizedMessage == 'The payment has been canceled') {
//         AppSnackBar.showToast(
//           message: e.error.localizedMessage ?? 'Something went wrong',
//         );
//       } else {
//         await addTransactionToDatabase(
//           transactionId: paymentIntentId,
//           amount: amount,
//           currency: currency,
//           status: 'failed',
//           planId: planId,
//         );
//       }
//       return false;
//     } catch (e) {
//       await addTransactionToDatabase(
//         transactionId: paymentIntentId,
//         amount: amount,
//         currency: currency,
//         status: 'failed',
//         planId: planId,
//       ); // _showErrorDialog(context, 'Payment error occurred. Please try again.');
//       return false;
//     }
//   }

//   // Add transaction details to your backend/database
//   Future<void> addTransactionToDatabase({
//     required String transactionId,
//     required String amount,
//     required String currency,
//     required String status,
//     required String planId,
//   }) async {
//     try {
//       final body = {
//         'plan_id': planId,
//         'transaction_id': transactionId,
//         'amount': amount,
//         'currency': currency,
//         'status': status,
//       };

//       final response = await authRepo.addTransaction(body);

//       if (response == null || response['success'] != true) {
//         print('Add transaction failed: $response');
//         print("############################");
//         // throw Exception('Failed to save transaction.');
//       }

//       debugPrint('Transaction saved successfully.');
//     } catch (e) {
//       debugPrint('Error saving transaction: $e');
//       // Optional: rethrow or handle error as needed
//     }
//   }

//   // Wrapper dialog for errors
//   void _showErrorDialog(BuildContext context, String message) {
//     if (!context.mounted) return;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Payment Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Wrapper dialog for success
//   void _showSuccessDialog(BuildContext context, String message) {
//     if (!context.mounted) return;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Icon(Icons.check_circle, color: Colors.green, size: 100),
//             SizedBox(height: 10),
//             Text('Payment Successful!'),
//           ],
//         ),
//       ),
//     );
//   }

//   // Master method to call from UI/controller
//   Future<bool> makePayment({
//     required String amount,
//     required String currency,
//     required String planId,
//     required BuildContext context,
//   }) async {
//     try {
//       final paymentIntentData = await createPaymentIntent(
//         amount: amount,
//         currency: currency,
//       );

//       final clientSecret = paymentIntentData['client_secret'] as String?;
//       final paymentIntentId = paymentIntentData['id'] as String?;

//       if (clientSecret == null || paymentIntentId == null) {
//         throw Exception('Invalid payment intent data.');
//       }

//       await initPaymentSheet(clientSecret: clientSecret, context: context);

//       final success = await presentPaymentSheet(
//         paymentIntentId: paymentIntentId,
//         clientSecret: clientSecret,
//         planId: planId,
//         amount: amount,
//         currency: currency,
//         context: context,
//       );

//       return success;
//     } catch (e) {
//       debugPrint('Payment failed: $e');
//       if (context.mounted) {
//         _showErrorDialog(context, 'Payment failed: $e');
//       }
//       return false;
//     }
//   }
// }
