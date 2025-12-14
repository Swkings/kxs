import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/services/cluster_service_provider.dart';
import 'package:kxs/features/resources/controllers/namespaces_controller.dart';
import 'package:kxs/l10n/app_localizations.dart';

class OverviewView extends ConsumerStatefulWidget {
  const OverviewView({super.key});

  @override
  ConsumerState<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends ConsumerState<OverviewView> {
  int _nodeCount = 0;
  int _namespaceCount = 0;
  int _podCount = 0;
  int _serviceCount = 0;
  int _deploymentCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(clusterServiceProvider);
      // Fetch all nodes
      final nodes = await service.getNodes();
      
      // Fetch all namespaces
      final namespaces = await service.getNamespaces();
      
      // Fetch resources for current namespace (or all if we want rigorous stats, but let's stick to current context/namespace or just default)
      // Actually "Cluster Overview" usually implies cluster-wide or current context.
      // Let's just fetch for the currently selected namespace for Pods/Services/Deployments to avoid massive overhead
      final currentNs = ref.read(selectedNamespaceProvider);
      
      final pods = await service.getPods(currentNs);
      final services = await service.getServices(currentNs);
      final deployments = await service.getDeployments(currentNs);

      if (mounted) {
        setState(() {
          _nodeCount = nodes.length;
          _namespaceCount = namespaces.length;
          _podCount = pods.length;
          _serviceCount = services.length;
          _deploymentCount = deployments.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Show error?
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
             AppLocalizations.of(context)!.dashboardClusterOverview,
             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 32),
           Wrap(
             spacing: 16,
             runSpacing: 16,
             children: [
               _buildStatCard('Nodes', _nodeCount.toString(), Icons.computer),
               _buildStatCard('Namespaces', _namespaceCount.toString(), Icons.folder_open),
               _buildStatCard('Pods', _podCount.toString(), Icons.apps),
               _buildStatCard('Services', _serviceCount.toString(), Icons.dns),
               _buildStatCard('Deployments', _deploymentCount.toString(), Icons.layers),
             ],
           ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
              Icon(icon, color: Colors.blue, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
