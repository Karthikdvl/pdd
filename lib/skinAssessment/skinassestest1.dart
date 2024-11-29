import 'package:flutter/material.dart';

void main() {
  runApp(SkinAssessmentApp());
}

class SkinAssessmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinQuestionnaire(),
    );
  }
}

class SkinQuestionnaire extends StatefulWidget {
  @override
  _SkinQuestionnaireState createState() => _SkinQuestionnaireState();
}

class _SkinQuestionnaireState extends State<SkinQuestionnaire> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Assessment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('What is your name?', 'name'),
              buildDropdown(
                'How old are you?',
                'age',
                ['Below 18', '18–25', '26–35', '36–50', 'Above 50'],
              ),
              buildDropdown(
                'What is your skin type?',
                'skin_type',
                ['Dry', 'Oily', 'Combination', 'Normal'],
              ),
              buildDropdown(
                'How sensitive is your skin?',
                'skin_sensitivity',
                ['Not sensitive', 'Mildly sensitive', 'Very sensitive'],
              ),
              buildMultiSelect(
                'What are your primary skin concerns?',
                'skin_concerns',
                [
                  'Acne',
                  'Wrinkles or fine lines',
                  'Dark spots or pigmentation',
                  'Redness or irritation',
                  'Dullness',
                  'Dryness',
                  'Oiliness',
                ],
              ),
              buildTextField(
                'Do you have any known allergies to skincare ingredients?',
                'allergies',
              ),
              buildDropdown(
                'What is your skincare routine preference?',
                'routine_preference',
                ['Minimal (1–2 products)', 'Moderate (3–4 products)', 'Detailed (5+ products)'],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String question, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: question),
        onSaved: (value) => _answers[key] = value ?? '',
      ),
    );
  }

  Widget buildDropdown(String question, String key, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: question),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) => _answers[key] = value,
      ),
    );
  }

  Widget buildMultiSelect(String question, String key, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 10.0,
            children: options.map((option) {
              return FilterChip(
                label: Text(option),
                selected: _answers[key]?.contains(option) ?? false,
                onSelected: (isSelected) {
                  setState(() {
                    if (_answers[key] == null) _answers[key] = [];
                    if (isSelected) {
                      _answers[key].add(option);
                    } else {
                      _answers[key].remove(option);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('User responses: $_answers');
      // Add HTTP POST request to submit data to the Flask endpoint
    }
  }
}
