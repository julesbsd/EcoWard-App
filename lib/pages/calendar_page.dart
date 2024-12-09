import 'dart:developer';

import 'package:ecoward/components/calendar_tile.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late UserProvider pUser;

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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

  @override
  Widget build(BuildContext context) {
    final actionsForSelectedDay =
        _selectedDay != null ? _getActionsForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique'),
        // backgroundColor: Color.fromRGBO(0, 230, 118, 1),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: Localizations.localeOf(context).toString(),
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 16,
                      height: 16,
                      child: Center(
                        child: Text(
                          '$actionCount',
                          style: TextStyle().copyWith(
                            color: Colors.white,
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
          Expanded(
            child: actionsForSelectedDay.isEmpty
                ? Center(child: Text('Aucune action'))
                : ListView.builder(
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
          ),
        ],
      ),
    );
  }
}