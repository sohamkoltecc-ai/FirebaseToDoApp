import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/Pages/about_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get uid => auth.currentUser!.uid;

  Future<void> addTask() async {
    if (controller.text.trim().isEmpty) return;

    await firestore.collection("users").doc(uid).collection("tasks").add({
      "title": controller.text.trim(),
      "done": false,
      "createdAt": FieldValue.serverTimestamp(),
    });

    controller.clear();
  }

  Future<void> toggleTask(String taskId, bool currentValue) async {
    await firestore
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .doc(taskId)
        .update({"done": !currentValue});
  }

  Future<void> deleteTask(String taskId) async {
    await firestore
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .doc(taskId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text("Tasks", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection("users")
                  .doc(uid)
                  .collection("tasks")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Tasks Yet", style: TextStyle(fontSize: 22)),
                  );
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    final title = task["title"];

                    final done = task["done"];

                    final taskId = task.id;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: done,
                          onChanged: (_) {
                            toggleTask(taskId, done);
                          },
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            decoration: done
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTask(taskId);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 16.0),
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Enter Task",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Idle color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Idle color
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white, // Change this to your preferred color
              ),

              onPressed: addTask,
              child: const Text("Add", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
