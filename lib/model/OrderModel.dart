import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_driver/model/AddressModel.dart';
import 'package:foodie_driver/model/OrderProductModel.dart';
import 'package:foodie_driver/model/User.dart';
import 'package:foodie_driver/model/VendorModel.dart';

import 'TaxModel.dart';

class OrderModel {
  String authorID, paymentMethod;

  User author;

  User? driver;

  String? driverID;
  String? vendoraccepttime;
  String? driverpickedtime;
  String? totaltimediffert;

  List<OrderProductModel> products;

  Timestamp createdAt;

  String vendorID;

  VendorModel vendor;

  String status;

  AddressModel address;

  String id;
  num? discount;
  String? couponCode;
  String? couponId, notes;

  // var extras = [];
  //String? extra_size;
  String? tipValue;
  String? adminCommission;
  String? groceryWeight;
  String? item;
  String? groceryUnit;
  String? adminCommissionType;
  final bool? takeAway;
  List<TaxModel>? taxModel;
  String? deliveryCharge;
  Map<String, dynamic>? specialDiscount;
  Timestamp? triggerDelevery;
  String? estimatedTimeToPrepare;
  Timestamp? scheduleTime;
  List<dynamic>? rejectedByDrivers = [];

  OrderModel(
      {address,
      author,
      this.driver,
      this.driverID,
      this.vendoraccepttime,
      this.driverpickedtime,
      this.totaltimediffert,
      this.authorID = '',
      this.paymentMethod = '',
      createdAt,
      this.id = '',
      this.item,
      this.groceryWeight,
      this.groceryUnit,
      this.products = const [],
      this.status = '',
      this.discount = 0,
      this.couponCode = '',
      this.couponId = '',
      this.notes = '',
      vendor,
      /*this.extras = const [], this.extra_size,*/ this.tipValue,
      this.adminCommission,
      this.takeAway = false,
      this.adminCommissionType,
      this.deliveryCharge,
      this.specialDiscount,
      this.vendorID = '',
      this.triggerDelevery,
      this.estimatedTimeToPrepare,
      this.scheduleTime,
      this.rejectedByDrivers,
      this.taxModel})
      : this.address = address ?? AddressModel(),
        this.author = author ?? User(),
        this.createdAt = createdAt ?? Timestamp.now(),
        this.vendor = vendor ?? VendorModel();

