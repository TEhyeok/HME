import 'package:flutter/material.dart';
import 'home_page.dart';
import 'report_page.dart';
import 'diet_recommendation_page.dart';
import 'my_page.dart';
import 'login_page.dart';

class BottomNavBarController extends StatefulWidget {
  final int initialIndex; // 초기 인덱스 추가

  const BottomNavBarController({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  _BottomNavBarControllerState createState() => _BottomNavBarControllerState();
}

class _BottomNavBarControllerState extends State<BottomNavBarController> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // 초기 인덱스 사용
  }

  bool _isLoggedIn = false;

  List<Widget> get _pages => [
        HomePage(),
        ReportPage(),
        DietRecommendationPage(),
        _isLoggedIn
            ? const MyPage()
            : LoginSignUpPage(onLoginSuccess: _onLoginSuccess),
      ];

  List<BottomNavigationBarItem> get _navItems => [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), label: '리포트'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu), label: '추천식단'),
        BottomNavigationBarItem(
          icon: Icon(_isLoggedIn ? Icons.person : Icons.login),
          label: _isLoggedIn ? '마이페이지' : '로그인',
        ),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        backgroundColor: Color(0xD313447E), // 배경색 변경
        unselectedItemColor: Color(0xFFAEC1CF), // 선택되지 않은 아이템 색상 변경
        selectedItemColor: Colors.white, // 선택된 아이템 색상 변경
        elevation: 0, // 그림자 제거
      ),
    );
  }
}
