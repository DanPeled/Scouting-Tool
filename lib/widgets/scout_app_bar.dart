import 'package:flutter/material.dart';
import 'package:scouting_site/theme.dart';

AppBar getScoutAppBar(String title) {
  return AppBar(
    backgroundColor: GlobalColors.appBarColor,
    leading: Image.asset("images/team_logo.png"),
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: GlobalColors.teamColor,
      ),
    ),
  );
}
