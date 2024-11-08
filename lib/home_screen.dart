import 'package:first_app/store_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 300.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade200.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(150.0),
                      topRight: Radius.circular(150.0)
                    )
                  ),
                ),
                const Positioned.fill(
                  bottom: -20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Tinyshop",
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            TextButton(
            onPressed: (){
              debugPrint("Button pressed");
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreScreen()));
            },
             child: Text(
              "Open Store",
              style: TextStyle(
                fontSize: 24,
                color: Colors.orange.shade400
              ),
             ))
          ],
        ),
      )
    );
  }
}