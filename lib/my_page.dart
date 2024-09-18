import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // 날짜 형식화를 위해 추가

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String email = '정보 없음';
  String name = '정보 없음';
  String birthDate = '정보 없음';
  String phoneNumber = '정보 없음';
  String gender = '정보 없음';
  String nickname = '정보 없음';
  bool isLifetimeMember = false;
  bool isAutoLogin = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null && user.email != null) {
      try {
        DocumentSnapshot docSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;

          setState(() {
            email = data['email'] ?? '정보 없음';
            name = data['name'] ?? '정보 없음';
            phoneNumber = data['phoneNumber'] ?? '정보 없음';

            // Timestamp를 DateTime으로 변환 후 문자열로 포맷팅
            if (data['birthDate'] != null) {
              Timestamp birthDateTimestamp = data['birthDate'];
              DateTime birthDateTime = birthDateTimestamp.toDate();
              birthDate = DateFormat('yyyy-MM-dd').format(birthDateTime);
            } else {
              birthDate = '정보 없음';
            }

            gender = data['gender'] ?? '정보 없음';
            nickname = data['nickname'] ?? '정보 없음';
            isLifetimeMember = data['isLifetimeMember'] ?? false;
            isAutoLogin = data['isAutoLogin'] ?? false;
          });
        }
      } catch (e) {
        print("데이터 로드 중 에러 발생: $e");
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context)
        .pushReplacementNamed('/login'); // 로그아웃 후 login_page로 이동하도록 수정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'MY PAGE',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.black,
            fontSize: 22,
            letterSpacing: 0,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Icon(
              Icons.search_rounded,
              color: Colors.grey[600],
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
            child: Icon(
              Icons.notifications_rounded,
              color: Colors.grey[600],
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
            child: Icon(
              Icons.settings_outlined,
              color: Colors.grey[600],
              size: 30,
            ),
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('이름'),
            subtitle: Text(name),
          ),
          ListTile(
            title: const Text('생년월일'),
            subtitle: Text(birthDate),
          ),
          ListTile(
            title: const Text('휴대폰 번호'),
            subtitle: Text(phoneNumber),
          ),
          ListTile(
            title: const Text('성별'),
            subtitle: Text(gender),
          ),
          Divider(),
          ListTile(
            title: const Text('이메일'),
            subtitle: Text(email),
          ),
          ListTile(
            title: const Text('닉네임'),
            subtitle: Text(nickname),
          ),
          Divider(),
          SwitchListTile(
            title: const Text('평생회원'),
            value: isLifetimeMember,
            onChanged: (bool value) {
              setState(() {
                isLifetimeMember = value;
              });
              // Firebase에 변경사항 저장 로직 추가
            },
          ),
          SwitchListTile(
            title: const Text('자동로그인'),
            value: isAutoLogin,
            onChanged: (bool value) {
              setState(() {
                isAutoLogin = value;
              });
              // Firebase에 변경사항 저장 로직 추가
            },
          ),
          ListTile(
            title: const Text('언어'),
            subtitle: const Text('한국어'),
          ),
          ListTile(
            title: const Text('캐시삭제'),
            onTap: () {
              // 캐시 삭제 로직 구현
            },
          ),
          ListTile(
            title: const Text('회원탈퇴'),
            onTap: () {
              // 회원탈퇴 로직 구현
            },
          ),
          ListTile(
            title: const Text('로그아웃', style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
          Divider(),
          ListTile(
            title: const Text('고객센터'),
            subtitle: const Text('1234-5678'),
          ),
          ListTile(
            title: const Text('운영시간'),
            subtitle: const Text('평일 09:00 AM ~ 05:00 PM'),
          ),
        ],
      ),
    );
  }
}
