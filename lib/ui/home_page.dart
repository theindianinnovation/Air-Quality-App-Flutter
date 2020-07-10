import 'package:flutter/material.dart';
import 'package:air_pollution/widgets/animated_percentage_widget.dart';
import 'package:air_pollution/widgets/activities/activity_widget.dart';
import 'package:air_pollution/widgets/activities/activities_widget.dart';
import 'package:air_pollution/widgets/video_player_widget.dart';
import 'package:air_pollution/app/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:air_quality/air_quality.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _content = 'Unknown';
  String _key = '9acb818be234c1eb4626df753a6cf8f30918dd26';
  AirQuality _airQuality;
  AppState _state = AppState.NOT_DOWNLOADED;
  AirQualityData  _data;
  final String apiUrl='https://api.waqi.info/feed/Ahmedabad/?token=demo';


  @override
  void initState() {
    super.initState();
    _airQuality = new AirQuality(_key);
    download();
  }


  Future<Map<String,dynamic>> fetchUsers() async {

    var result = await http.get(apiUrl);
    Map<String, dynamic> jsonBody = json.decode(result.body);
    return jsonBody;

  }

  String _name(dynamic user){
    return  (user['data'][0]['station']['name']).toString();

  }

  Future download() async {

    _data = null;
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    /// Via city name (London)
    AirQualityData feedFromCity = await _airQuality.feedFromCity('London');


    // Update screen state
    setState(() {
      _data=(feedFromCity);
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget _buildTitle() =>
      Text(
        _data.place,
        textAlign: TextAlign.center,
        style: Theme
            .of(context)
            .textTheme
            .subhead,
      );

  Widget _buildAirPollutionContent() =>
      Expanded(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedPercentageWidget(
              fromValue: 0.0,
              toValue: double.parse(_data.airQualityIndex.toDouble().toString()),
            ),
            Text(
              _data.airQualityLevel.toString(),
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle,
            ),
          ],
        ),
      );

  Widget _buildActivitiesWidget() =>
      Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: ActivitiesWidget(
          activities: {
            ActivityType.walking: _data.airQualityIndex<=60?ActivityQuality.good:ActivityQuality.bad,
            ActivityType.running:  _data.airQualityIndex<=60?ActivityQuality.good:ActivityQuality.bad,
            ActivityType.biking:  _data.airQualityIndex<=60?ActivityQuality.good:ActivityQuality.bad,
          },
        ),
      );

  Widget _buildDetailsWidget() =>
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: 0.5,
              child: Text(
                "Details",
                style: Theme
                    .of(context)
                    .textTheme
                    .body1,
              ),
            ),
            SizedBox(height: 5),
            Image.asset("assets/images/icon_arrow_down.png",
                width: 7, height: 7),
          ],
        ),
      );

  Widget _buildExpandedContent() =>
      Expanded(
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            _buildAirPollutionContent(),
            _buildDetailsWidget(),
          ],
        ),
      );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        child: FutureBuilder<Map<String,dynamic>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
                print((snapshot.data));
                return Text(_name(snapshot.data));
             }else {
              return Center(child: CircularProgressIndicator());
            }}
        ),
      ),
    );
  }
}
//  @override
//  Widget build(BuildContext context) {
//
//    return Stack(
//      children: <Widget>[
//        VideoPlayerWidget(videoPath: "assets/video/fog.mp4"),
//        _state==AppState.FINISHED_DOWNLOADING?
//        SafeArea(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              _buildTitle(),
//              _buildExpandedContent(),
//              _buildActivitiesWidget(),
//            ],
//          ),
//        ):Container(),
//      ],
//    );
//  }
//}
//
