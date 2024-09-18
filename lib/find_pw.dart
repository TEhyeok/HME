import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoveryPW extends StatefulWidget {
  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPW> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일을 입력해주세요.')),
      );
      return;
    }

    try {
      // 비밀번호 재설정 이메일을 항상 보냅니다
      await _auth.sendPasswordResetEmail(email: email);

      // 성공 메시지를 표시합니다
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('입력하신 이메일로 비밀번호 재설정 안내를 보냈습니다. 이메일을 확인해 주세요.')),
      );
    } on FirebaseAuthException catch (e) {
      // Firebase 인증 예외를 처리합니다
      String message;
      if (e.code == 'invalid-email') {
        message = '유효하지 않은 이메일 형식입니다.';
      } else {
        // 다른 모든 에러에 대해 일반적인 메시지를 표시합니다
        message = '비밀번호 재설정 요청을 처리하는 중 오류가 발생했습니다. 나중에 다시 시도해 주세요.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // 기타 예외를 처리합니다
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('알 수 없는 오류가 발생했습니다. 나중에 다시 시도해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 재설정')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _resetPassword(_emailController.text),
              child: Text('비밀번호 재설정 이메일 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
