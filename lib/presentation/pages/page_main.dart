import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageMain extends StatefulWidget {
  const PageMain({super.key});

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  String name = "Baby Yoda";
  final TextEditingController _valueController = TextEditingController();
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    String? storedKey = _preferences.getString("myKey");
    if (storedKey != null) {
      setState(() {
        name = storedKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/wallpaper.png"), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                _buildTextField(),
                const SizedBox(height: 20),
                _buildText(),
                const SizedBox(height: 330),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton("Set Data", OperationType.set),
                    const SizedBox(width: 40),
                    _buildButton("Get Data", OperationType.get)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextField _buildTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: _valueController,
      decoration: const InputDecoration(
        hintText: "Enter Value",
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
    );
  }

  Text _buildText() {
    return Text(
      name,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildButton(String label, Enum operationType) {
    const String key = "myKey";
    return InkWell(
      onTap: () async {
        if (operationType == OperationType.set) {
          if (_valueController.text.isNotEmpty) {
            await _preferences.setString(key, _valueController.text);
            setState(() {
              _valueController.text = "";
            });
          }
        } else {
          String? name = await _preferences.getString(key);
          if (name != null) {
            setState(() {
              this.name = name;
            });
          }
        }
      },
      child: Container(
        width: 130,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          border: Border.all(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )),
      ),
    );
  }
}

enum OperationType { set, get }
