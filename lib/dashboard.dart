import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphene_server/graphene_server.dart';
import 'widgets.dart';
import 'package:http/http.dart';
import 'package:nasa_horizons_parser/nasa_horizons_parser.dart';

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
        resolver: {
          "listMajorBodies": (arguments)async{
            //Send request, parse data, format it and return it
            Response response = await get(Uri.parse("https://ssd.jpl.nasa.gov/api/horizons.api?format=text&COMMAND='MB'"));
            List<MajorBody> majorBodies = parseMajorBodiesList(nasaHorizonsApiResponse: response.body);
            List<Map<String,dynamic>> majorBodiesAsMap = [];
            for(MajorBody majorBody in majorBodies){
              majorBodiesAsMap.add({
                "id": majorBody.id,
                "name": majorBody.name,
                "designation": majorBody.designation,
                "iau": majorBody.iau,
              });
            }
            return majorBodiesAsMap;
          },
          "getMajorBodyEphemerisData":(arguments)async{
            int bodyID = arguments["bodyID"];
            DateTime startTime = DateTime.parse(arguments["startTime"]);
            DateTime stopTime = DateTime.parse(arguments["stopTime"]);
            int simulationSteps = arguments["simulationSteps"];
            String simulationStepsUnit = arguments["simulationStepsUnit"];
            Response response = await get(Uri.parse("https://ssd.jpl.nasa.gov/api/horizons.api?format=text&COMMAND=$bodyID&EPHEM_TYPE=VECTORS&START_TIME=${startTime.year}-${startTime.month.toString().padLeft(2,"0")}-${startTime.day.toString().padLeft(2,"0")}&STOP_TIME=${stopTime.year}-${stopTime.month.toString().padLeft(2,"0")}-${stopTime.day.toString().padLeft(2,"0")}&STEP_SIZE=$simulationSteps $simulationStepsUnit&MAKE_EPHEM=YES"));
            MajorBodyEphemerisData majorBodyEphemerisData = parseMajorBodyEphemeris(nasaHorizonsApiResponse: response.body);
            Map<String,dynamic> spatialTemporalData = {};
            for(MapEntry<DateTime,SpatialTemporalData> mapEntry in majorBodyEphemerisData.spatialTemporalData.entries){
              spatialTemporalData.addAll({
                mapEntry.key.toString(): {
                  "position": {
                    "x": mapEntry.value.position.x,
                    "y": mapEntry.value.position.y,
                    "z": mapEntry.value.position.z,
                  },
                  "velocity": {
                    "x": mapEntry.value.velocity.x,
                    "y": mapEntry.value.velocity.y,
                    "z": mapEntry.value.velocity.z,
                  },
                },
              });
            }
            return {
              "meanRadius": majorBodyEphemerisData.meanRadius,
              "density": majorBodyEphemerisData.density,
              "mass": majorBodyEphemerisData.mass,
              "volume": majorBodyEphemerisData.volume,
              "siderealRotPeriodDays": majorBodyEphemerisData.siderealRotPeriodDays,
              "siderealRotRate": majorBodyEphemerisData.siderealRotRate,
              "meanSolarDay": majorBodyEphemerisData.meanSolarDay,
              "equatorialGravity": majorBodyEphemerisData.equatorialGravity,
              "momentOfInertia": majorBodyEphemerisData.momentOfInertia,
              "coreRadius": majorBodyEphemerisData.coreRadius,
              "geometricAlbedo": majorBodyEphemerisData.geometricAlbedo,
              "potentialLoveK2": majorBodyEphemerisData.potentialLoveK2,
              "gm": majorBodyEphemerisData.gm,
              "equatorialRadius": majorBodyEphemerisData.equatorialRadius,
              "gmSigma": majorBodyEphemerisData.gmSigma,
              "massRatioSunToBody": majorBodyEphemerisData.massRatioSunToBody,
              "atmosPressure": majorBodyEphemerisData.atmosPressure,
              "maxAngularDiam": majorBodyEphemerisData.maxAngularDiam,
              "meanTemperature": majorBodyEphemerisData.meanTemperature,
              "visualMagV10": majorBodyEphemerisData.visualMagV10,
              "obliquityToOrbit": majorBodyEphemerisData.obliquityToOrbit,
              "hillsSphereRad": majorBodyEphemerisData.hillsSphereRad,
              "siderealOrbPeriodYears": majorBodyEphemerisData.siderealOrbPeriodYears,
              "orbitSpeed": majorBodyEphemerisData.orbitSpeed,
              "siderealOrbPeriodDays": majorBodyEphemerisData.siderealOrbPeriodDays,
              "escapeSpeed": majorBodyEphemerisData.escapeSpeed,
              "solarConstantMean": majorBodyEphemerisData.solarConstantMean,
              "maxPlanetaryIR": majorBodyEphemerisData.maxPlanetaryIR,
              "minPlanetaryIR": majorBodyEphemerisData.minPlanetaryIR,
              "spatialTemporalData": spatialTemporalData,
            };
          }
        },
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