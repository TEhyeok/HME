// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class ReportPort1 extends StatefulWidget {
//   @override
//   _ReportPort1State createState() => _ReportPort1State();
// }

// class _ReportPort1State extends State<ReportPort1> {
//   List<SalesData> data = [
//     SalesData('Jan', 35),
//     SalesData('Feb', 28),
//     SalesData('Mar', 34),
//     SalesData('Apr', 32),
//     SalesData('May', 40)
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('최재혁의 iPhone'),
//         backgroundColor: Colors.black,
//       ),
//       body: Container(
//         color: Colors.black,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: [
//             Text(
//               '스크린 타임',
//               style: TextStyle(color: Colors.blue, fontSize: 24),
//             ),
//             SizedBox(height: 16),
//             Text(
//               '오늘, 6월 17일\n4시간 16분',
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//             SizedBox(height: 16),
//             SfCartesianChart(
//               primaryXAxis: CategoryAxis(),
//               title: ChartTitle(text: '월별 판매 데이터'),
//               legend: Legend(isVisible: true),
//               tooltipBehavior: TooltipBehavior(enable: true),
//               series: <ChartSeries<SalesData, String>>[
//                 LineSeries<SalesData, String>(
//                     dataSource: data,
//                     xValueMapper: (SalesData sales, _) => sales.year,
//                     yValueMapper: (SalesData sales, _) => sales.sales,
//                     name: '판매',
//                     // Enable data label
//                     dataLabelSettings: DataLabelSettings(isVisible: true))
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '엔터테인먼트',
//                   style: TextStyle(color: Colors.blue, fontSize: 16),
//                 ),
//                 Text(
//                   '1시간 11분',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '소셜 미디어',
//                   style: TextStyle(color: Colors.blue, fontSize: 16),
//                 ),
//                 Text(
//                   '1시간 8분',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '쇼핑 및 음식',
//                   style: TextStyle(color: Colors.blue, fontSize: 16),
//                 ),
//                 Text(
//                   '16분',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               '최다 사용',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//             ListTile(
//               leading: Icon(Icons.youtube_searched_for, color: Colors.red),
//               title: Text('YouTube', style: TextStyle(color: Colors.white)),
//               trailing: Text('1시간 8분', style: TextStyle(color: Colors.white)),
//             ),
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: Colors.purple),
//               title: Text('Instagram', style: TextStyle(color: Colors.white)),
//               trailing: Text('34분', style: TextStyle(color: Colors.white)),
//             ),
//             ListTile(
//               leading: Icon(Icons.chat, color: Colors.yellow),
//               title: Text('카카오톡', style: TextStyle(color: Colors.white)),
//               trailing: Text('32분', style: TextStyle(color: Colors.white)),
//             ),
//             ListTile(
//               leading: Icon(Icons.fastfood, color: Colors.green),
//               title: Text('배달의민족', style: TextStyle(color: Colors.white)),
//               trailing: Text('16분', style: TextStyle(color: Colors.white)),
//             ),
//             ListTile(
//               leading: Icon(Icons.photo, color: Colors.orange),
//               title: Text('사진', style: TextStyle(color: Colors.white)),
//               trailing: Text('13분', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SalesData {
//   final String year;
//   final double sales;

//   SalesData(this.year, this.sales);
// }
