import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReport extends StatefulWidget {
  @override
  _AdminReportState createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fileName;
  List<List<dynamic>>? _csvData;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      final input = file.bytes;
      final fields = const CsvToListConverter().convert(utf8.decode(input!));

      setState(() {
        _fileName = file.name;
        _csvData = fields;
      });

      for (var field in fields) {
        try {
          await _firestore.collection('data').add({
            'email': field[0],
            '날짜': field[1], // 날짜 필드 추가
            '장건강 종합지수': field[2], // 인덱스 조정
            '장내 환경 주요지표': field[3], // 인덱스 조정
            '대표 장내미생물': field[4], // 인덱스 조정
            '설사 관련 균주': field[5], // 인덱스 조정
            '변비 관련 균주': field[6], // 인덱스 조정
            '복부 불편감 관련 균주': field[7], // 인덱스 조정
            '체지방 조절 미생물 5종': field[8],
            '피로 관련 미생물': field[9],
            '장유형': field[10],
            '체중관련 미생물': field[11],
            '장내미생물 균형도': field[12],
            '장내 감염증 원인균': field[13],
            '과민성 대장증후군 수준': field[14],
            '염증성질환유해수준': field[15],
            '대장암 유해수준': field[16],
            '프로바이오틱스 균주': field[17],
            '운동성(활동성) 관련 균주': field[18],
            '면역 기능 관련 균주': field[19],
            '두뇌관련 균주': field[20],
            '단백질 소화 관련 균주': field[21],
            '탄수화물 소화관련 균주': field[22],
            '스트레스 관련 균주': field[23],
            '비타민 관련 균주': field[24],
            '신경건강 관련 균주': field[25],
          });
          print('저장 성공: $field');
        } catch (e) {
          print("데이터 저장 중 오류 발생: $e");
          print("문제가 발생한 필드: $field");
        }
      }
      print("데이터가 Firestore에 저장되었습니다.");
    } else {
      setState(() {
        _fileName = null;
        _csvData = null;
      });
      print("파일 선택이 취소되었습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관리자 보고서'),
        leading: IconButton(
          icon: Icon(Icons.file_upload),
          onPressed: _pickFile,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_fileName != null) Text('선택된 파일: $_fileName'),
            if (_csvData != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _csvData!.length,
                  itemBuilder: (context, index) {
                    return Text(_csvData![index].join(', '));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
