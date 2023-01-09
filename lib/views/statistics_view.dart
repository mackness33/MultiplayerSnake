import "package:flutter/material.dart";
import 'package:multiplayersnake/services/database/database_game.dart';
import 'package:multiplayersnake/services/database/database_games_service.dart';

import "dart:developer" as devtools show log;

import 'package:multiplayersnake/utils/game_card.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final DatabaseGamesService _databaseService = DatabaseGamesService();
  late final TextEditingController _search;
  late final TextEditingController _date;
  late final TextEditingController _players;
  late final TextEditingController _maxPoints;
  late final TextEditingController _minPoints;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late bool? _onlyWon;
  late bool? _onlyLosses;

  @override
  void initState() {
    _search = TextEditingController();
    _date = TextEditingController();
    _players = TextEditingController();
    _maxPoints = TextEditingController();
    _minPoints = TextEditingController();
    _databaseService.init();
    _onlyWon = true;
    _onlyLosses = true;
    _startDate = null;
    _endDate = null;
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Filter> filterData = List.generate(
      1,
      ((index) =>
          Filter(true, 'Filter', filters(), const Icon(Icons.filter_alt))),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      devtools.log('Search');
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  devtools.log('isExpanded: $isExpanded');
                  setState(() {
                    filterData.first.isExpanded = !isExpanded;
                  });
                },
                children: filterData.map<ExpansionPanel>((Filter filter) {
                  return ExpansionPanel(
                    headerBuilder: ((context, isExpanded) {
                      return Text(filter.header);
                    }),
                    body: filter.body,
                    isExpanded: filter.isExpanded,
                  );
                }).toList(),
              ),
              StreamBuilder(
                stream: _databaseService.allGames,
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allGames = snapshot.data as List<DatabaseGame>;
                        devtools.log(allGames.toString());
                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allGames.length,
                          itemBuilder: (context, index) {
                            final game = allGames[index];
                            return gameCard(game);
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filters() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 46, 178, 94)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          filterRow('Date', dateWidget(_date, _startDate, _endDate)),
          filterRow(
            'Points',
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: minWidget()),
                  Expanded(child: maxWidget()),
                ],
              ),
            ),
          ),
          filterRow('Players', playersWidget()),
          filterRow(
            'Only',
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                onlyWidget('Won', _onlyWon),
                onlyWidget('Loss', _onlyLosses),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              devtools.log('Applying filters ');
              // _databaseService.applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget filterRow(String title, Widget body) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 30.0, top: 10.0, bottom: 15.0),
          child: Text(title),
        ),
        body
      ],
    );
  }

  Widget onlyWidget(String name, bool? state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(name),
        Checkbox(
          value: state,
          onChanged: ((value) {
            setState(() {
              state = value;
            });
          }),
        ),
      ],
    );
  }

  Widget minWidget() {
    return Container(
      padding: const EdgeInsets.only(right: 15.0, top: 20.0, bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: const Text('min'),
          ),
          Expanded(
            child: TextField(
              controller: _minPoints,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Min",
              ),
              maxLines: 1,
              maxLength: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget maxWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 15.0),
          child: const Text('max'),
        ),
        Expanded(
          child: TextField(
            controller: _maxPoints,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Max",
            ),
            maxLines: 1,
            maxLength: 4,
          ),
        ),
      ],
    );
  }

  Widget dateWidget(TextEditingController controller, DateTime? startDate,
      DateTime? endDate) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
          labelText: "Enter Date",
        ),
        readOnly: true,
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
              start: (DateTime.now()).subtract(const Duration(days: 7)),
              end: (DateTime.now()),
            ),
            lastDate: DateTime.now(),
            firstDate: DateTime(2019),
          );
          if (picked != null) {
            setState(() {
              startDate = picked.start;
              endDate = picked.end;
              controller.text =
                  '${_dateFormatter(startDate)} -> ${_dateFormatter(endDate)}';
            });
          }
        },
      ),
    );
  }

  String _dateFormatter(DateTime? date) {
    return (date != null) ? '${date.day}/${date.month}/${date.year}' : '';
  }

  Widget playersWidget() {
    return Expanded(
      child: TextField(
        controller: _players,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Players',
        ),
        maxLines: 1,
      ),
    );
  }
}

class Filter {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon icon;
  Filter(this.isExpanded, this.header, this.body, this.icon);
}
