import 'package:cr_app/features/semesters/presentation/views/resource_list_view/resource_list_view.dart';
import 'package:flutter/material.dart';

class SubjectListView extends StatelessWidget {
  const SubjectListView({super.key});


  @override
  Widget build(BuildContext context) {
    final List<String> subjectsOfSemester = ["Eng. Economics", "Financial", "Physics", "Bangladesh Studies"];
    final List<String> availableResource = ["4 files", "2 files", "1 files", "3 files"];
    return Scaffold(
      appBar: AppBar(
        title: Text("1st semester"),
      ),

      // BODY
      body: SafeArea(child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: subjectsOfSemester.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResourceListView(subjects: subjectsOfSemester)));
                      },
                      child: ListTile(
                        title: Text(subjectsOfSemester[index]),
                        subtitle: Text(availableResource[index]),
                        leading: Icon(Icons.save),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                }),
          )
        ],
      )),
    );
  }
}
