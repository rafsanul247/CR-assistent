import 'package:cr_app/features/semesters/presentation/views/subject_list_view/subject_list_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> semesters = ["1st semester", "2nd semester"];
    List<String> subjects = ["4 subjects", "No resources yet"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("CSE-108 | DIU"),
      ),
      // BODY
      body: SafeArea(
        child: ListView.builder(
          itemCount: semesters.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectListView()));
                },
                child: ListTile(
                  title: Text(semesters[index]),
                  leading: Icon(Icons.book),
                  subtitle: Text(subjects[index]),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}