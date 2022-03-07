import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'qdcompliance.dart';

void main() {
  runApp(const MyApp());
}

Widget _buildPopupDialog(BuildContext context, String title, String message,
    String buttonTitle, Function buttonAction,
    {String? secondButtonTitle, Function? secondButtonAction}) {
  return AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(message),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          buttonAction();
          Navigator.of(context).pop();
        },
        child: Text(buttonTitle),
      ),
      if (secondButtonTitle != null)
        TextButton(
            onPressed: () {
              if (secondButtonAction != null) secondButtonAction();
              Navigator.of(context).pop();
            },
            child: Text(buttonTitle)),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openGDPR() {
    QDCompliance.openConsentForm(ComplianceType.GDPR).then((value) {
      String? valueObj = cast(value);
      if (valueObj == null) return;

      print(valueObj);
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(
                  context, "Error", error.toString(), "buttonTitle", () {
                print("button clicked");
              }));
    });
  }

  void _openCCPA() {
    QDCompliance.openConsentForm(ComplianceType.CCPA);
  }

  void _openConsentIfNeeded() {
    QDCompliance.openConsentFormIfNeeded();
  }

  Future<T?> optOut<T>() {
    const platform = MethodChannel('io.quadrant.compliance');
    return platform.invokeMethod<T>("optOut");
  }

  T? cast<T>(x) => x is T ? x : null;

  // void _handleError(e:)

  void _showRequestSuccess(String request) {
    showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context,
            "Success",
            "Your '" + request + "' request has been sent to our data",
            "Nice",
            () {}));
  }

  void _showError(dynamic error) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildPopupDialog(context, "Error", error.toString(), "OK", () {}));
  }

  void _runConsentRequest<T>(
      Future<dynamic> Function() futureFunction, String name) {
    showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context, name,
                "Are you sure you want to '" + name + "'?", "Yes", () {
              futureFunction().then((value) {
                bool? valueObj = cast(value);
                if (valueObj != true) return;

                _showRequestSuccess(name);
              }).catchError((error) {
                _showError(error);
              });
            }));
  }

  void _optOut() {
    _runConsentRequest(QDCompliance.optOut, "Opt Out");
  }

  void _doNotSell() {
    _runConsentRequest(QDCompliance.doNotSell, "Do Not Sell My Data");
  }

  void _deleteMyData() {
    _runConsentRequest(QDCompliance.deleteMyData, "Delete My Data");
  }

  void _requestMyData() {
    _runConsentRequest(QDCompliance.requestMyData, "Request My Data");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Open Consent",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment(-1, 0),
            ),
            Container(
              alignment: Alignment(-1, 0),
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: _openConsentIfNeeded,
                      child: const Text('Open If Needed')),
                  TextButton(
                      onPressed: _openGDPR, child: const Text('Open GDPR')),
                  TextButton(
                      onPressed: _openCCPA, child: const Text('Open CCPA')),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Data and Privacy",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment(-1, 0),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(onPressed: _optOut, child: const Text('Opt Out')),
                  TextButton(
                      onPressed: _doNotSell,
                      child: const Text('Do Not Sell My Personal Information')),
                  TextButton(
                      onPressed: _deleteMyData,
                      child: const Text('Delete My Data')),
                  TextButton(
                      onPressed: _requestMyData,
                      child: const Text('Request My Data')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
