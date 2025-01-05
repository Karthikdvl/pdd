import 'package:flutter/material.dart';

class AnalysisPage extends StatefulWidget {
  final Map<String, dynamic> result;

  const AnalysisPage({super.key, required this.result});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  Widget build(BuildContext context) {
    // Extract data from the result map
    final cleanIngredients = widget.result['clean_ingredients'] ?? [];
    final badIngredients = widget.result['bad_ingredients'] ?? [];
    final notRecognizedIngredients = widget.result['not_recognized'] ?? [];

    // Check if any data is available
    if (cleanIngredients.isEmpty &&
        badIngredients.isEmpty &&
        notRecognizedIngredients.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Analysis'),
        ),
        body: Center(
          child: Text(
            'No data available for analysis.',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clean Ingredients Section
            const Text(
              'Clean Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            cleanIngredients.isNotEmpty
                ? _buildIngredientList(cleanIngredients, Colors.green.shade200)
                : const Text('No clean ingredients found.',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),

            const SizedBox(height: 16),

            // Bad Ingredients Section
            const Text(
              'Bad Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            badIngredients.isNotEmpty
                ? _buildIngredientList(badIngredients, Colors.red.shade200)
                : const Text('No bad ingredients found.',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),

            const SizedBox(height: 16),

            // Not Recognized Ingredients Section
            const Text(
              'Not Recognized Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            notRecognizedIngredients.isNotEmpty
                ? _buildIngredientList(
                    notRecognizedIngredients, Colors.grey.shade300)
                : const Text('No unrecognized ingredients found.',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientList(List ingredients, Color backgroundColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            ingredients[index],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
