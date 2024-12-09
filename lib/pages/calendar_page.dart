import 'dart:developer';

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

  @override
  Widget build(BuildContext context) {
    final actionsForSelectedDay = _selectedDay != null ? _getActionsForDay(_selectedDay!) : [];

    return Scaffold(
      // appBar: AppBar(

      //   title: Text('TableCalendar - Basics'),
      // ),
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
          ),
          Expanded(
            child: actionsForSelectedDay.isEmpty
                ? Center(child: Text('Aucune action'))
                : ListView.builder(
                    itemCount: actionsForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final action = actionsForSelectedDay[index];
                      return ListTile(
                        title: Text('ID: ${action['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${action['status']}'),
                            Text('Location: ${action['location']}'),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}