import 'package:flutter/material.dart';

class EcomScreen extends StatelessWidget {
  const EcomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Stack(
            children: [
              // Main container
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )
                ),
              ),

              // Positioned container 1
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                    )
                ),
              )),

              // Positioned container 1
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      topLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                    child: Container(
                      height: 200,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            topLeft: Radius.circular(100),
                          )
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
