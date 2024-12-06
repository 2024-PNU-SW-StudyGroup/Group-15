import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart'; // MySQL 패키지 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter MySQL Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _dbData = "No Data"; // 데이터를 저장할 변수

  // MySQL 연결 및 데이터 가져오기
  Future<void> _fetchDataFromDatabase() async {
    final settings = ConnectionSettings(
      host: 'localhost', // 데이터베이스 호스트
      port: 3306,        // 포트 번호
      user: 'your_username', // 사용자 이름
      password: 'your_password', // 비밀번호
      db: 'your_database',       // 데이터베이스 이름
    );

    try {
      final conn = await MySqlConnection.connect(settings);

      // 예제 쿼리 실행
      var results = await conn.query('SELECT * FROM your_table');
      String fetchedData = '';
      for (var row in results) {
        fetchedData += 'ID: ${row[0]}, Name: ${row[1]}\n';
      }

      // 상태 업데이트
      setState(() {
        _dbData = fetchedData.isNotEmpty ? fetchedData : "No Data Found";
      });

      await conn.close();
    } catch (e) {
      setState(() {
        _dbData = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Database Data:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _dbData,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: _fetchDataFromDatabase,
              child: const Text("Fetch Data"),
            ),
          ],
        ),
      ),
    );
  }
}
