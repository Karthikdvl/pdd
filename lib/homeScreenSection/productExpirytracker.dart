import 'package:flutter/material.dart';
import 'package:ingreskin/config.dart';
import 'package:ingreskin/homeScreenSection/addProductPage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ProductItem {
  final String name;
  final String brand;
  final DateTime openedDate;
  final DateTime expiryDate;

  ProductItem({
    required this.name,
    required this.brand,
    required this.openedDate,
    required this.expiryDate,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      name: json['name'] as String,
      brand: json['brand'] as String,
      openedDate: DateTime.parse(json['opened_date'] as String),
      expiryDate: DateTime.parse(json['expiry_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'opened_date': openedDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
    };
  }
}

class ProductExpiryTrackerPage extends StatefulWidget {
  const ProductExpiryTrackerPage({Key? key}) : super(key: key);

  @override
  _ProductExpiryTrackerPageState createState() =>
      _ProductExpiryTrackerPageState();
}

class _ProductExpiryTrackerPageState extends State<ProductExpiryTrackerPage> {
  final List<ProductItem> _products = [];
  final String _userEmail = 'abc@example.com';
  final String _baseUrl = '$BASE_URL';
  bool _isNotificationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications().then((_) {
      _loadProductTracking();
    });
  }

  Future<void> _initializeNotifications() async {
    if (_isNotificationsInitialized) return;

    tzData.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          debugPrint('Notification tapped: ${response.payload}');
        },
      );

      if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }

      setState(() {
        _isNotificationsInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _loadProductTracking() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_product_tracking?user_email=$_userEmail'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products.addAll(data.map((json) => ProductItem.fromJson(json)).toList());
        });
        for (var product in _products) {
          await _scheduleNotification(product);
        }
      }
    } catch (e) {
      print('Error fetching product tracking data: $e');
    }
  }

  Future<void> _scheduleNotification(ProductItem product) async {
    if (!_isNotificationsInitialized) return;

    final DateTime expiryDate = product.expiryDate.subtract(const Duration(days: 30));
    final DateTime now = DateTime.now();

    if (expiryDate.isAfter(now)) {
      try {
        final int notificationId = product.hashCode;
        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          'product_expiry_channel',
          'Product Expiry Alerts',
          channelDescription: 'Notifications for products nearing expiry',
          importance: Importance.high,
          priority: Priority.high,
        );

        const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const NotificationDetails details = NotificationDetails(
          android: androidDetails,
          iOS: iOSDetails,
        );

        final tz.TZDateTime tzExpiryDate = tz.TZDateTime.from(expiryDate, tz.local);

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          'Expiry Alert: ${product.name}',
          'The product "${product.name}" will expire in 30 days.',
          tzExpiryDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }
    }
  }

  Future<void> _addProductToBackend(ProductItem product) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add_product_tracking'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          ...product.toJson(),
          'user_email': _userEmail,
        }),
      );

      // Log the response status and body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Product added successfully!');
      } else {
        print('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  void _addNewProduct() async {
    final result = await Navigator.push<ProductItem>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductPage(),
      ),
    );
    if (result != null) {
      setState(() {
        _products.add(result);
      });
      _addProductToBackend(result); // Add the product to the backend
    }
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Expiry Tracker'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Skincare Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(_products[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey[700],
      ),
    );
  }

  Widget _buildProductCard(ProductItem product, int index) {
    final daysRemaining = product.expiryDate.difference(DateTime.now()).inDays;
    Color statusColor = _getStatusColor(daysRemaining);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      product.brand,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _removeProduct(index),
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opened: ${DateFormat('MMM dd, yyyy').format(product.openedDate)}',
                ),
                Text(
                  'Expires: ${DateFormat('MMM dd, yyyy').format(product.expiryDate)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$daysRemaining days remaining',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusIndicator(statusColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Color _getStatusColor(int daysRemaining) {
    if (daysRemaining <= 30) return Colors.red;
    if (daysRemaining <= 60) return Colors.orange;
    return Colors.green;
  }
}
