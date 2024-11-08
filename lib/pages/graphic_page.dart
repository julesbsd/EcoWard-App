import 'package:ecoward/components/graph_linear.dart';
import 'package:ecoward/components/graph_steps.dart';
import 'package:flutter/material.dart';

class GraphicPage extends StatelessWidget {
  const GraphicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: GraphSteps()
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Container(
              height: 300, child: GraphLinear(isShowingMainData: false)),
        ));
  }
}
