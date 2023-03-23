import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supppro/providers/app_state.dart';

class PurposeSelectionPage extends StatefulWidget {
  @override
  _PurposeSelectionPageState createState() => _PurposeSelectionPageState();
}

class _PurposeSelectionPageState extends State<PurposeSelectionPage> {
  List<String> _selectedPurposes = [];

  void _togglePurpose(String purpose) {
    setState(() {
      if (_selectedPurposes.contains(purpose)) {
        _selectedPurposes.remove(purpose);
      } else {
        _selectedPurposes.add(purpose);
      }
    });
  }

  void _saveSelection(BuildContext context) {
    String selectedPurposesString = _selectedPurposes.join(', ');
    print(selectedPurposesString);
    Provider.of<ApplicationState>(context, listen: false)
        .addPersonalGoals(selectedPurposesString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Purpose'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildPurposeButton('Release Stress', Icons.mood_bad_outlined),
          _buildPurposeButton('Better Sleep', Icons.nightlight_round),
          _buildPurposeButton(
              'Boost Energy', Icons.battery_charging_full_rounded),
          _buildPurposeButton('Improve Memory', Icons.memory),
          _buildPurposeButton('Enhance Focus', Icons.remove_red_eye),
          _buildPurposeButton('Support Immunity', Icons.favorite),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveSelection(context),
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _buildPurposeButton(String purpose, IconData iconData) {
    bool isSelected = _selectedPurposes.contains(purpose);
    Color buttonColor =
        isSelected ? Theme.of(context).colorScheme.primary : Colors.white;
    Color textColor = isSelected ? Colors.white : Colors.black;
    return InkWell(
      onTap: () => _togglePurpose(purpose),
      child: Card(
        color: buttonColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 48, color: textColor),
            SizedBox(height: 8),
            Text(
              purpose,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
