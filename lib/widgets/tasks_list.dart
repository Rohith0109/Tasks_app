import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {

  Future<String?> _getUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;
    return uid;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks() async* {
    final String? uid = await _getUserId();
    if (uid != null) {
      final CollectionReference tasksRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks');
      yield* tasksRef.orderBy('timestamp', descending: true).snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
    }
  }

  void deleteTask(DocumentReference taskRef){
    taskRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getTasks(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(child: const Center(child: CircularProgressIndicator()));
        }
        final tasks = snapshot.data?.docs;
        if (tasks==null || tasks.isEmpty) {
          return Container(child: const Center(child: Text('No tasks found!')));
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            final task = tasks[index].data();
            if (task['task']!=null) {
              final taskRef = tasks[index].reference;
              return ListTile(
                title: Text(task['task']),
                trailing: IconButton(
                  onPressed: (){
                    deleteTask(taskRef);
                  },
                  icon: Icon(Icons.delete, color: Colors.red,),
                ),
              );
            }
          },
        );
      },
    );
  }
}
