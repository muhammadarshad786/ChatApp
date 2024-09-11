import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  bool startAnimation = false;

  List<String> texts = [
    "Monetization",
    "Pie Chart",
    "Flag",
    "Notification",
    "Savings",
    "Cloud",
    "Nightlight",
    "Assignment",
    "Location",
    "Settings",
    "Rocket",
    "Backpack",
    "Person",
    "Done All",
    "Search",
    "Extension",
    "Bluetooth",
    "Favorite",
    "Lock",
    "Bookmark",
  ];

  List<IconData> icons = [
    Icons.monetization_on,
    Icons.pie_chart,
    Icons.flag,
    Icons.notifications,
    Icons.savings,
    Icons.cloud,
    Icons.nightlight_round,
    Icons.assignment,
    Icons.location_pin,
    Icons.settings,
    Icons.rocket,
    Icons.backpack,
    Icons.person,
    Icons.done_all,
    Icons.search,
    Icons.extension,
    Icons.bluetooth,
    Icons.favorite,
    Icons.lock,
    Icons.bookmark,
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF222431),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth / 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  // Future.delayed(const Duration(milliseconds: 500), () {
                  //   setState(() {
                  //     startAnimation = true;
                  //   });
                  // });
                },
                child: const Text(
                  "SHOW LIST",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: texts.length,
                itemBuilder: (context, index) {
                  return item(index);
                },
              ),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  Widget item(int index) {
    return AnimatedContainer(
      height: 55,
      width: screenWidth,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300 + (index * 200)),
      transform: Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth / 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${index + 1}. ${texts[index]}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            icons[index],
          ),
        ],
      ),
    );
  }

}


//   bool isSwitch = false;
//   Stream<QuerySnapshot>? employeeStream;
//   List<String> _imageUrls = [];
//   List<String> _folderNames = [];
//   bool _isLoading = true;
//   String searchName = '';

// late AnimationController _animationController;
//   bool _startAnimation = false;

  

//   @override
//   void initState() {
//     super.initState();
//     getDataLoad();
//     _fetchAllImagesAndFolders();

//       _animationController = AnimationController(
//       duration: const Duration(seconds: 30), vsync: this,
    
//     );
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         _startAnimation = true;
//       });
//       _animationController.forward();
//     });
//   }

//     @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchAllImagesAndFolders() async {
//     try {
//       List<String> urls = [];
//       List<String> folders = [];

//       await AddEMPLOYEEDATA().fetchImagesAndFoldersFromPrefix(urls, folders);

//       setState(() {
//         _imageUrls = urls;
//         _folderNames = folders;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> getDataLoad() async {
//     employeeStream = AddEMPLOYEEDATA().GetEmpinfo(searchName);
//     setState(() {});
//   }

