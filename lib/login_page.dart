import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/bottom_navBar_controller_admin.dart' as admin;
import 'package:final_project/bottom_navBar_controller_mypage.dart';
import 'package:final_project/find_pw.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginSignUpPage extends StatefulWidget {
  final Function()? onLoginSuccess;

  const LoginSignUpPage({Key? key, this.onLoginSuccess}) : super(key: key);

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _passwordVisibility = false;
  bool _passwordCreateVisibility = false;
  bool _passwordConfirmVisibility = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailCreateController = TextEditingController();
  final TextEditingController _passwordCreateController =
      TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailCreateController.dispose();
    _passwordCreateController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      // 탭 선택이 변경되었음을 알림
    });
  }

  Future<void> _login(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (email == "admin@admin.com" && password == "admin00") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => admin.BottomNavBaradmin()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBarMypage()),
        );
      }
      widget.onLoginSuccess?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: 이메일 또는 비밀번호를 확인해주세요.')),
      );
    }
  }

  Future<void> _signUp(
      String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 성공! 로그인해주세요.')),
      );
      _tabController.animateTo(0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/HME_logo.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 40),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.readexPro(
                        textStyle: TextStyle(
                            fontSize: 30,
                            color: _tabController.index == 0
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.readexPro(
                        textStyle: TextStyle(
                            fontSize: 30,
                            color: _tabController.index == 1
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginTab(),
                    _buildSignUpTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    double inputFieldHeight = 60.0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
            child: Text(
              'Let\'s get started by filling out the form below.',
              style: GoogleFonts.readexPro(
                fontSize: 14,
                color: Colors.grey[600],
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(
            height: inputFieldHeight,
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.readexPro(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: inputFieldHeight,
            child: TextField(
              controller: _passwordController,
              obscureText: !_passwordVisibility,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.readexPro(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisibility
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () => setState(
                      () => _passwordVisibility = !_passwordVisibility),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Container(
              width: 230,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Color.fromARGB(255, 31, 200, 113),
                    Color.fromARGB(210, 40, 91, 153),
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: ElevatedButton(
                onPressed: () => _login(
                    _emailController.text, _passwordController.text, context),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RecoveryPW()));
              },
              child: Text(
                'Forgot Password',
                style: GoogleFonts.readexPro(
                  color: Colors.blue, // 색상 변경
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Or sign up with',
              style: GoogleFonts.readexPro(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              icon: Image.asset('assets/images/Google.png',
                  width: 24), // Google 아이콘 이미지로 변경
              label: Text(
                'Continue with Google',
                style: GoogleFonts.readexPro(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                // Google 로그인 로직 구현
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(230, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: ElevatedButton.icon(
              icon: Icon(Icons.apple, color: Colors.black),
              label: Text(
                'Continue with Apple',
                style: GoogleFonts.readexPro(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                // Apple 로그인 로직 구현
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: Size(230, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpTab() {
    double inputFieldHeight = 60.0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
            child: Text(
              'Create an account by filling out the form below.',
              style: GoogleFonts.readexPro(
                fontSize: 14,
                color: Colors.grey[600],
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(
            height: inputFieldHeight,
            child: TextField(
              controller: _emailCreateController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.readexPro(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: inputFieldHeight,
            child: TextField(
              controller: _passwordCreateController,
              obscureText: !_passwordCreateVisibility,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.readexPro(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                suffixIcon: IconButton(
                  icon: Icon(_passwordCreateVisibility
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () => setState(() =>
                      _passwordCreateVisibility = !_passwordCreateVisibility),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: inputFieldHeight,
            child: TextField(
              controller: _passwordConfirmController,
              obscureText: !_passwordConfirmVisibility,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: GoogleFonts.readexPro(),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                suffixIcon: IconButton(
                  icon: Icon(_passwordConfirmVisibility
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () => setState(() =>
                      _passwordConfirmVisibility = !_passwordConfirmVisibility),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 230,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow,
                    Color(0xFF9EDC5C),
                    Color.fromARGB(210, 40, 91, 153),
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_passwordCreateController.text !=
                      _passwordConfirmController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
                    );
                    return;
                  }
                  _signUp(_emailCreateController.text,
                      _passwordCreateController.text, context);
                },
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
