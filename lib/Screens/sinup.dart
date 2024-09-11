import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internship_firebase/Screens/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internship_firebase/ServerSide/function.dart';
import 'package:internship_firebase/provider/boolpro.dart';
import 'package:internship_firebase/provider/imageprovider.dart';
import 'package:provider/provider.dart';

class SinupScreen extends StatefulWidget {
  SinupScreen({super.key});

  @override
  State<SinupScreen> createState() => _SinupScreenState();
}

class _SinupScreenState extends State<SinupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Ball> balls;
  final int ballCount = Random().nextInt(2) + 9; 
  late Size screenSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();

    balls = List.generate(ballCount, (_) => Ball());
  }

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _DOB = TextEditingController();
  // TextEditingController _file = TextEditingController();
  TextEditingController _name = TextEditingController();
  bool showPassword = true;
  final _formKey = GlobalKey<FormState>();

  // final ImagePicker picker = ImagePicker();

  // XFile? _pickedImage;

  // Future<void> getimage() async {
  //   try {
  //     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //     if (image != null) {
  //       setState(() {
  //         _file.text = image.path;

  //         _pickedImage = image;
  //       });
  //       // print('Gallery image picked: ${image.path}');
  //     } else {
  //       print('No image selected from gallery');
  //     }
  //   } catch (e) {
  //     print('Error picking image from gallery: $e');
  //   }
  // }

  Future<void> SignUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Error-come') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Registration failed due to an error: ${e.message}')),
        );
      } else {}
    } catch (e) {
      print('Error signing up: $e');
    } finally {
      _email.clear();
      _password.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Consumer<ImageproviderSet>(
        builder: (context, Provider, child) {


          return Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                balls.forEach((ball) => ball.updatePosition(screenSize));
                return CustomPaint(
                  painter: BallsPainter(balls),
                  size: Size.infinite,
                );
              },
            ),
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: 350,
                  height: 560,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 3),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Registeration',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        
                          GestureDetector(
  onTap: () async {
    await Provider.getImageFromGallery();
  },
  child: Container(
    width: 300,
    height: 100,
    child: CircleAvatar(
      radius: 100,
      backgroundColor: Colors.grey[500],
      backgroundImage: Provider.file != null
          ? FileImage(File(Provider.file!.path))
          : null,
      child: Provider.file == null
          ? Center(child: Text('No Image')) 
          : null,
    ),
  ),
),

                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value == null || !value.contains('@')) {
                                  return 'Required field';
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: _password,
                              obscureText: Provider.sswitch,
                              validator: (value) {
                                if (value.toString().length < 7) {
                                  return 'Required field';
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                   final chang=context.read<ImageproviderSet>();
                                   chang.changeBool();
                                    },
                                    icon: Provider.sswitch
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off)
                                        ),
                                hintText: 'Enter Password',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: _name,
                              validator: (value) {
                              if (value.toString().isEmpty) {
                                  return 'Required field';
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 300,
                            child: TextFormField(
                              controller: _DOB,
                                validator: (value) {
                              if (value.toString().isEmpty) {
                                  return 'Required field';
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter DOB',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                         
                       
                          Container(
                              height: 50,
                              width: 150,
                              color: Colors.red,
                              child: TextButton(
                                child: const Text('SinUp'),
                                onPressed: () async {

                                  if(_formKey.currentState!.validate())
                                  {
                                    await AddEMPLOYEEDATA().infoEmpADD(_email.text, _name.text, _password.text, _DOB.text);
                                  SignUp(_email.text, _password.text);
                                  
                                  print(Provider.file!);
                                        await AddEMPLOYEEDATA().uploadImage(Provider.file!, _DOB.text);
                                         ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')));

                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                  }
                                 
        
                                
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
          
        },
  
      ),
    );
  }
}

class Ball {
  late double x;
  late double y;
  double dx = (Random().nextDouble() - 0.5) * 5;
  double dy = (Random().nextDouble() - 0.5) * 5;
  Color color = Color.fromRGBO(
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
    1,
  );

  Ball() {
    x = Random().nextDouble() * 300;
    y = Random().nextDouble() * 300;
  }

  void updatePosition(Size screenSize) {
    x += dx;
    y += dy;

    if (x < 0 || x > screenSize.width) {
      dx = -dx;
      randomizeSpeed();
    }
    if (y < 0 || y > screenSize.height) {
      dy = -dy;
      randomizeSpeed();
    }
  }

  void randomizeSpeed() {
    dx = (Random().nextDouble() - 0.5) * 5;
    dy = (Random().nextDouble() - 0.5) * 5;
  }
}

class BallsPainter extends CustomPainter {
  final List<Ball> balls;

  BallsPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    balls.forEach((ball) {
      final paint = Paint()
        ..color = ball.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(ball.x, ball.y), 100, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
