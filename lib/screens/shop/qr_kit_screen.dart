import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';

class QRKitScreen extends StatefulWidget {
  const QRKitScreen({super.key});

  @override
  State<QRKitScreen> createState() => _QRKitScreenState();
}

class _QRKitScreenState extends State<QRKitScreen> {
  List<String> _purchasedComponents = [];
  bool _isLoading = true;
  String? _selectedComponent;

  @override
  void initState() {
    super.initState();
    _loadPurchasedComponents();
  }

  Future<void> _loadPurchasedComponents() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _purchasedComponents = prefs.getStringList('purchased_components') ?? [];
      if (_purchasedComponents.isNotEmpty) {
        _selectedComponent = _purchasedComponents.first;
      }
      _isLoading = false;
    });
  }

  Future<void> _clearKit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('purchased_components');
    setState(() {
      _purchasedComponents = [];
      _selectedComponent = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Virtual lab kit cleared!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Virtual Lab Kit'),
        actions: [
          if (_purchasedComponents.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Lab Kit?'),
                    content: const Text('This will remove all virtual QR keys from your dashboard.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearKit();
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _purchasedComponents.isEmpty
              ? _buildEmptyState()
              : _buildKitContent(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_2_rounded,
              size: 100,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 24),
            const Text(
              'No QR Keys Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your virtual lab kit is empty. Go to the Shop Components page, simulate a purchase, and add the component to your kit to unlock its virtual QR key!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              label: const Text('Go to Shop'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select a component to generate its virtual connection key:',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Component Dropdown / Selector Card
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedComponent,
                  isExpanded: true,
                  dropdownColor: AppTheme.surfaceColor,
                  items: _purchasedComponents.map((String comp) {
                    return DropdownMenuItem<String>(
                      value: comp,
                      child: Text(comp, style: const TextStyle(color: AppTheme.textPrimary)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedComponent = newValue;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // QR display container
          if (_selectedComponent != null) ...[
            Center(
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        _selectedComponent!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ProceduralQR(data: _selectedComponent!, size: 180),
                      const SizedBox(height: 16),
                      const Text(
                        'Virtual Connection QR Key',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Scan this QR key using your hardware scanner or another phone to automatically pair the ${_selectedComponent!} configuration settings.',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Procedural QR Drawing Widget
class ProceduralQR extends StatelessWidget {
  final String data;
  final double size;

  const ProceduralQR({super.key, required this.data, this.size = 200});

  @override
  Widget build(BuildContext context) {
    // Generate a simple deterministic grid based on the data string hash
    final int hash = data.hashCode;
    
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 15,
          mainAxisSpacing: 1.5,
          crossAxisSpacing: 1.5,
        ),
        itemCount: 15 * 15,
        itemBuilder: (context, index) {
          bool isFilled = false;
          
          int row = index ~/ 15;
          int col = index % 15;
          
          // Top-Left marker
          if (row < 4 && col < 4) {
            isFilled = (row == 0 || row == 3 || col == 0 || col == 3);
          }
          // Top-Right marker
          else if (row < 4 && col >= 11) {
            isFilled = (row == 0 || row == 3 || col == 11 || col == 14);
          }
          // Bottom-Left marker
          else if (row >= 11 && col < 4) {
            isFilled = (row == 11 || row == 14 || col == 0 || col == 3);
          }
          // Center mock data pattern: deterministic based on index and hash
          else {
            isFilled = ((hash ^ (index * 31)) % 3 == 0);
          }

          return Container(
            color: isFilled ? Colors.black : Colors.white,
          );
        },
      ),
    );
  }
}
