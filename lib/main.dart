import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoggedIn = false;

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados para calcular o seu IMC";
  String _imcText = "";

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

  _logout() async {
    try {
      await _googleSignIn.signOut();
      setState(() {
        isLoggedIn = false;
      });
    } catch (err) {
      print(err);
    }
  }

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados para calcular o seu IMC";
      _imcText = "";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      _infoText = "";
      print(imc);
      if (imc < 18.6) {
        _imcText = "Abaixo do Peso! (${imc.toStringAsPrecision(3)})";
      } else if (imc > 18.6 && imc < 24.9) {
        _imcText = "Peso Ideal! (${imc.toStringAsPrecision(3)})";
      } else if (imc > 24.9 && imc < 29.9) {
        _imcText = "Levemente Acima do Peso! (${imc.toStringAsPrecision(3)})";
      } else if (imc > 29.9 && imc < 34.9) {
        _imcText = "Obesidade Grau I! (${imc.toStringAsPrecision(3)})";
      } else if (imc > 34.9 && imc < 39.9) {
        _imcText = "Obesidade Grau II! (${imc.toStringAsPrecision(3)})";
      } else if (imc > 40) {
        _imcText = "Obesidade Grau III! (${imc.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage:
                        NetworkImage(_googleSignIn.currentUser.photoUrl),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text(_googleSignIn.currentUser.displayName,
                        style: TextStyle(fontSize: 15.0)),
                  )
                ],
              ),
              centerTitle: false,
              backgroundColor: Colors.blue,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: _logout,
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          _infoText,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Peso (kg)",
                            labelStyle: TextStyle(color: Colors.blue)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontSize: 21.0),
                        controller: weightController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Insira seu Peso!";
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Altura (cm)",
                            labelStyle: TextStyle(color: Colors.blue)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontSize: 21.0),
                        controller: heightController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Insira sua Altura!";
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
                        child: Container(
                          height: 50.0,
                          width: 250.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _calculate();
                              }
                            },
                            child: Text("Calcular",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25.0)),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(_imcText,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      )
                    ],
                  ),
                )),
            bottomNavigationBar: BottomAppBar(
              color: Colors.lightBlue,
              child: Container(
                height: 25.0,
                margin: EdgeInsets.all(20.0),
                child: FlatButton(
                  color: Colors.black.withOpacity(0.0),
                  splashColor: Colors.black26,
                  onPressed: _resetFields,
                  child: Icon(
                    Icons.refresh_outlined,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("IMC KALK"),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100.0,
                  child: Image.asset("images/google.png"),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: _login,
                    child: Text(
                      "Login com Google",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
                isLoggedIn
                    ? Text(_googleSignIn.currentUser.displayName)
                    : Container()
              ],
            ),
          );
  }
}
