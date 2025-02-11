// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:scouting_site/pages/home_page.dart';
import 'package:scouting_site/pages/summation/averages/averages_page.dart';
import 'package:scouting_site/pages/summation/scouting_entries_page.dart';
import 'package:scouting_site/theme.dart';

AppBar getScoutAppBar(String title) {
  return AppBar(
    backgroundColor: GlobalColors.appBarColor,
    leading: SizedBox(
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
    ),
    titleSpacing: 10,
    title: Row(children: [
      Image.asset(
        "images/team_logo.png",
        width: 44,
        height: 44,
      ),
      const SizedBox(width: 15),
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: GlobalColors.teamColor,
        ),
      )
    ]),
  );
}

void navigateTo(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Drawer getScoutHamburgerMenu(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Text(""),
        ),
        ListTile(
          leading: const Icon(Icons.biotech_rounded),
          title: const Text("Scout"),
          onTap: () {
            navigateTo(context, const HomePage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.summarize_rounded),
          title: const Text("Avgs."),
          onTap: () {
            navigateTo(context, AveragesPage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.dataset_rounded),
          title: const Text("Entries"),
          onTap: () {
            navigateTo(context, const ScoutingEntriesPage());
          },
        )
      ],
    ),
  );
}
