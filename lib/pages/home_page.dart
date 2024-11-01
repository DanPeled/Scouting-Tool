// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Project imports:
import 'package:scouting_site/pages/login_page.dart';
import 'package:scouting_site/pages/summation/averages/averages_page.dart';
import 'package:scouting_site/services/formatters/text_formatter_builder.dart';
import 'package:scouting_site/services/localstorage.dart';
import 'package:scouting_site/services/scouting/scouting.dart';
import 'package:scouting_site/services/title_case.dart';
import 'package:scouting_site/theme.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_text_input.dart';

class ScoutingSite extends StatelessWidget {
  const ScoutingSite({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    bool isDarkMode = brightness == Brightness.dark;
    GlobalColors.primaryColor = isDarkMode ? Colors.black : Colors.white;

    return MaterialApp(
      title: 'Scouting Site',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: GlobalColors.primaryColor,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scouterController = TextEditingController();
  final _gameController = TextEditingController();

  List<String> _teams = [];
  String? _selectedTeam;
  int _selectedTeamIndex = -1;
  int _previousGame = 0;

  @override
  void initState() {
    Scouting.data.game = 0;
    super.initState();
    _scouterController.text = Scouting.data.scouter ?? '';
    _gameController.text = Scouting.data.game?.toString() ?? '';

    _gameController.addListener(() {
      submitGameNum(_gameController.text);
    });

    _selectedTeam = Scouting.data.scoutedTeam;
  }

  void _updateTeams() {
    if (Scouting.data.game != null) {
      List<String> gameTeams = [];

      var (redAlliance, blueAlliance) = Scouting.matchesTeamsPair();
      redAlliance[Scouting.data.game]?.forEach((team) => gameTeams.add(team));
      blueAlliance[Scouting.data.game]?.forEach((team) => gameTeams.add(team));

      _teams = gameTeams;
    } else {
      var (redAlliance, blueAlliance) = Scouting.matchesTeamsPair();

      for (var game in redAlliance.keys) {
        _teams.addAll(redAlliance[game] ?? []);
        _teams.addAll(blueAlliance[game] ?? []);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateTeams();

    if (_selectedTeamIndex != -1 &&
        _previousGame != Scouting.data.game &&
        (!_teams.contains(Scouting.data.scoutedTeam) ||
            _teams.indexOf(Scouting.data.scoutedTeam ?? "") !=
                _selectedTeamIndex)) {
      setState(() {
        _selectedTeam = _teams.isNotEmpty
            ? _teams[0]
            : null; // Default to the first team or null
        Scouting.data.scoutedTeam = _selectedTeam;
      });
    }

    bool isRedAllianceTeamSelected = _selectedTeamIndex <= 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.appBarColor,
        title: const Text(
          "Scouting-Site",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: GlobalColors.teamColor,
          ),
        ),
      ),
      body: Container(
        color: GlobalColors.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5),
              DialogTextInput(
                label: "Scouter name",
                textEditingController: _scouterController,
                onSubmit: (value) {
                  Scouting.data.scouter = value;
                },
                initialText: Scouting.data.scouter,
              ),
              const SizedBox(height: 5),
              DialogTextInput(
                onSubmit: submitGameNum,
                label: "Game #",
                textEditingController: _gameController,
                formatter: TextFormatterBuilder.integerTextFormatter(),
              ),
              const SizedBox(height: 5),
              getScoutedTeamWidget(isRedAllianceTeamSelected),
              const SizedBox(height: 10),
              DropdownMenu<MatchType>(
                label: const Text("Match type"),
                initialSelection: MatchType.normal,
                dropdownMenuEntries: MatchType.values
                    .map((type) => DropdownMenuEntry(
                          value: type,
                          label: type.name.toTitleCase(),
                        ))
                    .toList(),
                onSelected: (matchType) {
                  Scouting.data.matchType = matchType ?? MatchType.normal;
                },
                width: MediaQuery.of(context).size.width - 100,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                width: 5,
              ),
              FloatingActionButton(
                tooltip: "Entries",
                child: const Icon(Icons.summarize),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AveragesPage(),
                    ),
                  );
                },
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 140),
              ),
              FloatingActionButton(
                heroTag: 1,
                tooltip: "Scout",
                child: const Icon(Icons.login_outlined),
                onPressed: () async {
                  final scouterName = _scouterController.text.trim();
                  final gameNumber = _gameController.text.trim();

                  if (scouterName.isEmpty ||
                      _selectedTeam == null ||
                      (_teams.isNotEmpty && !_teams.contains(_selectedTeam)) ||
                      (_selectedTeam?.isEmpty ?? true)) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Validation Error'),
                          content:
                              const Text('Please fill in all required fields.'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  localStorage?.setInt("game", int.parse(gameNumber));
                  localStorage?.setString("scouter", scouterName);
                  localStorage?.setString("scoutedTeam", _selectedTeam ?? "");

                  Scouting.advance(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getScoutedTeamWidget(bool isRedAllianceTeamSelected) {
    if (_teams.isNotEmpty) {
      return DropdownMenu<String>(
        label: const Text(
          "Scouting On",
        ),
        initialSelection: Scouting.data.scoutedTeam,
        onSelected: (value) {
          setState(() {
            _selectedTeam = value.toString();
            _selectedTeamIndex = _teams.indexOf(_selectedTeam ?? _teams[0]);
            Scouting.data.scoutedTeam = _selectedTeam;
          });
        },
        textStyle: TextStyle(
          color:
              isRedAllianceTeamSelected ? Colors.redAccent : Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        dropdownMenuEntries: getTeamDropdownEntries(),
        width: MediaQuery.of(context).size.width - 5,
      );
    } else {
      return DialogTextInput(
        onSubmit: (value) {
          setState(() {
            _selectedTeam = value.toString();
            _selectedTeamIndex = _teams.indexOf(_selectedTeam ?? _teams[0]);
            Scouting.data.scoutedTeam = _selectedTeam;
          });
        },
        label: "Scouting On",
        keyboard: TextInputType.number,
        formatter:
            TextFormatterBuilder.integerTextFormatter(allowNegative: false),
      );
    }
  }

  List<DropdownMenuEntry<String>> getTeamDropdownEntries() {
    List<DropdownMenuEntry<String>> entries = [];
    if (_teams.isNotEmpty) {
      for (int i = 0; i < _teams.length; i++) {
        bool blueAlliance = i > 2;
        String labelText =
            "${blueAlliance ? "Blue" : "Red"} ${(i + 1) % 3 == 0 ? 3 : (i + 1) % 3}: ${_teams[i]}";
        bool isSelected = i == _teams.indexOf(Scouting.data.scoutedTeam ?? "");

        if (isSelected) {
          _selectedTeamIndex = i;
        }

        entries.add(
          DropdownMenuEntry(
            label: labelText,
            labelWidget: Text(
              labelText,
              style: TextStyle(
                color: blueAlliance ? Colors.blueAccent : Colors.redAccent,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            value: _teams[i],
          ),
        );
      }
    }

    return entries;
  }

  void submitGameNum(String value) {
    setState(() {
      _previousGame = Scouting.data.game ?? 0;
      Scouting.data.game = int.tryParse(value);
    });
  }
}
