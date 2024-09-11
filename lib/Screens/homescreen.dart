import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_firebase/Screens/chart.dart';
import 'package:internship_firebase/Screens/detailedshowedit.dart';
import 'package:internship_firebase/Screens/loginscreen.dart';
import 'package:internship_firebase/ServerSide/function.dart';
import 'package:internship_firebase/pagetran.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {


  bool isSwitch = false;
  Stream<QuerySnapshot>? employeeStream;
  List<String> _imageUrls = [];
  List<String> _folderNames = [];
  bool _isLoading = true;
  String searchName = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    getDataLoad();
    _fetchAllImagesAndFolders();

    _animationController = AnimationController(
      duration: const Duration(seconds: 50),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllImagesAndFolders() async {
    try {
      List<String> urls = [];
      List<String> folders = [];
      await AddEMPLOYEEDATA().fetchImagesAndFoldersFromPrefix(urls, folders);
      setState(() {
        _imageUrls = urls;
        _folderNames = folders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDataLoad() async {
    employeeStream = AddEMPLOYEEDATA().GetEmpinfo(searchName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Registered People'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.person, size: 40),
          onPressed: () {
            showPopupMenu(context);
          },
        ),
        actions: [
          Switch(
            value: isSwitch,
            onChanged: (value) {
              setState(() {
                isSwitch = value;
              });
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _isLoading
                ? Center(child: Shimmmmer(context))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search by Name',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchName = value;
                              getDataLoad();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: employeeStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Shimmmmer(context);
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text('No Data Found'));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var doc = snapshot.data!.docs[index];
                                  String emailfolder = doc['DOB'];
                                  String? folderPath = _folderNames.firstWhere(
                                    (folder) => folder.contains(emailfolder),
                                    orElse: () => '',
                                  );

                                  String imageUrl = _imageUrls.firstWhere(
                                    (url) => url.contains(folderPath),
                                    orElse: () => '',
                                  );

                                  return AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      final start = index * 0.1;
                                      final end = start + 0.1;
                                      final animation = Tween(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                          parent: _animationController,
                                          curve: Interval(start, end, curve: Curves.easeOut),
                                        ),
                                      );

                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CustomePageRoute(
                                                  child: ChartBWEMP(
                                                    Emailof: widget.email + doc['Email'].toString(),
                                                    Sendername: widget.email,
                                                    Recivername: doc['Email'],
                                                    name: doc['Name'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: GlassCard(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: Text(doc['Email']),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: Text(doc['DOB']),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20),
                                                    child: Text(doc['Name']),
                                                  ),
                                                  imageUrl.isNotEmpty
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(left: 200),
                                                          child: Image.network(
                                                            imageUrl,
                                                            height: 90,
                                                            width: 150,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (context, child, loadingProgress) {
                                                              if (loadingProgress == null) return child;
                                                              return const CircularProgressIndicator();
                                                            },
                                                            errorBuilder: (context, error, stackTrace) {
                                                              return const Icon(Icons.error);
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: Placeholder()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> SignIN() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(
      overlay.size.width - 420,
      kToolbarHeight + 20,
      overlay.size.width,
      overlay.size.height,
    );

    showMenu(
      context: context,
      position: position,
      color: Color.fromARGB(110, 248, 5, 5),
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Editpage(Email: widget.email)));
            },
            child: Text('My Account', style: TextStyle(color: Colors.white)),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: TextButton(
            onPressed: () async {
              await SignIN();
            },
            child: Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
      elevation: 6,
    ).then((value) {
      if (value == 0) {
        print("My account menu is selected.");
      } else if (value == 1) {
        // Handle logout if needed
      }
    });
  }

  Widget Shimmmmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350]!,
      highlightColor: Colors.white,
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return GlassCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Container(
                    height: 20,
                    width: 50,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Container(
                    height: 20,
                    width: 50,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Container(
                    height: 20,
                    width: 50,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.1), 
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}
