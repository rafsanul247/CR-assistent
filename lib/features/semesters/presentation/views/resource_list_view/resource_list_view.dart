import 'package:flutter/material.dart';

class ResourceListView extends StatelessWidget {
  const ResourceListView({super.key, required this.subjects});

  final List<String> subjects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eng. Economics"),
      ),

      // BODY
      body: SafeArea(child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("FILES"),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResourceListView(subjects: subjects)));
              },
              child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text("Class PDF 1"),
                        subtitle: Text("PDF"),
                        leading: Icon(Icons.picture_as_pdf),
                      ),
                    );
                  }),
            ),
          )
        ],
      )),
    );
  }
}
