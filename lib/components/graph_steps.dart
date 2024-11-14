import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphSteps extends StatefulWidget {
  final List<dynamic> weekSteps;

  GraphSteps({super.key, required this.weekSteps});

  @override
  State<StatefulWidget> createState() => GraphStepsState();
}

class GraphStepsState extends State<GraphSteps> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Nombre de pas',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  child: BarChart(
                    mainBarData(),
                    swapAnimationDuration: animDuration,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getMaxSteps() {
    final maxSteps = widget.weekSteps
        .map((day) => (day['steps'] as num).toDouble() == 0 ? 1 : (day['steps'] as num).toDouble())
        .reduce(max);
    return (maxSteps / 1000).ceil() * 1000; // Arrondit à la centaine supérieure
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    final maxSteps = getMaxSteps();
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: Theme.of(context).colorScheme.primary,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.black)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxSteps, // Utilise la valeur maximale de pas comme échelle
            color: Colors.grey.shade300,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(widget.weekSteps.length, (i) {
      final dayData = widget.weekSteps[i];
      final steps = dayData['steps']
          .toDouble(); // Utilise le nombre de pas pour chaque jour
      return makeGroupData(i, steps, isTouched: i == touchedIndex);
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Lundi';
                break;
              case 1:
                weekDay = 'Mardi';
                break;
              case 2:
                weekDay = 'Mercredi';
                break;
              case 3:
                weekDay = 'Jeudi';
                break;
              case 4:
                weekDay = 'Vendredi';
                break;
              case 5:
                weekDay = 'Samedi';
                break;
              case 6:
                weekDay = 'Dimanche';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.bold,

                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toInt().toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getLeftTitles,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontFamily: 'CaviarDreams',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black
    );
    final maxSteps = getMaxSteps();
    String text;

    if (value == 0) {
      text = "0"; // 0% des pas
    } else if (value == (maxSteps / 2).toInt()) {
      text = (maxSteps / 2).toInt().toString(); // 50% de la valeur maximale
    } else if (value == maxSteps) {
      text = maxSteps.toInt().toString(); // 100% de la valeur maximale
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('L', style: style);
        break;
      case 1:
        text = const Text('M', style: style);
        break;
      case 2:
        text = const Text('M', style: style);
        break;
      case 3:
        text = const Text('J', style: style);
        break;
      case 4:
        text = const Text('V', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('D', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
