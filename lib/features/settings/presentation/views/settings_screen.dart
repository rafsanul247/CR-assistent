import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> settingsOption = ["Profile", "Notifications", "Class & Semester", "About CR Assistant"];
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      
      //BODY
      body: SafeArea(child: ListView.builder(
          itemCount: settingsOption.length,
          itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text(settingsOption[index]),
            leading: Icon(Icons.person),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        );
      })),
    );
  }
}
