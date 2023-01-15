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
  late bool? _onlyWins;
  late final TextEditingController _search;
  late final TextEditingController _date;
  late final TextEditingController _players;
  late final TextEditingController _maxPoints;
  late final TextEditingController _minPoints;
  late Filters _filters;
  late DatabaseGamesStats _stats;
  late List<PanelData> _panelData;

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
    _panelData = <PanelData>[
      PanelData(
        false,
        headerWidget(title: 'Filters', icon: const Icon(Icons.filter_alt)),
        filtersWidget(),
        const Icon(Icons.filter_alt),
      )
    ];
    _onlyWins = null;
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
        title: const Center(child: Text("Statistics")),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              searchWidget(title: 'Search'),
              expansionPanel(setStatePanel: setExpanded),
              statsWidget(),
              gamesWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // Games

  Widget gamesWidget() {
    return StreamBuilder(
      stream: _databaseService.allGames,
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allGames = snapshot.data as List<DatabaseGame>;

              return ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: allGames.length,
                itemBuilder: (context, index) =>
                    gameCardWidget(game: allGames[index]),
              );
            } else {
              return const CircularProgressIndicator();
            }
          default:
            return const CircularProgressIndicator();
        }
      }),
    );
  }

  Widget gameCardWidget({required DatabaseGame game}) {
    return gameCard(
      game: game,
      rules: <Widget>[
        ruleRow(
          rules: <Widget>[
            ruleWidget(
              title: 'Max Points',
              value: (game.maxPoints == 0) ? '-' : game.maxPoints.toString(),
              // value: '-',
            ),
            ruleWidget(
              title: 'Max Time',
              value: (game.maxTime == 0) ? '-' : game.maxTime.toString(),
            ),
          ],
        ),
        ruleRow(
          rules: <Widget>[
            ruleWidget(
              title: 'Public',
              value: game.public.toString(),
            ),
            ruleWidget(
              title: 'Total players',
              value: game.players.length.toString(),
            ),
          ],
        ),
      ],
    );
  }

  // Expanded Panels

  void setExpanded({required int index, required bool isExpanded}) {
    setState(() {
      _panelData[index].isExpanded = !isExpanded;
    });
  }

  List<ExpansionPanel> listExpansionPanel() {
    return _panelData.map<ExpansionPanel>((PanelData data) {
      return ExpansionPanel(
        headerBuilder: ((context, isExpanded) {
          return data.header;
        }),
        body: data.body,
        isExpanded: data.isExpanded,
      );
    }).toList();
  }

  Widget expansionPanel({
    required Function setStatePanel,
  }) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setStatePanel(index: index, isExpanded: isExpanded);
      },
      children: listExpansionPanel(),
    );
  }

  Widget headerWidget({required String title, required Icon icon}) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Search

  Widget onlyWinsCheckbox({required String title}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17.5),
        ),
        const SizedBox(width: 10),
        Checkbox(
          value: _onlyWins,
          tristate: true,
          onChanged: ((bool? value) {
            setState(() {
              _onlyWins = value;
              _databaseService.onlyWinsFilter(_onlyWins);
              _stats = _databaseService.getStats();
            });
          }),
        ),
      ],
    );
  }

  Widget searchWidget({required String title}) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          onlyWinsCheckbox(title: 'Only Wins'),
          Expanded(
            child: TextField(
              controller: _search,
              enableSuggestions: false,
              autocorrect: false,
              style: const TextStyle(fontSize: 17.5),
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: "Enter name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              _databaseService.searchGame(_search.text);
              setState(() {
                _stats = _databaseService.getStats();
              });
            },
            child: Text(
              title,
              style: const TextStyle(fontSize: 17.5),
            ),
          ),
        ],
      ),
    );
  }

  // filters panel

  Widget filtersWidget() {
    return Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filters.reset();
                      _databaseService.applyFilters(_filters);
                      _stats = _databaseService.getStats();
                      _maxPoints.text = '';
                      _minPoints.text = '';
                      _date.text = '';
                      _players.text = '';
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 17.5),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    devtools.log('Applying filters ');
                    setState(() {
                      _filters.update(
                          _players.text,
                          int.tryParse(_maxPoints.text),
                          int.tryParse(_minPoints.text));
                      _databaseService.applyFilters(_filters);
                      _stats = _databaseService.getStats();
                    });
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 17.5),
                  ),
                ),
              ],
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

  // stats Board

  Widget statsWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.indigo),
      child: rulesWidget(rows: <Widget>[
        ruleRow(
          rules: <Widget>[
            ruleWidget(
              title: 'Wins',
              value: _stats.countWins.toString(),
            ),
            ruleWidget(
              title: 'Total Game Played',
              value: _stats.totalGamePlayed.toString(),
            ),
          ],
        ),
        ruleRow(
          rules: <Widget>[
            ruleWidget(
              title: 'Max Points Made',
              value: _stats.maxPointsMade.toString(),
            ),
            ruleWidget(
              title: 'Losses',
              value: _stats.countLosses.toString(),
            ),
          ],
        ),
      ], title: 'Stats'),
    );
  }
}

class PanelData {
  bool isExpanded;
  final Widget header;
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

  Filters.empty();

  DateTime? get endDate => _endDate;
  set endDate(DateTime? eD) => _endDate = eD?.add(const Duration(days: 1));

  void update(String? players, int? maxPoints, int? minPoints) {
    this.players = players;
    this.maxPoints = maxPoints;
    this.minPoints = minPoints;
  }

  void reset() {
    players = null;
    maxPoints = null;
    minPoints = null;
    startDate = null;
    _endDate = null;
  }

  bool apply(DatabaseGame game) {
    bool result = true;

    if (players != null && players != '') {
      result &= game.players.fold(
          false,
          (previousValue, player) =>
              previousValue || players!.contains(player.email));
    }

    if (maxPoints != null) {
      result &= (game.user.points <= maxPoints!);
    }

    if (minPoints != null) {
      result &= (game.user.points >= minPoints!);
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
