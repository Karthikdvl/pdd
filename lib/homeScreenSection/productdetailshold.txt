import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Back Button
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      'assets/productDetailimage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Safe Area for Back Button
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Skin Screen Title
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Sun screen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Safety Rating Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Safety rating',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rating number and stars
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '3',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Good section (3 green stars)
                                Row(
                                  children: List.generate(
                                    3,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Moderate section (3 yellow stars)
                                Row(
                                  children: List.generate(
                                    3,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Bad section (2 orange-red stars)
                                Row(
                                  children: List.generate(
                                    2,
                                    (index) => Icon(
                                      Icons.star,
                                      color: Colors.orange[700],
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Danger section (2 red stars)
                                Row(
                                  children: List.generate(
                                    2,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Labels row
                      Padding(
                        padding: const EdgeInsets.only(left: 36.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Good',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Moderate',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Bad',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Danger',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Description Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Text('view analysis >'),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'NIACINAMIDE WHITENING GLOWING SKIN SERUM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A mild exfoliating toner that is formulated to be safe for use every day. Contains the best quality Glycolic Acid to help brighten the skin. The antibacterial acid content helps fight acne and rashes that appear on facial skin. Supported by Niacinamide and Lactobionic Acid to encourage effectiveness in reducing the appearance of pores leaving skin radiant.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}