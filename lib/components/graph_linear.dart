import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphLinear extends StatelessWidget {
  const GraphLinear({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 7,
        maxY: 4,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_2,
      ];

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Lun', style: style);
        break;
      case 1:
        text = const Text('Mar', style: style);
        break;
      case 2:
        text = const Text('Mer', style: style);
        break;
      case 3:
        text = const Text('Jeu', style: style);
        break;
      case 4:
        text = const Text('Ven', style: style);
        break;
      case 5:
        text = const Text('Sam', style: style);
        break;
      case 6:
        text = const Text('Dim', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    double maxValue=0.0;

    // for (int i=0; i<Valeur.length ;i++) {
    //     (maxValue<valeur[i])
    //     maxValue=valeur[i];
    // }


    if(maxValue>10000){
      switch (value.toInt()) {  // SOIT TU METS DES VALEURS PAR DEFAUT SOIT TU DIVISE PAR LE NOMBRE DE DIVISION QUE TU VEUX SI TU VEUX 4 CHIFFRE QUI REPRENSENTE L'ECHELLE MAX/x x REPRESENTANT L'ECHELLE 
      case 1:
        text = '2000';
        break;
      case 2:
        text = '4000';
        break;
      case 3:
        text = '6000';
        break;
      case 4:
        text = '8000';
        break;
      case 5:
        text = '10000';
        break;
      default:
        return Container();
    }
    }else{
switch (value.toInt()) {
      case 1:
        text = '500';
        break;
      case 2:
        text = '1000';
        break;
      case 3:
        text = '2000';
        break;
      case 4:
        text = '3000';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }
    }
    

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 50,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.green, width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Color.fromRGBO(0, 230, 118, 1),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.red,
        ),
        spots: const [
          FlSpot(0, 50000),
          FlSpot(1, 1),
          FlSpot(2, 1),
          FlSpot(3, 2.8),
          FlSpot(4, 1.2),
          FlSpot(5, 2.8),
          FlSpot(6, 2.6),
          FlSpot(7, 3.9),
        ],
      );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text(
                'Monthly Sales',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: GraphLinear(isShowingMainData: isShowingMainData),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