// //  @override
// // Widget build(BuildContext context) {
// //   return Scaffold(
// //     extendBodyBehindAppBar: true,
// //     appBar: AppBar(
// //       backgroundColor: Colors.transparent,
// //       elevation: 0,
// //       title: const Text('Registered People'),
// //       centerTitle: true,
// //       leading: IconButton(
// //         icon: Icon(Icons.person, size: 40),
// //         onPressed: () {
// //           showPopupMenu(context);
// //         },
// //       ),
// //       actions: [
// //         Switch(
// //           value: isSwitch,
// //           onChanged: (value) {
// //             setState(() {
// //               isSwitch = value;
// //             });
// //           },
// //         )
// //       ],
// //     ),
// //     body: Container(
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Colors.blueAccent, Colors.purpleAccent],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //       ),
// //       child: Stack(
// //         children: [
// //           _isLoading
// //               ? Center(child: Shimmmmer(context))
// //               : Column(
// //                   children: [
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
// //                       child: TextField(
// //                         decoration: const InputDecoration(
// //                           labelText: 'Search by Name',
// //                           border: OutlineInputBorder(),
// //                           suffixIcon: Icon(Icons.search),
// //                         ),
// //                         onChanged: (value) {
// //                           setState(() {
// //                             searchName = value;
// //                             getDataLoad();
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: StreamBuilder<QuerySnapshot>(
// //                         stream: employeeStream,
// //                         builder: (context, snapshot) {
// //                           if (snapshot.connectionState == ConnectionState.waiting) {
// //                             return Shimmmmer(context);
// //                           } else if (snapshot.hasError) {
// //                             return Center(child: Text('Error: ${snapshot.error}'));
// //                           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //                             return const Center(child: Text('No Data Found'));
// //                           } else {
// //                             return ListView.builder(
// //                               itemCount: snapshot.data!.docs.length,
// //                               itemBuilder: (context, index) {
// //                                 var doc = snapshot.data!.docs[index];
// //                                 String emailfolder = doc['DOB'];
// //                                 String? folderPath = _folderNames.firstWhere(
// //                                   (folder) => folder.contains(emailfolder),
// //                                   orElse: () => '',
// //                                 );

// //                                 String imageUrl = _imageUrls.firstWhere(
// //                                   (url) => url.contains(folderPath),
// //                                   orElse: () => '',
// //                                 );

// //                                 return AnimatedBuilder(
// //                                   animation: _animationController,
// //                                   builder: (context, child) {
// //                                     return AnimatedContainer(
// //                                       duration: Duration(milliseconds: 300 + (index * 100)),
// //                                       curve: Curves.easeInOut,
// //                                       transform: Matrix4.translationValues(
// //                                         _startAnimation ? 0 : MediaQuery.of(context).size.width,
// //                                         0,
// //                                         0,
// //                                       ),
// //                                       margin: const EdgeInsets.only(bottom: 12),
// //                                       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
// //                                       decoration: BoxDecoration(
// //                                         color: Colors.white,
// //                                         borderRadius: BorderRadius.circular(10),
// //                                       ),
// //                                       child: GestureDetector(
// //                                         onTap: () {
// //                                           Navigator.push(
// //                                             context,
// //                                             CustomePageRoute(
// //                                               child: ChartBWEMP(
// //                                                 Emailof: widget.email + doc['Email'].toString(),
// //                                                 Sendername: widget.email,
// //                                                 Recivername: doc['Email'],
// //                                                 name: doc['Name'],
// //                                               ),
// //                                             ),
// //                                           );
// //                                         },
// //                                         child: GlassCard(
// //                                           child: Column(
// //                                             mainAxisAlignment: MainAxisAlignment.start,
// //                                             crossAxisAlignment: CrossAxisAlignment.start,
// //                                             children: [
// //                                               Padding(
// //                                                 padding: const EdgeInsets.only(left: 20),
// //                                                 child: Text(doc['Email']),
// //                                               ),
// //                                               Padding(
// //                                                 padding: const EdgeInsets.only(left: 20),
// //                                                 child: Text(doc['DOB']),
// //                                               ),
// //                                               Padding(
// //                                                 padding: const EdgeInsets.only(left: 20),
// //                                                 child: Text(doc['Name']),
// //                                               ),
// //                                               imageUrl.isNotEmpty
// //                                                   ? Padding(
// //                                                       padding: const EdgeInsets.only(left: 200),
// //                                                       child: Image.network(
// //                                                         imageUrl,
// //                                                         height: 90,
// //                                                         width: 150,
// //                                                         fit: BoxFit.cover,
// //                                                         loadingBuilder: (context, child, loadingProgress) {
// //                                                           if (loadingProgress == null) return child;
// //                                                           return const CircularProgressIndicator();
// //                                                         },
// //                                                         errorBuilder: (context, error, stackTrace) {
// //                                                           return const Icon(Icons.error);
// //                                                         },
// //                                                       ),
// //                                                     )
// //                                                   : const SizedBox(
// //                                                       height: 50,
// //                                                       width: 50,
// //                                                       child: Placeholder()),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     );
// //                                   },
// //                                 );
// //                               },
// //                             );
// //                           }
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //           Positioned(
// //             top: 0,
// //             left: 0,
// //             right: 0,
// //             child: Container(
// //               height: kToolbarHeight,
// //               decoration: BoxDecoration(
// //                 color: Colors.black.withOpacity(0.2),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     extendBodyBehindAppBar: true,
//     appBar: AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       title: const Text('Registered People'),
//       centerTitle: true,
//       leading: IconButton(
//         icon: Icon(Icons.person, size: 40),
//         onPressed: () {
//           showPopupMenu(context);
//         },
//       ),
//       actions: [
//         Switch(
//           value: isSwitch,
//           onChanged: (value) {
//             setState(() {
//               isSwitch = value;
//             });
//           },
//         )
//       ],
//     ),
//     body: Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blueAccent, Colors.purpleAccent],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Stack(
//         children: [
//           _isLoading
//               ? Center(child: Shimmmmer(context))
//               : Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
//                       child: TextField(
//                         decoration: const InputDecoration(
//                           labelText: 'Search by Name',
//                           border: OutlineInputBorder(),
//                           suffixIcon: Icon(Icons.search),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             searchName = value;
//                             getDataLoad();
//                           });
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: StreamBuilder<QuerySnapshot>(
//                         stream: employeeStream,
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return Shimmmmer(context);
//                           } else if (snapshot.hasError) {
//                             return Center(child: Text('Error: ${snapshot.error}'));
//                           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                             return const Center(child: Text('No Data Found'));
//                           } else {
//                             return ListView.builder(
//                               itemCount: snapshot.data!.docs.length,
//                               itemBuilder: (context, index) {
//                                 var doc = snapshot.data!.docs[index];
//                                 String emailfolder = doc['DOB'];
//                                 String? folderPath = _folderNames.firstWhere(
//                                   (folder) => folder.contains(emailfolder),
//                                   orElse: () => '',
//                                 );

//                                 String imageUrl = _imageUrls.firstWhere(
//                                   (url) => url.contains(folderPath),
//                                   orElse: () => '',
//                                 );

//                                 return AnimatedBuilder(
//                                   animation: _animationController,
//                                   builder: (context, child) {
//                                     return AnimatedContainer(
//                                       duration: Duration(seconds: 10 + (index * 100)),
//                                       curve: Curves.easeInOut,
//                                       transform: Matrix4.translationValues(
//                                         _startAnimation ? 0 : MediaQuery.of(context).size.width,
//                                         0,
//                                         0,
//                                       ),
//                                       margin: const EdgeInsets.only(bottom: 12),
//                                       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             CustomePageRoute(
//                                               child: ChartBWEMP(
//                                                 Emailof: widget.email + doc['Email'].toString(),
//                                                 Sendername: widget.email,
//                                                 Recivername: doc['Email'],
//                                                 name: doc['Name'],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: GlassCard(
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 20),
//                                                 child: Text(doc['Email']),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 20),
//                                                 child: Text(doc['DOB']),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 20),
//                                                 child: Text(doc['Name']),
//                                               ),
//                                               imageUrl.isNotEmpty
//                                                   ? Padding(
//                                                       padding: const EdgeInsets.only(left: 200),
//                                                       child: Image.network(
//                                                         imageUrl,
//                                                         height: 90,
//                                                         width: 150,
//                                                         fit: BoxFit.cover,
//                                                         loadingBuilder: (context, child, loadingProgress) {
//                                                           if (loadingProgress == null) return child;
//                                                           return const CircularProgressIndicator();
//                                                         },
//                                                         errorBuilder: (context, error, stackTrace) {
//                                                           return const Icon(Icons.error);
//                                                         },
//                                                       ),
//                                                     )
//                                                   : const SizedBox(
//                                                       height: 50,
//                                                       width: 50,
//                                                       child: Placeholder()),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: kToolbarHeight,
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.2),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }


