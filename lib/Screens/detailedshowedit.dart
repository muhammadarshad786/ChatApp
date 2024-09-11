import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internship_firebase/Notification/notification.dart';
import 'package:internship_firebase/Screens/homescreen.dart';
import 'package:internship_firebase/ServerSide/function.dart';


class Editpage extends StatelessWidget {
  final String Email;


  Editpage({
    Key? key,
    required this.Email,
  }) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<DocumentSnapshot> getdataofsingle() async{
   return await AddEMPLOYEEDATA().FetchSingleEmployee(Email);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Edit Profile'),

      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
           
                // Center(
                //   child: Image.network(
                //     image,
                //     height: 200,
                //     width: 200,
                //     fit: BoxFit.cover,
                //     errorBuilder: (context, error, stackTrace) {
                     
                //       return const Icon(Icons.error);
                //     },
                //   ),
                // ),
          
          
            child:  FutureBuilder<DocumentSnapshot>(
            future: getdataofsingle(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No Data Found'));
              } else {
                var doc = snapshot.data!;
                return Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter New Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Name: ${doc['Name']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text('DOB: ${doc['DOB']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text('Email: ${doc['Email']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  AddEMPLOYEEDATA().update(_nameController.text, doc['Email']);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(email: Email)),
                  );
                },
                child: const Text('Update'),
              ),
            ),
            TextButton(
              onPressed: () {
                PushNotificationFireBase().showNotification(
                  title: 'hello local',
                  body: 'test the local notification'
                );
              },
              child: const Text('local notification')
            )
          ],
                );
              }
            }
          )
          
          
          
              
            ),
        )
        ),
      );
    
  }
}