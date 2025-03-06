import 'dart:developer';

import 'package:ecoward/components/calendar_tile.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late UserProvider pUser;
/**
 * @TODO : Récupérer de l'api les actions de l'utilisateur pour les afficher dans le calendrier
 */
  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  List<dynamic> _getActionsForDay(DateTime day) {
    return pUser.getActions
        .where((action) {
          try {
            return isSameDay(DateTime.parse(action.created_at), day);
          } catch (e) {
            // Log the error and return false to exclude this action
            log('Invalid date format: ${action.created_at}');
            return false;
          }
        })
        .map((action) => action.toJson())
        .toList();
  }

  int _getActionCountForDay(DateTime day) {
    return _getActionsForDay(day).length;
  }

  Widget buildPedometerGauge(String title, int steps, {int dailyGoal = 10000}) {
    double percent = (steps / dailyGoal).clamp(0.0, 1.0);
    print('percent: $percent');
    return CircularPercentIndicator(
      radius: 65,
      lineWidth: 11.0,
      percent: percent, // Entre 0.0 et 1.0
      arcBackgroundColor:
          Theme.of(context).colorScheme.secondary, // Couleur de fond de l'arc
      animation: true, // Si vous voulez une animation
      arcType: ArcType.FULL, // Demi-cercle
      startAngle: 0,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_walk,
              size: 30.0, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            '$steps',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      header: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Theme.of(context).colorScheme.primary, // Couleur de l’arc
      backgroundColor: Colors.grey[300]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final actionsForSelectedDay =
        _selectedDay != null ? _getActionsForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
        // backgroundColor: Color.fromRGBO(0, 230, 118, 1),
        // backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TableCalendar(
              locale: Localizations.localeOf(context).toString(),
              headerStyle:
                  HeaderStyle(formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.0,
                  ),
                ),
                todayTextStyle: TextStyle(color: Colors.black),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.rectangle,
                ),
                selectedTextStyle: TextStyle(color: Colors.black),
              ),
              firstDay: DateTime(2010, 1, 1),
              lastDay: DateTime(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  final actionCount = _getActionCountForDay(day);
                  if (actionCount > 0) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD600),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: 18,
                        height: 18,
                        child: Center(
                          child: Text(
                            '$actionCount',
                            style: TextStyle().copyWith(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFBEBEBE),
                              offset: Offset(3, 5),
                              blurRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-7, -7),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: Center(
                          child: buildPedometerGauge("Nombre de pas", 2514),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFBEBEBE),
                              offset: Offset(3, 5),
                              blurRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-7, -7),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'CO2 économisé',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Center(
                              child: Icon(Icons.cloud_outlined,
                                  size: 100,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            Text(
                              '259 g',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actionsForSelectedDay.isEmpty
                      ? Center(child: Text('Aucune action réalisée'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: actionsForSelectedDay.length,
                          itemBuilder: (context, index) {
                            final action = actionsForSelectedDay[index];
                            return CalendarTile(
                                status: action['status'],
                                points: action['points'],
                                quantity: action['quantity'],
                                trashname: action['trashname']);
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
