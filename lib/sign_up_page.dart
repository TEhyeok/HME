import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'bottom_navBar_controller.dart';
import 'package:flutter/cupertino.dart'; // Cupertino 위젯을 사용하기 위해 추가

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _name = '';
  DateTime? _birthDate;
  String _phoneNumber = '';
  String _gender = '';
  String _email = '';
  String _password = '';
  String _nickname = '';

  bool _isLoading = false;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _nicknameFocus = FocusNode();

  // 필요한 변수 선언
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;
  List<int> years =
      List<int>.generate(100, (int index) => DateTime.now().year - index);
  List<int> months = List<int>.generate(12, (int index) => index + 1);
  List<int> days = List<int>.generate(31, (int index) => index + 1);

  @override
  void dispose() {
    _nameFocus.dispose();
    _phoneNumberFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nicknameFocus.dispose();
    super.dispose();
  }

  // 생년월일 선택을 위한 메소드
  void _updateBirthDate() {
    if (_selectedYear != null &&
        _selectedMonth != null &&
        _selectedDay != null) {
      setState(() {
        _birthDate = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
      });
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _name,
          'birthDate': _birthDate,
          'phoneNumber': _phoneNumber,
          'gender': _gender,
          'email': _email,
          'nickname': _nickname,
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BottomNavBarController(initialIndex: 3),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = '회원가입에 실패했습니다.';
        if (e.code == 'weak-password') {
          errorMessage = '비밀번호가 너무 약합니다.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = '이미 사용 중인 이메일입니다.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      focusNode: _nameFocus,
                      decoration: InputDecoration(labelText: '이름'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? '이름을 입력해주세요.' : null,
                      onSaved: (value) => _name = value!,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_phoneNumberFocus),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedYear,
                            decoration: InputDecoration(labelText: '년'),
                            items:
                                years.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedYear = newValue;
                                _updateBirthDate();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedMonth,
                            decoration: InputDecoration(labelText: '월'),
                            items:
                                months.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedMonth = newValue;
                                _updateBirthDate();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedDay,
                            decoration: InputDecoration(labelText: '일'),
                            items: days.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedDay = newValue;
                                _updateBirthDate();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      focusNode: _phoneNumberFocus,
                      decoration: InputDecoration(labelText: '휴대폰 번호'),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value?.isEmpty ?? true ? '휴대폰 번호를 입력해주세요.' : null,
                      onSaved: (value) => _phoneNumber = value!,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: '성별'),
                      value: _gender.isEmpty ? null : _gender,
                      items: ['남성', '여성', '기타'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _gender = newValue!;
                        });
                      },
                      validator: (value) =>
                          value == null ? '성별을 선택해주세요.' : null,
                    ),
                    TextFormField(
                      focusNode: _emailFocus,
                      decoration: InputDecoration(labelText: '이메일'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value?.isEmpty ?? true ? '이메일을 입력해주세요.' : null,
                      onSaved: (value) => _email = value!,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                    ),
                    TextFormField(
                      focusNode: _passwordFocus,
                      decoration: InputDecoration(labelText: '비밀번호'),
                      obscureText: true,
                      validator: (value) =>
                          value?.isEmpty ?? true ? '비밀번호를 입력해주세요.' : null,
                      onSaved: (value) => _password = value!,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_nicknameFocus),
                    ),
                    TextFormField(
                      focusNode: _nicknameFocus,
                      decoration: InputDecoration(labelText: '닉네임'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? '닉네임을 입력해주세요.' : null,
                      onSaved: (value) => _nickname = value!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signUp,
                      child: Text('회원가입'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
