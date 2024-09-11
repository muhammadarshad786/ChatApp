
import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class AddEMPLOYEEDATA {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> infoEmpADD(String Email, String Name, String Password, String DOB) async {
    await _firestore.collection('Employee Data').doc(Email).set({
      'Email': Email,
      'Name': Name,
      'Password': Password,
      'DOB': DOB,
    });
  }
  Future<DocumentSnapshot> FetchSingleEmployee(String EmailOfPerson)async
  {
     return await _firestore.collection('Employee Data').doc(EmailOfPerson).get();
  } 
  
Future<void> update(String name, String dob) async {
  try {
    await FirebaseFirestore.instance.collection('Employee Data').doc(dob).update({
      'Name': name,
    });
  } catch (e) {
    print('Error updating document: $e');
  
  }
}
  Future<String> uploadImage(XFile image, String userId) async {
    final reference = _storage.ref('${userId}/Assets').child(image.name);
    final task = reference.putFile(File(image.path));
    final snapshot = await task.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Stream<QuerySnapshot> GetEmpinfo(String searchName) {
  if (searchName.isEmpty) {
    return _firestore.collection('Employee Data').snapshots();
  } else {
    return _firestore.collection('Employee Data')
      .where('Name', isGreaterThanOrEqualTo: searchName)
      .where('Name', isLessThan: searchName + 'z')
      .snapshots();
  }
}

  Future<void> fetchImagesAndFoldersFromPrefix(List<String> urls, List<String> folders) async {
    try {
      await _fetchRecursively('', urls, folders);
    } catch (e) {
      print('Error fetching images and folders: $e');
    }
  }

 Future<void> _fetchRecursively(String prefix, List<String> urls, List<String> folders) async {
  try {
    final ListResult result = await _storage.ref(prefix).listAll();

    // Fetch URLs for all files
    for (var item in result.items) {
      String url = await item.getDownloadURL();
          urls.add(url);
    }

    for (var prefixRef in result.prefixes) {
      folders.add(prefixRef.fullPath);
      await _fetchRecursively(prefixRef.fullPath, urls, folders);
    }
  } catch (e) {
    print('Error fetching images and folders: $e');
  }
}





}



// class Chart{

//   final FirebaseFirestore _firebase = FirebaseFirestore.instance;

//   Future <void> ConversionBWEmployee(String BothIdGet,String text,String Sender,String Reciver) async{

//       await _firebase.collection('conversations').doc(BothIdGet).collection('messages').add({
//       'senderId': Sender,
//       'receiverId': Reciver,
//       'message': text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//   }

//    Stream<QuerySnapshot> GetConversation(String email1,String email2) 
//   {

//   String forwardId = '${email1}${email2}';
//   String reverseId = '${email2}${email1}';


//     Stream<QuerySnapshot> forwardStream = _firebase
//       .collection('conversations')
//       .doc(forwardId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .snapshots();


//       Stream<QuerySnapshot> reverseStream = _firebase
//       .collection('conversations')
//       .doc(reverseId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .snapshots();

//    return StreamGroup.merge([forwardStream, reverseStream]);

//   }


// }



// class Chart {
//   final FirebaseFirestore _firebase = FirebaseFirestore.instance;

//   Future<void> ConversionBWEmployee(String BothIdGet, String text, String Sender, String Reciver) async {
//     return _firebase.runTransaction((transaction) async {

//      final docall= _firebase.collection('conversations').doc(BothIdGet).collection('messages').doc();

//       transaction.set(docall,
//       {
//         'senderId': Sender,
//         'receiverId': Reciver,
//         'message': text,
//         'timestamp': FieldValue.serverTimestamp(),
//       }
      
      
       
//       );

//     });
//     // await _firebase.collection('conversations').doc(BothIdGet).collection('messages').add({
//     //   'senderId': Sender,
//     //   'receiverId': Reciver,
//     //   'message': text,
//     //   'timestamp': FieldValue.serverTimestamp(),
//     // });
//   }

// Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> GetConversation(String email1, String email2) {
//   String forwardId = '${email1}${email2}';
//   String reverseId = '${email2}${email1}';




//   Stream<QuerySnapshot<Map<String, dynamic>>> forwardStream = _firebase
//       .collection('conversations')
//       .doc(forwardId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .snapshots();

//   Stream<QuerySnapshot<Map<String, dynamic>>> reverseStream = _firebase
//       .collection('conversations')
//       .doc(reverseId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .snapshots();

//   return Rx.combineLatest2(
//     forwardStream,
//     reverseStream,
//     (QuerySnapshot<Map<String, dynamic>> a, QuerySnapshot<Map<String, dynamic>> b) {
//       List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = [...a.docs, ...b.docs];
      
//       // Handle sorting with null check
//       allDocs.sort((a, b) {
//         Timestamp? timestampA = a['timestamp'] as Timestamp?;
//         Timestamp? timestampB = b['timestamp'] as Timestamp?;

//         if (timestampA == null && timestampB == null) return 0;
//         if (timestampA == null) return 1;
//         if (timestampB == null) return -1;
//         return timestampB.compareTo(timestampA);
//       });


     

//       return allDocs;
//     }
//   );
// }

// }




class Chart {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  Future<void> ConversionBWEmployee(String BothIdGet, String text, String Sender, String Reciver) async {
    return _firebase.runTransaction((transaction) async {
      final docRef = _firebase.collection('conversations').doc(BothIdGet).collection('messages').doc();
      
      transaction.set(docRef, {
        'senderId': Sender,
        'receiverId': Reciver,
        'message': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> GetConversation(String email1, String email2) {
    String forwardId = '${email1}${email2}';
    String reverseId = '${email2}${email1}';
    
    Stream<QuerySnapshot<Map<String, dynamic>>> forwardStream = _firebase
      .collection('conversations')
      .doc(forwardId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> reverseStream = _firebase
      .collection('conversations')
      .doc(reverseId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();

    return Rx.combineLatest2(
      forwardStream,
      reverseStream,
      (QuerySnapshot<Map<String, dynamic>> a, QuerySnapshot<Map<String, dynamic>> b) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = [...a.docs, ...b.docs];

        allDocs.sort((a, b) {
          Timestamp? timestampA = a['timestamp'] as Timestamp?;
          Timestamp? timestampB = b['timestamp'] as Timestamp?;

          if (timestampA == null && timestampB == null) return 0;
          if (timestampA == null) return 1;
          if (timestampB == null) return -1;
          return timestampB.compareTo(timestampA);
        });
        
        return allDocs;
      }
    );
  }
}