//   Future<void> SignIN() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => LoginScreen()));
//     } catch (e) {
//       print('Error signing out: $e');
//     }
//   }

//   void showPopupMenu(BuildContext context) {
//     final RenderBox overlay =
//         Overlay.of(context).context.findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromLTRB(
//       overlay.size.width - 420,
//       kToolbarHeight + 20,
//       overlay.size.width,
//       overlay.size.height,
//     );

//     showMenu(
//       context: context,
//       position: position,
//       color: Color.fromARGB(110, 248, 5, 5),
//       items: [
//         PopupMenuItem<int>(
//           value: 0,
//           child: TextButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => Editpage(Email: widget.email)));
//             },
//             child: Text('My Account', style: TextStyle(color: Colors.white)),
//           ),
//         ),
//         PopupMenuItem<int>(
//           value: 1,
//           child: TextButton(
//             onPressed: () async {
//               await SignIN();
//             },
//             child: Text('Log Out', style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       ],
//       elevation: 6,
//     ).then((value) {
//       if (value == 0) {
//         print("My account menu is selected.");
//       } else if (value == 1) {
//         // Handle logout if needed
//       }
//     });
//   }

//   Widget Shimmmmer(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[350]!,
//       highlightColor: Colors.white,
//       child: ListView.builder(
//         itemCount: 4,
//         itemBuilder: (context, index) {
//           return GlassCard(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 10),
//                   child: Container(
//                     height: 20,
//                     width: 50,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 10),
//                   child: Container(
//                     height: 20,
//                     width: 50,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 10),
//                   child: Container(
//                     height: 20,
//                     width: 50,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }