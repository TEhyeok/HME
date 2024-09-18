import 'package:flutter/material.dart';
// import 'bottom_navBar_controller.dart'; // home_page.dart를 임포트합니다.
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 바인딩 초기화
  await Firebase.initializeApp(
    // Firebase 초기화
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HME App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // 전체 앱의 배경색을 하얀색으로 설정
      ),
      home: const SplashScreen(), // SplashScreen을 초기 화면으로 설정
      routes: {
        '/login': (context) => const LoginSignUpPage(), // 로그인 페이지 라우트 추가
      },
      onGenerateRoute: (settings) {
        // 여기에 동적 라우트 생성 로직을 추가할 수 있습니다.
        if (settings.name == '/dynamicRoute') {
          return MaterialPageRoute(builder: (context) => DynamicPage());
        }
        return null; // 경로를 찾을 수 없을 때 null을 반환
      },
      onUnknownRoute: (settings) {
        // 알 수 없는 라우트에 대한 처리
        return MaterialPageRoute(builder: (context) => UnknownRoutePage());
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // 애니메이션 컨트롤러
  late Animation<double> _animation; // 애니메이션
  late Animation<double> _opacity; // 투명도 애니메이션

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // 애니메이션 지속 시간
      vsync: this, // vsync 설정
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // 애니메이션 곡선
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_animation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse().then((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const LoginSignUpPage()), // 로그인 페이지로 변경
            );
          });
        }
      });

    _controller.forward(); // 애니메이션 시작
  }

  @override
  void dispose() {
    _controller.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _opacity, // 투명도 애니메이션 적용
        child: Center(
          child: Image.asset('assets/images/HME_logo.png'), // 로고 이미지
        ),
      ),
    );
  }
}

// 예시로 추가된 페이지 클래스
class DynamicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic Page")),
      body: Center(child: Text("This is a dynamic page")),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unknown Route")),
      body: Center(child: Text("No route defined for this page")),
    );
  }
}