  // factory OrderModel.fromJson(Map<String, dynamic> parsedJson) {
  //   List<OrderProductModel> products =
  //       parsedJson.containsKey('products') ? List<OrderProductModel>.from((parsedJson['products'] as List<dynamic>).map((e) => OrderProductModel.fromJson(e))).toList() : [].cast<OrderProductModel>();
  //
  //
  //   List<TaxModel>? taxList;
  //   if (parsedJson['taxSetting'] != null) {
  //     taxList = <TaxModel>[];
  //     parsedJson['taxSetting'].forEach((v) {
  //       taxList!.add(TaxModel.fromJson(v));
  //     });
  //   }
  //
  //   return OrderModel(
  //     address: parsedJson.containsKey('address') ? AddressModel.fromJson(parsedJson['address']) : AddressModel(),
  //     author: parsedJson.containsKey('author') ? User.fromJson(parsedJson['author']) : User(),
  //     authorID: parsedJson['authorID'] ?? '',
  //     createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
  //     id: parsedJson['id'] ?? '',
  //     products: products,
  //     status: parsedJson['status'] ?? '',
  //     discount: double.parse(parsedJson['discount'].toString()),
  //     couponCode: parsedJson['couponCode'] ?? '',
  //     couponId: parsedJson['couponId'] ?? '',
  //     notes: (parsedJson["notes"] != null && parsedJson["notes"].toString().isNotEmpty) ? parsedJson["notes"] : "",
  //     vendor: parsedJson.containsKey('vendor') ? VendorModel.fromJson(parsedJson['vendor']) : VendorModel(),
  //     vendorID: parsedJson['vendorID'] ?? '',
  //     driver: parsedJson.containsKey('driver')
  //         ? parsedJson['driver'] != null
  //             ? User.fromJson(parsedJson['driver'])
  //             : null
  //         : null,
  //     driverID: parsedJson.containsKey('driverID') ? parsedJson['driverID'] : null,
  //     adminCommission: parsedJson["adminCommission"] != null ? parsedJson["adminCommission"] : "",
  //     adminCommissionType: parsedJson["adminCommissionType"] != null ? parsedJson["adminCommissionType"] : "",
  //     tipValue: parsedJson["tip_amount"] != null ? parsedJson["tip_amount"] : "",
  //     specialDiscount: parsedJson["specialDiscount"] ?? {},
  //
  //     takeAway: parsedJson["takeAway"] != null ? parsedJson["takeAway"] : false,
  //     //extras: parsedJson["extras"]!=null?parsedJson["extras"]:[],
  //     // extra_size: parsedJson["extras_price"]!=null?parsedJson["extras_price"]:"",
  //     deliveryCharge: parsedJson["deliveryCharge"],
  //     paymentMethod: parsedJson["payment_method"] ?? '',
  //     estimatedTimeToPrepare: parsedJson["estimatedTimeToPrepare"] ?? '',
  //     triggerDelevery: parsedJson["triggerDelevery"] ?? Timestamp.now(),
  //     scheduleTime: parsedJson["scheduleTime"],
  //     rejectedByDrivers: parsedJson["rejectedByDrivers"],
  //     taxModel: taxList,
  //   );
  // }
  factory OrderModel.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderProductModel> products = [];
    if (parsedJson.containsKey('products') && parsedJson['products'] is List) {
      products = (parsedJson['products'] as List)
          .map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<TaxModel>? taxList;
    if (parsedJson['taxSetting'] != null && parsedJson['taxSetting'] is List) {
      taxList = (parsedJson['taxSetting'] as List)
          .map((v) => TaxModel.fromJson(v as Map<String, dynamic>))
          .toList();
    }

    return OrderModel(
      address: parsedJson.containsKey('address') &&
              parsedJson['address'] is Map<String, dynamic>
          ? AddressModel.fromJson(parsedJson['address'])
          : AddressModel(),
      author: parsedJson.containsKey('author') &&
              parsedJson['author'] is Map<String, dynamic>
          ? User.fromJson(parsedJson['author'])
          : User(),
      authorID: parsedJson['authorID'] ?? '',
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
      id: parsedJson['id'] ?? '',
      products: products,
      status: parsedJson['status'] ?? '',
      discount: double.parse(parsedJson['discount']?.toString() ?? '0.0'),
      couponCode: parsedJson['couponCode'] ?? '',
      couponId: parsedJson['couponId'] ?? '',
      notes: parsedJson["notes"] != null &&
              parsedJson["notes"].toString().isNotEmpty
          ? parsedJson["notes"]
          : "",
      vendor: parsedJson.containsKey('vendor') &&
              parsedJson['vendor'] is Map<String, dynamic>
          ? VendorModel.fromJson(parsedJson['vendor'])
          : VendorModel(),
      vendorID: parsedJson['vendorID'] ?? '',
      driver: parsedJson.containsKey('driver') &&
              parsedJson['driver'] is Map<String, dynamic>
          ? User.fromJson(parsedJson['driver'])
          : null,
      driverID: parsedJson['driverID'] ?? null,
      vendoraccepttime: parsedJson['vendoraccepttime'] ?? "",
      driverpickedtime: parsedJson['driverpickedtime'] ?? "",
      totaltimediffert: parsedJson['totaltimediffert'] ?? "",
      item: parsedJson["item"] != null ? parsedJson["item"] : "",
      groceryUnit:
          parsedJson["groceryUnit"] != null ? parsedJson["groceryUnit"] : "",
      groceryWeight: parsedJson["groceryWeight"] != null
          ? parsedJson["groceryWeight"]
          : "",
      adminCommission: parsedJson["adminCommission"]?.toString() ?? "",
      adminCommissionType: parsedJson["adminCommissionType"]?.toString() ?? "",
      tipValue: parsedJson["tip_amount"]?.toString() ?? "",
      specialDiscount: parsedJson["specialDiscount"] ?? {},
      takeAway: parsedJson["takeAway"] ?? false,
      deliveryCharge: parsedJson["deliveryCharge"],
      paymentMethod: parsedJson["payment_method"] ?? '',
      estimatedTimeToPrepare: parsedJson["estimatedTimeToPrepare"] ?? '',
      triggerDelevery: parsedJson["triggerDelevery"] ?? Timestamp.now(),
      scheduleTime: parsedJson["scheduleTime"],
      rejectedByDrivers: parsedJson["rejectedByDrivers"],
      taxModel: taxList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': this.address.toJson(),
      'author': this.author.toJson(),
      'authorID': this.authorID,
      'createdAt': this.createdAt,
      'payment_method': this.paymentMethod,
      'id': this.id,
      'products': this.products.map((e) => e.toJson()).toList(),
      'status': this.status,
      'discount': this.discount,
      'couponCode': this.couponCode,
      'couponId': this.couponId,
      'notes': this.notes,
      'vendor': this.vendor.toJson(),
      'vendorID': this.vendorID,
      'adminCommission': this.adminCommission,
      'adminCommissionType': this.adminCommissionType,
      "tip_amount": this.tipValue,
      'item': this.item,
      'groceryWeight': this.groceryWeight,
      'groceryUnit': this.groceryUnit,
      "taxSetting":
          taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null,
      "takeAway": this.takeAway,
      "deliveryCharge": this.deliveryCharge,
      "specialDiscount": this.specialDiscount,
      "triggerDelevery": this.triggerDelevery,
      "driverID": this.driverID,
      "vendoraccepttime": this.vendoraccepttime,
      "driverpickedtime": this.driverpickedtime,
      "totaltimediffert": this.totaltimediffert,
      "driver": driver != null ? this.driver!.toJson() : null,
      "estimatedTimeToPrepare": this.estimatedTimeToPrepare,
      "scheduleTime": this.scheduleTime,
      "rejectedByDrivers": this.rejectedByDrivers,
    };
  }
}
