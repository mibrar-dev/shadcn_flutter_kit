// ignore_for_file: duplicate_import, unnecessary_import
// Example: Dashboard Overview Page
// Uses: Card, Badge, Button, Text extensions, LinearProgressIndicator

import 'package:flutter/material.dart' hide Card;
import '../registry/components/layout/card/card.dart';
import '../registry/components/display/text/text.dart';
import '../registry/components/display/badge/badge.dart';
import '../registry/components/control/button/button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dashboard').semiBold(),
                          const Text('Welcome back, Jane.').muted().small(),
                        ],
                      ),
                    ),
                    PrimaryButton(
                      onPressed: () {},
                      child: const Text('New project'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats row — responsive
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stats = [
                      (label: 'Total projects', value: '24', change: '+3 this month'),
                      (label: 'Active users', value: '1,284', change: '+12% from last week'),
                      (label: 'Revenue', value: r'$48,200', change: '+8% from last month'),
                      (label: 'Open issues', value: '7', change: '-2 resolved today'),
                    ];
                    if (constraints.maxWidth > 600) {
                      return Row(
                        children: [
                          for (int i = 0; i < stats.length; i++) ...[
                            if (i > 0) const SizedBox(width: 16),
                            Expanded(child: _StatCard(stat: stats[i])),
                          ],
                        ],
                      );
                    }
                    return Column(
                      children: [
                        for (int i = 0; i < stats.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _StatCard(stat: stats[i]),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Recent projects table
                Card(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: const Text('Recent projects').semiBold()),
                          GhostButton(
                            onPressed: () {},
                            child: const Text('View all').small(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      for (final project in _sampleProjects) ...[
                        _ProjectRow(project: project),
                        if (project != _sampleProjects.last)
                          const Divider(height: 1),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _sampleProjects = [
    (name: 'Acme Website Redesign', status: 'active', progress: 0.72),
    (name: 'Mobile App v2.0', status: 'review', progress: 0.45),
    (name: 'API Integration', status: 'paused', progress: 0.30),
    (name: 'Marketing Campaign', status: 'completed', progress: 1.0),
  ];
}

class _StatCard extends StatelessWidget {
  final ({String label, String value, String change}) stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stat.label).muted().small(),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(stat.change).muted().small(),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final ({String name, String status, double progress}) project;

  const _ProjectRow({required this.project});

  @override
  Widget build(BuildContext context) {
    final Widget badge = switch (project.status) {
      'active' => const PrimaryBadge(child: Text('Active')),
      'review' => const SecondaryBadge(child: Text('In Review')),
      'paused' => const OutlineBadge(child: Text('Paused')),
      'completed' => const OutlineBadge(child: Text('Completed')),
      _ => OutlineBadge(child: Text(project.status)),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name).semiBold().small(),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: project.progress,
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          badge,
        ],
      ),
    );
  }
}
