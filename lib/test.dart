
import 'package:flutter/material.dart';

class ExpandableItem extends StatefulWidget {
  final String title;
  final String expandedText;

  ExpandableItem({required this.title, required this.expandedText});

  @override
  _ExpandableItemState createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<ExpandableItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(fontSize: 18)),
          if (isExpanded) Text(widget.expandedText),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Expandable Items')),
      body: Column(
        children: [
          ExpandableItem(
            title: 'Cliquez pour afficher le contenu',
            expandedText: 'Contenu supplémentaire',
          ),
          ExpandableItem(
            title: 'Autre élément',
            expandedText: 'Plus de contenu ici',
          ),
        ],
      ),
    ),
  ));
}



  // Future<void> deleteDatabaseFile() async {
  //   try {
  //     final databasesPath = await getDatabasesPath();
  //     print(databasesPath);
  //     final path = join(databasesPath,
  //         'sqlite_master'); // Remplacez 'your_database.db' par le nom de votre base de données

  //     await deleteDatabase(path);

  //     print('Database deleted successfully');
  //   } catch (e) {
  //     print('Error deleting database: $e');
  //   }
  // }