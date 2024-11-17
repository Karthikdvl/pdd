import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skincare Product Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProductDetailPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Combination Skin',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Salicylic Acid 2% Solution',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                image: const DecorationImage(
                  image: NetworkImage('placeholder_image_url'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Salicylic Acid 2% Solution is a water-based serum with an optimal concentration of salicylic acid that works to clear acne and prevent future breakouts. It also helps fade dead skin cells that can clog pores. Anti-forerunner B controls excess oil production and helps minimize congestion, giving you a brighter, clearer skin.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SectionTitle(title: 'How to Use'),
            const UsageInstructions(),
            const SectionTitle(title: 'When to Use'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Use in PM\n12 months after opening',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SectionTitle(title: 'DO NOT USE WITH'),
            const ConflictingIngredients(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement add to routine functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ADD TO ROUTINE',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class UsageInstructions extends StatelessWidget {
  const UsageInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    final instructions = [
      'Apply once daily in the evening',
      'Apply a small dot to the target area or apply a small amount evenly across face',
      'Do not use on broken or sensitive skin',
      'Avoid contact with eyes and mouth',
      'Patch testing prior to use is advised. Apply the product as directed to a small area (2-3 cm) to test for adverse reactions before applying to a larger area',
      'If persistent irritation occurs, discontinue use',
      'If you experience irritation or difficulty breathing, rinse off, cease use, and consult a physician right away',
      'Sunburn Alert: This product contains a beta-hydroxy acid (BHA) that may increase your skin\'s sensitivity to sunburn. Use sunscreen and limit sun exposure while using this product and for a week afterwards.',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: instructions.map((instruction) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(
                child: Text(instruction),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class ConflictingIngredients extends StatelessWidget {
  const ConflictingIngredients({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredients = [
      'Copper Peptides',
      'Niacinamide Powder',
      'Direct Acids',
      'Pure Vitamin C',
      'EUK',
      'Peptides',
      'Retinoids',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: ingredients.map((ingredient) => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(ingredient),
        )).toList(),
      ),
    );
  }
}