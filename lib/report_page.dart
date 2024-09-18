import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>>? userData;
  final double _barThickness = 5.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userEmail = currentUser.email!;
      var snapshot = await _firestore
          .collection('data')
          .where('email', isEqualTo: userEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userData = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } else {
      setState(() {
        userData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'REPORT',
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
      body: userData == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search_off, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    '검사 이력이 없습니다.',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '검사 이력이 없을 경우 리포트를 받아 보실 수 없습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '*사용자 정보가 일치하지 않으면 검사 이력을 가져올 수 없습니다.\n*사용자 정보는 검사 시 입력된 정보와 동일해야 합니다.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: userData!.length,
              itemBuilder: (context, index) {
                var data = userData![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['email'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        _buildProgressBar('대표 장내미생물', data['대표 장내미생물']),
                        _buildProgressBar('변비 관련 균주', data['변비 관련 균주']),
                        _buildProgressBar('설사 관련 균주', data['설사 관련 균주']),
                        _buildProgressBar('장건강 종합지수', data['장건강 종합지수']),
                        _buildProgressBar('장내 환경 주요지표', data['장내 환경 주요지표']),
                        _buildProgressBar('복부 불편감 관련 균주', data['복부 불편감 관련 균주']),
                        _buildProgressBar(
                            '체지방 조절 미생물 5종', data['체지방 조절 미생물 5종']),
                        _buildProgressBar('피로 관련 미생물', data['피로 관련 미생물']),
                        _buildProgressBar('장유형', data['장유형']),
                        _buildProgressBar('체중관련 미생물', data['체중관련 미생물']),
                        _buildProgressBar('장내미생물 균형도', data['장내미생물 균형도']),
                        _buildProgressBar('장내 감염증 원인균', data['장내 감염증 원인균']),
                        _buildProgressBar('과민성 대장증후군 수준', data['과민성 대장증후군 수준']),
                        _buildProgressBar('염증성질환유해준', data['염증성질환유해수준']),
                        _buildProgressBar('대장암 유해수준', data['대장암 유해수준']),
                        _buildProgressBar('프로바이오틱스 균주', data['프로바이오틱스 균주']),
                        _buildProgressBar(
                            '운동성(활동성) 관련 균주', data['운동성(활동성) 관련 균주']),
                        _buildProgressBar('면역 기능 관련 균주', data['면역 기능 관련 균주']),
                        _buildProgressBar('두뇌관련 균주', data['두뇌관련 균주']),
                        _buildProgressBar('단백질 소화 관련 균주', data['단백질 소화 관련 균주']),
                        _buildProgressBar('탄수화물 소화관련 균주', data['탄수화물 소화관련 균주']),
                        _buildProgressBar('스트레스 관련 균주', data['스트레스 관련 균주']),
                        _buildProgressBar('비타민 관련 균주', data['비타민 관련 균주']),
                        _buildProgressBar('신경건강 관련 균주', data['신경건강 관련 균주']),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProgressBar(String label, dynamic value) {
    double numericalValue = 0;
    if (value is num) {
      numericalValue = value.toDouble();
    } else if (value is String) {
      numericalValue = double.tryParse(value) ?? 0;
    }

    numericalValue = numericalValue.clamp(0, 100);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: _barThickness,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_barThickness / 2),
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.yellow, Colors.green],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: (MediaQuery.of(context).size.width - 32) *
                        (numericalValue / 100) -
                    7.5,
                top: -5,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text('${numericalValue.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
