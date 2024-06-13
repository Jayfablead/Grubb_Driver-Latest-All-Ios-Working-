import 'package:foodie_driver/model/CurrencyModel.dart';
import 'package:foodie_driver/model/TaxModel.dart';
import 'package:foodie_driver/model/mail_setting.dart';
import 'package:location/location.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

const FINISHED_ON_BOARDING = 'finishedOnBoarding';
LocationData? locationDataFinal;

const COLOR_ACCENT = 0xFF8fd468;
const COLOR_PRIMARY_DARK = 0xFF2c7305;
// ignore: non_constant_identifier_names
var COLOR_PRIMARY = 0xffFF683A;
const DARK_VIEWBG_COLOR = 0xff191A1C;
const DARK_CARD_BG_COLOR = 0xff242528; // 0xFF5EA23A;
const FACEBOOK_BUTTON_COLOR = 0xFF415893;
const USERS = 'users';
const REPORTS = 'reports';
const CATEGORIES = 'vendor_categories';
const VENDORS = 'vendors';
const PRODUCTS = 'vendor_products';
const Setting = 'settings';
const CONTACT_US = 'ContactUs';
const ORDERS = 'restaurant_orders';
const OrderTransaction = "order_transactions";
const driverPayouts = "driver_payouts";
const REFERRAL = 'referral';
const dynamicNotification = 'dynamic_notification';
const emailTemplates = 'email_templates';

const walletTopup = "wallet_topup";
const newVendorSignup = "new_vendor_signup";
const payoutRequestStatus = "payout_request_status";
const payoutRequest = "payout_request";
const newOrderPlaced = "new_order_placed";

const SECOND_MILLIS = 1000;
const MINUTE_MILLIS = 60 * SECOND_MILLIS;
const HOUR_MILLIS = 60 * MINUTE_MILLIS;
const SERVER_KEY = 'AAAAIwpRrj8:APA91bEhuNv9PEcdmAG6aS1XbdG9sdud4MTbREky_BnrpFpT9l12r4fCRFgqT2fDcuKOPI6-DgMiU7wTc1pPheAvwPY0LftXhsDsslX4DVWn5Vk_1p16dlchetUFuKagRnEkQlQKwRsu';
String GOOGLE_API_KEY = 'AIzaSyDX2aEkrEXqRDGS9BLfICMpDXGvYgEIcew';

bool isRazorPayEnabled = false;
bool isRazorPaySandboxEnabled = false;
String razorpayKey = "";
String razorpaySecret = "";

String placeholderImage = 'https://firebasestorage.googleapis.com/v0/b/grubb-ba0e4.appspot.com/o/app_logo%20copy.png?alt=media&token=64b5554c-9ad3-472f-8b15-fc110484d545';

// const GlobalURL = "http://13.233.108.89/admin_panel/";
const GlobalURL = "https://grubb.co.in/admin_panel/";

const ORDER_STATUS_PLACED = 'Order Placed';
const ORDER_STATUS_ACCEPTED = 'Order Accepted';
const ORDER_STATUS_REJECTED = 'Order Rejected';
const ORDER_STATUS_DRIVER_PENDING = 'Driver Pending';
const ORDER_STATUS_DRIVER_ACCEPTED = 'Driver Accepted';
const ORDER_STATUS_DRIVER_REJECTED = 'Driver Rejected';
const ORDER_STATUS_SHIPPED = 'Order Shipped';
const ORDER_STATUS_IN_TRANSIT = 'In Transit';
const ORDER_STATUS_COMPLETED = 'Order Completed';

const USER_ROLE_DRIVER = 'driver';

const DEFAULT_CAR_IMAGE = 'https://firebasestorage.googleapis.com/v0/b/grubb-ba0e4.appspot.com/o/place.png?alt=media&token=f790bd03-4182-4b85-bc7f-fe4d8e2d09d7';

const scheduleOrder = "schedule_order";
const dineInPlaced = "dinein_placed";
const dineInCanceled = "dinein_canceled";
const dineInAccepted = "dinein_accepted";
const driverAccepted = "driver_accepted";
const restaurantRejected = "restaurant_rejected";
const driverCompleted = "driver_completed";
const restaurantAccepted = "restaurant_accepted";
const takeawayCompleted = "takeaway_completed";
const orderPlaced = "order_placed";

String minimumDepositToRideAccept = "0.0";
String minimumAmountToWithdrawal = "0.0";
String referralAmount = "0.0";
const Wallet = "wallet";
const Currency = 'currencies';

CurrencyModel? currencyModel;

String amountShow({required String? amount}) {
  if (currencyModel!.symbolatright == true) {
    return "${double.parse(amount.toString()).toStringAsFixed(currencyModel!.decimal)} ${currencyModel!.symbol.toString()}";
  } else {
    return "${currencyModel!.symbol.toString()} ${double.parse(amount.toString()).toStringAsFixed(currencyModel!.decimal)}";
  }
}

double calculateTax({String? amount, TaxModel? taxModel}) {
  double taxAmount = 0.0;
  if (taxModel != null && taxModel.enable == true) {
    if (taxModel.type == "fix") {
      taxAmount = double.parse(taxModel.tax.toString());
    } else {
      taxAmount = (double.parse(amount.toString()) * double.parse(taxModel.tax!.toString())) / 100;
    }
  }
  return taxAmount;
}

double getDoubleVal(dynamic input) {
  if (input == null) {
    return 0.1;
  }

  if (input is int) {
    return double.parse(input.toString());
  }

  if (input is double) {
    return input;
  }
  return 0.1;
}

MailSettings? mailSettings;
// logs.log(newString);
// String username = 'foodie@siswebapp.com';
// String password = "8#bb\$1)E@#f3";

final smtpServer = SmtpServer(mailSettings!.host.toString(),
    username: mailSettings!.userName.toString(), password: mailSettings!.password.toString(), port: 465, ignoreBadCertificate: false, ssl: true, allowInsecure: true);

sendMail({String? subject, String? body, bool? isAdmin = false, List<dynamic>? recipients}) async {
  // Create our message.
  if (isAdmin == true) {
    recipients!.add(mailSettings!.userName.toString());
  }
  final message = Message()
    ..from = Address(mailSettings!.userName.toString(), mailSettings!.fromName.toString())
    ..recipients = recipients!
    ..subject = subject
    ..text = body
    ..html = body;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print(e);
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
