import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  final List<Map<String, dynamic>> _products = const [
    {
      'name': 'Arduino Uno R3 Starter Kit',
      'price': '₹2,499',
      'imageIcon': Icons.inventory_2,
      'url': 'https://amazon.in',
    },
    {
      'name': 'ESP32 Wi-Fi + Bluetooth Module',
      'price': '₹499',
      'imageIcon': Icons.wifi,
      'url': 'https://amazon.in',
    },
    {
      'name': '37 in 1 Sensor Kit',
      'price': '₹1,299',
      'imageIcon': Icons.sensors,
      'url': 'https://amazon.in',
    },
  ];

  Future<void> _handleBuy(BuildContext context, String productName, String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      await launchUrl(url);
    } catch (_) {}

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Simulate Purchase?'),
          content: Text('Would you like to register "$productName" in your virtual Lab Kit to generate its connection QR Key?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                final prefs = await SharedPreferences.getInstance();
                List<String> list = prefs.getStringList('purchased_components') ?? [];
                if (!list.contains(productName)) {
                  list.add(productName);
                  await prefs.setStringList('purchased_components', list);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"$productName" added to Lab Kit!'),
                      action: SnackBarAction(
                        label: 'View QR',
                        onPressed: () {
                          // No direct view from SnackBar here, prompt user to click QR
                        },
                      ),
                    ),
                  );
                }
              },
              child: const Text('Yes, Add to Kit'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IoT Components Shop')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(product['imageIcon'], size: 40, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['price'],
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _handleBuy(context, product['name'], product['url']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange, // Amazon-like color
                            ),
                            child: const Text('Buy on Amazon'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
