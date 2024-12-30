// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';

class AvgsGraph extends StatelessWidget {
  final List<double> avgSpots;
  final List<double> teamSpots;
  final List<int> games;
  final ChartPointInteractionCallback? onPointDoubleClicked;

  const AvgsGraph(
      {super.key,
      required this.avgSpots,
      required this.teamSpots,
      required this.games,
      this.onPointDoubleClicked});

  @override
  Widget build(BuildContext context) {
    // Calculate minimum and maximum x values from the games array
    final double minX = games.first.toDouble(); // Convert to double
    final double maxX = games.last.toDouble(); // Convert to double

    // Filter the spots to only include data corresponding to valid games
    List<Map<String, dynamic>> filteredAvgSpots = [];
    List<Map<String, dynamic>> filteredTeamSpots = [];

    for (int i = 0; i < games.length; i++) {
      int game = games[i];
      if (i < avgSpots.length && i < teamSpots.length) {
        // Check if both avgSpots and teamSpots are valid numbers before adding them
        if (avgSpots[i].isFinite && teamSpots[i].isFinite) {
          filteredAvgSpots.add({'game': game, 'spot': avgSpots[i]});
          filteredTeamSpots.add({'game': game, 'spot': teamSpots[i]});
        }
      }
    }

    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        minimum: minX,
        maximum: maxX,
        interval: (smallestDifference(games) ?? 1)
            as double, // Show each integer as a label
        labelFormat: '{value}', // Show integer format
        majorGridLines:
            const MajorGridLines(width: 0), // Optional: hide grid lines
      ),
      primaryYAxis: NumericAxis(
        labelFormat:
            '{value}', // Optionally show integer values only on the y-axis if needed
        majorGridLines: const MajorGridLines(width: 0),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '', // Hide the header if not needed
        canShowMarker: false, // Disable the marker in the tooltip
        tooltipPosition:
            TooltipPosition.pointer, // Display tooltip pointer at cursor
      ),
      series: <ChartSeries>[
        LineSeries<Map<String, dynamic>, double>(
          dataSource: filteredAvgSpots,
          xValueMapper: (data, index) {
            return data['game'].toDouble(); // Use the game as the x value
          },
          yValueMapper: (data, index) => data['spot'],
          color: Colors.blue, width: 10,
          markerSettings:
              const MarkerSettings(isVisible: false), // No dots for avgSpots
        ),
        LineSeries<Map<String, dynamic>, double>(
          dataSource: filteredTeamSpots,
          xValueMapper: (data, index) {
            return data['game'].toDouble(); // Use the game as the x value
          },
          yValueMapper: (data, index) => data['spot'],
          color: Colors.red,
          width: 10,
          onPointDoubleTap: onPointDoubleClicked,
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            width: 10,
            height: 10,
            borderColor: Colors.white,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  int? smallestDifference(List<int> nums) {
    if (nums.length < 2) {
      return null; // Not enough numbers to calculate a difference
    }

    nums.sort();
    int minDiff = nums[1] - nums[0];

    for (int i = 1; i < nums.length - 1; i++) {
      int diff = nums[i + 1] - nums[i];
      if (diff < minDiff) {
        minDiff = diff;
      }
    }

    return minDiff;
  }
}
