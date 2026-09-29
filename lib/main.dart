import 'package:flutter/material.dart';
import 'package:new_horizons_api/dashboard.dart';
import 'package:new_horizons_api/widgets.dart';
import 'package:cherry_toast/cherry_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Horizons API',
      home: const HomePage(),
    );
  }
}
//Pick the server port and Navigate to next page
class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController serverPort = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 50,
          children: [
            TextField(
              controller: serverPort,
              decoration: InputDecoration(
                label: Text(
                  "Server Port",
                )
              ),
            ),
            SimpleButton(
              icon: Icons.touch_app,
              text: "Start API Server", 
              onTap: (){
                try{
                  int port = int.parse(serverPort.text);
                  //Navigate to next page
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Dashboard(
                      serverPort: port,
                    ),
                  ));
                }catch(error){
                  CherryToast.error(
                    title: Text(
                      "Server Port must be an integer",
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}