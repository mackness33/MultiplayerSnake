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
  late bool? _onlyWins = true;
  late Filters _filters;
  late Stats _stats;
  late List<PanelData> panelData = <PanelData>[
    PanelData(true, 'Filter', filtersWidget(), const Icon(Icons.filter_alt)),
    PanelData(true, 'Stats', statsWidget(), const Icon(Icons.data_usage))
  ];

  @override
  void initState() {
    _search = TextEditingController();
    _date = TextEditingController();
    _players = TextEditingController();
    _maxPoints = TextEditingController();
    _minPoints = TextEditingController();
    _databaseService.init();
    _filters = Filters(null, null, null, null, null);
    _stats = _databaseService.getStats();
    panelData = <PanelData>[
      PanelData(false, 'Filter', filtersWidget(), const Icon(Icons.filter_alt)),
      PanelData(false, 'Stats', statsWidget(), const Icon(Icons.data_usage))
    ];
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    _date.dispose();
    _players.dispose();
    _maxPoints.dispose();
    _minPoints.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('Only wins: '),
                  Checkbox(
                    value: _onlyWins,
                    tristate: true,
                    onChanged: ((bool? value) {
                      setState(() {
                        _onlyWins = value;
                        _databaseService.onlyWinsFilter(_onlyWins);
                        _stats = _databaseService.getStats();
                        panelData[1].body = statsWidget();
                        devtools.log(_stats.toString());
                      });
                    }),
                  ),
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
                      _databaseService.searchGame(_search.text);
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    panelData[index].isExpanded = !isExpanded;
                  });
                },
                children: panelData.map<ExpansionPanel>((PanelData data) {
                  return ExpansionPanel(
                    headerBuilder: ((context, isExpanded) {
                      return Text(data.header);
                    }),
                    body: data.body,
                    isExpanded: data.isExpanded,
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
                        // devtools.log(allGames.toString());
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

  Widget filtersWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 46, 178, 94)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          filterRow('Date', dateWidget(_date)),
          filterRow(
            'Points',
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: textWidget(_minPoints, 'min')),
                  Expanded(child: textWidget(_maxPoints, 'max')),
                ],
              ),
            ),
          ),
          filterRow('Players', playersWidget()),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                devtools.log('Applying filters ');
                setState(() {
                  _filters.update(_players.text, int.tryParse(_maxPoints.text),
                      int.tryParse(_minPoints.text));
                  devtools.log(_filters.toString());
                  _databaseService.applyFilters(_filters);
                  _stats = _databaseService.getStats();
                  panelData[1].body = statsWidget();
                  devtools.log(_stats.toString());
                });
              },
              child: const Text('Apply'),
            ),
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

  Widget textWidget(
    TextEditingController controller,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.only(right: 15.0, top: 20.0, bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(title.toLowerCase()),
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'eg. 12',
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget dateWidget(TextEditingController controller) {
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
              _filters.startDate = picked.start;
              _filters.endDate = picked.end;
              controller.text =
                  '${_dateFormatter(_filters.startDate)} -> ${_dateFormatter(_filters.endDate?.subtract(const Duration(days: 1)))}';
              _stats = _databaseService.getStats();
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
          hintText: 'eg. player0, player2',
        ),
        maxLines: 1,
      ),
    );
  }

  Widget statsWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 46, 178, 94)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Wins: ${_stats.countWins}'),
                Text('Losses: ${_stats.countLosses}'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Max Points Made: ${_stats.maxPointsMade}'),
                Text('Total Game Played: ${_stats.totalGamePlayed}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterData {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon icon;
  FilterData(this.isExpanded, this.header, this.body, this.icon);
}

class PanelData {
  bool isExpanded;
  final String header;
  Widget body;
  final Icon icon;
  PanelData(this.isExpanded, this.header, this.body, this.icon);
}

class Filters {
  String? players;
  int? maxPoints;
  int? minPoints;
  DateTime? startDate;
  DateTime? _endDate;

  Filters(this.players, this.maxPoints, this.minPoints, this.startDate,
      this._endDate);

  DateTime? get endDate => _endDate;
  set endDate(DateTime? eD) => _endDate = eD?.add(const Duration(days: 1));

  void update(String? players, int? maxPoints, int? minPoints) {
    this.players = players;
    this.maxPoints = maxPoints;
    this.minPoints = minPoints;
  }

  bool apply(DatabaseGame game) {
    bool result = true;

    if (players != null && players != '') {
      result &= players!.contains(game.player0) ||
          players!.contains(game.player1) ||
          players!.contains(game.player2) ||
          players!.contains(game.player3);
    }

    if (maxPoints != null) {
      result &= (game.pointsUser <= maxPoints!);
    }

    if (minPoints != null) {
      result &= (game.pointsUser >= minPoints!);
    }

    if (startDate != null && _endDate != null) {
      devtools.log(
          'StartDate is before: ${(startDate!.compareTo(game.createdAt))}');
      devtools.log('EndDate is after: ${(endDate!.compareTo(game.createdAt))}');
      result &= (startDate!.compareTo(game.createdAt) <= 0) &&
          (_endDate!.compareTo(game.createdAt) >= 0);
    }

    return result;
  }

  @override
  String toString() {
    return 'Filters: players = $players, maxPoints = $maxPoints, minPoints = $minPoints, startDate = $startDate, endDate = $_endDate';
  }
}
