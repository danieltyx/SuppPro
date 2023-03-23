import 'package:flutter/material.dart';

class Purpose {
  final String title;
  final IconData icon;

  Purpose({required this.title, required this.icon});
}

class SelectPurposesPage extends StatefulWidget {
  @override
  _SelectPurposesPageState createState() => _SelectPurposesPageState();
}

class _SelectPurposesPageState extends State<SelectPurposesPage> {
  final List<Purpose> _purposes = [
    Purpose(title: "Release stress", icon: Icons.mood_bad_outlined),
    Purpose(title: "Improve sleep", icon: Icons.bed_outlined),
    Purpose(title: "Boost energy", icon: Icons.bolt_outlined),
    Purpose(title: "Support digestion", icon: Icons.local_dining_outlined),
    Purpose(title: "Enhance focus", icon: Icons.lightbulb_outline),
    Purpose(title: "Improve mood", icon: Icons.emoji_emotions_outlined),
    Purpose(
        title: "Strengthen immunity", icon: Icons.health_and_safety_outlined),
    Purpose(title: "Reduce inflammation", icon: Icons.healing_outlined),
  ];

  final List<Purpose> _rankedPurposes = [];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Purposes"),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _rankedPurposes.length,
              itemBuilder: (context, index, animation) {
                final purpose = _rankedPurposes[index];
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: Card(
                    child: ListTile(
                      leading: Icon(purpose.icon),
                      title: Text(purpose.title),
                      trailing: GestureDetector(
                        child: Icon(Icons.remove_circle),
                        onTap: () {
                          _removePurpose(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _purposes.length,
            itemBuilder: (context, index) {
              final purpose = _purposes[index];
              return GestureDetector(
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(purpose.icon),
                      SizedBox(height: 8),
                      Text(purpose.title),
                    ],
                  ),
                ),
                onLongPress: () {
                  _addPurpose(purpose);
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final rankedTitles =
              _rankedPurposes.map((purpose) => purpose.title).toList();
          final rankedPurposesString = rankedTitles.join(", ");

          // Save rankedPurposesString to database
          // ...
        },
      ),
    );
  }

  void _addPurpose(Purpose purpose) {
    setState(() {
      _rankedPurposes.add(purpose);
      _listKey.currentState!.insertItem(_rankedPurposes.length - 1);
    });
  }

  void _removePurpose(int index) {
    final removedItem = _rankedPurposes.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1, 0),
        ).animate(animation),
        child: Card(
          child: ListTile(
            leading: Icon(removedItem.icon),
            title: Text(removedItem.title),
          ),
        ),
      ),
    );
  }
}
