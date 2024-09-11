import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_firebase/Screens/homescreen.dart';
import 'package:internship_firebase/Screens/sinup.dart';
import 'package:internship_firebase/provider/boolpro.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Ball> balls;
  final int ballCount = Random().nextInt(2) + 9;
  late Size screenSize;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();

    balls = List.generate(ballCount, (_) => Ball());
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(String email, String password) async {
    try {
      print(email);
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(email: email)));
    } catch (e) {
      print('Error signing in: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('InCorrect Email and Password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<ProviderModel>(
        builder: (context, value, child) {

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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    elevation: 10,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 400,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: value.sswitch,
                            validator: (value) {
                              if (value == null || value.length < 7) {
                                return 'Password must be at least 7 characters long';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Password',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              suffixIcon: IconButton(
                                icon: Icon(value.sswitch
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {

                                  final swit=context.read<ProviderModel>();
                                 swit.changebool();
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signIn(_emailController.text,
                                    _passwordController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Login'),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SinupScreen()));
                                },
                                child: Text('Sign Up',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
