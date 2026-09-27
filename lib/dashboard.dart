import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphene_server/graphene_server.dart';
import 'widgets.dart';
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const new({
    super.key,
    required this.serverPort,
  });
  final int serverPort;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Future<void> startApiServer()async{
    HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, widget.serverPort);
    startServer(
      server: server, 
      getHandler: GetHandler(
        handler: (arguments)async{
          return GetResponse(
            bytes: Uint8List.fromList("Running New Horizons API Server".codeUnits),
            mimeType: "text/plain",
          );
        },
      ), 
      query: GrapheneQuery(
        resolver: {},
      ), 
      mutations: GrapheneMutation(
        resolver: {},
      ), 
      redirectHandler: (arguments) => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: startApiServer(), 
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 50,
                children: [
                  Text(
                    snapshot.error.toString(),
                  ),
                  SimpleButton(
                    icon: Icons.touch_app,
                    text: "Go back",
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }else if(snapshot.connectionState == ConnectionState.done){
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsetsGeometry.all(20),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 50,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Server is Running. Do not close this window.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Image.asset(
                      "images/logo.png",
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
            );
          }
        },
      ),
    );
  }
}