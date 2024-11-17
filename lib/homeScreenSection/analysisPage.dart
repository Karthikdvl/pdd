import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analysis Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AnalysisPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

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
          'Analysis',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ingredient Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          color: Colors.green,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 25,
                          color: Colors.orange,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 20,
                          color: Colors.red,
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: 15,
                          color: Colors.grey,
                          title: '',
                          radius: 50,
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      LegendItem(color: Colors.green, label: 'Good'),
                      LegendItem(color: Colors.orange, label: 'Half \'N Half'),
                      LegendItem(color: Colors.red, label: 'Bad'),
                      LegendItem(color: Colors.grey, label: 'NR'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Product Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: const [
                IngredientItem(
                  name: 'Butylphenyl methylpropional',
                  color: Colors.red,
                ),
                IngredientItem(
                  name: 'Cocamide DEA',
                  color: Colors.red,
                ),
                IngredientItem(
                  name: 'Diazolidinyl urea',
                  color: Colors.red,
                ),
                IngredientItem(
                  name: 'Sodium laureth sulfate',
                  color: Colors.orange,
                ),
                IngredientItem(
                  name: 'Propylene Glycol',
                  color: Colors.green,
                ),
                IngredientItem(
                  name: 'Sodium',
                  color: Colors.green,
                ),
                IngredientItem(
                  name: 'Benzyl salicylate',
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement chat functionality
        },
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class IngredientItem extends StatelessWidget {
  final String name;
  final Color color;

  const IngredientItem({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            // Handle ingredient tap
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Text(
              name,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}