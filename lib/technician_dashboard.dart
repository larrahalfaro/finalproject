import 'package:flutter/material.dart';
import '../login_page.dart';

// --- Data Model for Repair Job (No Changes) ---
enum JobStatus { newRequest, accepted, inProgress, completed }

class Job {
  final String id;
  final String gadget;
  final String issue;
  final String userLocation;
  JobStatus status;
  final String userName;

  Job({
    required this.id,
    required this.gadget,
    required this.issue,
    required this.userLocation,
    required this.status,
    required this.userName,
  });
}

// --- NEW: App Theme Constants ---
// We define our colors and styles here for consistency.
class AppTheme {
  // Main Colors
  static const Color kPrimaryColor = Color(0xFF0D47A1); // A strong, professional blue
  static const Color kBackgroundColor = Color(0xFFF7F9FC); // A very light grey/blue
  static const Color kSurfaceColor = Color(0xFFFFFFFF); // White for cards

  // Text Colors
  static const Color kTextPrimary = Color(0xFF2D3748);
  static const Color kTextSecondary = Color(0xFF718096);

  // Status Colors
  static const Color kStatusNew = Color(0xFFD32F2F); // Red
  static const Color kStatusAccepted = Color(0xFFF57C00); // Orange
  static const Color kStatusInProgress = Color(0xFF1976D2); // Blue
  static const Color kStatusCompleted = Color(0xFF388E3C); // Green

  // Common Styles
  static const double kCardRadius = 16.0;
  static const double kPagePadding = 20.0;
  static final BoxShadow kCardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.06),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}

// --- Dynamic Jobs List Page (UI Re-skinned) ---
class JobsListPage extends StatefulWidget {
  const JobsListPage({super.key});

  @override
  State<JobsListPage> createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  // --- All Logic Below is UNCHANGED ---
  final List<Job> _jobs = [
    Job(
      id: 'J001',
      gadget: 'Smartphone (EcoModel X)',
      issue: 'Battery draining quickly. Needs replacement or recalibration.',
      userLocation: '123 Pine St, City Center',
      status: JobStatus.newRequest,
      userName: 'Alice Johnson',
    ),
    Job(
      id: 'J002',
      gadget: 'Laptop (Recycled Aluminum)',
      issue: 'Screen hinge is broken and needs repairing.',
      userLocation: '456 Oak Ave, Industrial Park',
      status: JobStatus.accepted,
      userName: 'Bob Williams',
    ),
    Job(
      id: 'J003',
      gadget: 'Smartwatch (Solar Powered)',
      issue: 'Watch face is unresponsive after update.',
      userLocation: '789 Elm Dr, Residential Area',
      status: JobStatus.completed,
      userName: 'Carol Davis',
    ),
  ];

  void _updateJobStatus(String jobId, JobStatus newStatus) {
    setState(() {
      final jobIndex = _jobs.indexWhere((job) => job.id == jobId);
      if (jobIndex != -1) {
        _jobs[jobIndex].status = newStatus;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Job ${_jobs[jobIndex].id} status updated to $newStatus.'),
                ),
              ],
            ),
            backgroundColor: AppTheme.kStatusCompleted,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });
  }
  // --- All Logic Above is UNCHANGED ---


  // --- Helper methods (UI Updated) ---
  Color _getStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.newRequest:
        return AppTheme.kStatusNew;
      case JobStatus.accepted:
        return AppTheme.kStatusAccepted;
      case JobStatus.inProgress:
        return AppTheme.kStatusInProgress;
      case JobStatus.completed:
        return AppTheme.kStatusCompleted;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(JobStatus status) {
    switch (status) {
      case JobStatus.newRequest:
        return Icons.fiber_new_rounded;
      case JobStatus.accepted:
        return Icons.thumb_up_alt_rounded;
      case JobStatus.inProgress:
        return Icons.handyman_rounded;
      case JobStatus.completed:
        return Icons.check_circle_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _getStatusText(JobStatus status) {
    switch (status) {
      case JobStatus.newRequest:
        return 'New Request';
      case JobStatus.accepted:
        return 'Accepted';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
      default:
        return 'Unknown';
    }
  }


  @override
  Widget build(BuildContext context) {
    // Logic is unchanged
    final activeJobs = _jobs.where((job) => job.status != JobStatus.completed).toList();

    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: const Text('New & Active Jobs'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.kTextPrimary,
          fontSize: 20,
        ),
        backgroundColor: AppTheme.kSurfaceColor,
        foregroundColor: AppTheme.kTextPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: activeJobs.isEmpty
          ? Center(
        // Empty state UI is slightly tweaked for a cleaner look
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.kStatusCompleted.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.assignment_turned_in_outlined,
                  size: 60, color: AppTheme.kStatusCompleted),
            ),
            const SizedBox(height: 24),
            const Text(
              'No active jobs!',
              style: const TextStyle( // <--- ⭐️ FIX 1: 'const' is here
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.kTextPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a break, you\'ve earned it.',
              style: const TextStyle(fontSize: 16, color: AppTheme.kTextSecondary), // <--- ⭐️ FIX 2: 'const' is here
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(AppTheme.kPagePadding - 8), // 12
        itemCount: activeJobs.length,
        itemBuilder: (context, index) {
          final job = activeJobs[index];
          return _buildJobCard(job); // Extracted card to a helper method
        },
      ),
    );
  }

  // --- UPDATED: Extracted Job Card Widget ---
  Widget _buildJobCard(Job job) {
    final statusColor = _getStatusColor(job.status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0, // We use shadow from the container
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.kSurfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
          boxShadow: [AppTheme.kCardShadow],
          // Add a subtle border matching the status color
          border: Border(
            left: BorderSide(color: statusColor, width: 6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Job ID
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Job #${job.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.kPrimaryColor,
                      ),
                    ),
                  ),
                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getStatusIcon(job.status), size: 14, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          _getStatusText(job.status),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 0.5),
              // Replaced _buildDetailRow with a cleaner, in-line widget
              _InfoRow(
                icon: Icons.person_outline_rounded,
                label: 'Customer',
                value: job.userName,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.devices_other_rounded,
                label: 'Gadget',
                value: job.gadget,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: job.userLocation,
                isAddress: true,
              ),
              const SizedBox(height: 16),
              // Issue Description Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.kBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Issue Description:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.kTextSecondary,
                          fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      job.issue,
                      style: const TextStyle(fontSize: 14, color: AppTheme.kTextPrimary),
                    ),
                  ],
                ),
              ),
              // --- ⭐️ ACTION BUTTONS (LOGIC UPDATED) ⭐️ ---

              // 1. Show "Accept Job" button if status is newRequest
              if (job.status == JobStatus.newRequest)
                _buildActionButton(
                  text: 'Accept Job',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppTheme.kStatusAccepted, // <-- Changed to Orange
                  onPressed: () => _updateJobStatus(job.id, JobStatus.accepted),
                ),

              // 2. Show "Start Travel" button if status is accepted
              if (job.status == JobStatus.accepted)
                _buildActionButton(
                  text: 'Start Travel / Mark In Progress',
                  icon: Icons.play_circle_outline_rounded,
                  color: AppTheme.kStatusInProgress, // <-- Stays Blue
                  onPressed: () => _updateJobStatus(job.id, JobStatus.inProgress),
                ),

              // 3. ⭐️ NEW ⭐️ Show "Mark as Completed" button if status is inProgress
              if (job.status == JobStatus.inProgress)
                _buildActionButton(
                  text: 'Mark as Completed',
                  icon: Icons.done_all_rounded,
                  color: AppTheme.kStatusCompleted, // <-- This is Green
                  onPressed: () => _updateJobStatus(job.id, JobStatus.completed),
                ),

            ],
          ),
        ),
      ),
    );
  }

  // --- Helper for Action Buttons in Card (NO CHANGE) ---
  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
// --- NEW: Cleaner Widget for Detail Rows ---
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isAddress;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: AppTheme.kTextSecondary),
        const SizedBox(width: 12),
        // Removed the "Label:" text to make it cleaner
        Expanded(
          child: Text.rich(
            TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.kTextSecondary,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                        color: AppTheme.kTextPrimary,
                        fontWeight: FontWeight.w500),
                  )
                ]
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: isAddress ? 3 : 1,
          ),
        ),
      ],
    );
  }
}


// --- Technician Profile Page (UI Re-skinned) ---
class TechnicianProfilePage extends StatelessWidget {
  const TechnicianProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile & Earnings'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.kTextPrimary,
          fontSize: 20,
        ),
        backgroundColor: AppTheme.kSurfaceColor,
        foregroundColor: AppTheme.kTextPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.kPagePadding),
        child: Column(
          children: [
            // --- NEW: Profile Header Card ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.kSurfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
                boxShadow: [AppTheme.kCardShadow],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.kPrimaryColor,
                    child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Technician Name', // Placeholder
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.kStatusCompleted.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star_rounded,
                                color: AppTheme.kStatusCompleted, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '4.8 Star Rating', // Placeholder
                              style: TextStyle(
                                color: AppTheme.kStatusCompleted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- NEW: Placeholder ListTiles ---
            _buildProfileSection(
              title: 'Account',
              children: [
                _buildProfileListTile(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Earnings & Payouts',
                  onTap: () {},
                ),
                _buildProfileListTile(
                  icon: Icons.star_border_rounded,
                  title: 'My Ratings',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildProfileSection(
              title: 'Vehicle & Tools',
              children: [
                _buildProfileListTile(
                  icon: Icons.directions_car_rounded,
                  title: 'Vehicle Details',
                  onTap: () {},
                ),
                _buildProfileListTile(
                  icon: Icons.inventory_2_rounded,
                  title: 'My Inventory',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- NEW: Helper for Profile Page Sections ---
  Widget _buildProfileSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.kTextSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.kSurfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
            boxShadow: [AppTheme.kCardShadow],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // --- NEW: Helper for Profile Page ListTiles ---
  Widget _buildProfileListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.kPrimaryColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.kTextPrimary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.kTextSecondary),
    );
  }
}


// --- Technician Dashboard (Main Shell - UI Re-skinned) ---
class TechnicianDashboard extends StatefulWidget {
  const TechnicianDashboard({super.key});

  @override
  State<TechnicianDashboard> createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
  // --- All Logic Below is UNCHANGED ---
  int _selectedIndex = 0;
  bool _isOnline = false;

  static final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(),
    const JobsListPage(),
    const TechnicianProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleOnlineStatus(bool newValue) {
    setState(() {
      _isOnline = newValue;
      String status = _isOnline ? 'Online' : 'Offline';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Status set to $status. Location tracking is ${_isOnline ? "Active" : "Paused"}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor:
          _isOnline ? AppTheme.kStatusCompleted : Colors.grey.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    });
  }
  // --- All Logic Above is UNCHANGED ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: const Text('Technician Panel'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.kTextPrimary,
          fontSize: 20,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.kSurfaceColor,
        foregroundColor: AppTheme.kTextPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
        actions: [
          // --- NEW: Online/Offline Toggle Chip ---
          // This is a much cleaner way to combine the status text and switch
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _toggleOnlineStatus(!_isOnline),
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
                decoration: BoxDecoration(
                  color: _isOnline
                      ? AppTheme.kStatusCompleted.withOpacity(0.1)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: _isOnline ? AppTheme.kStatusCompleted : Colors.grey.shade500,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isOnline ? AppTheme.kStatusCompleted : Colors.grey)
                                .withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Icon(Icons.power_settings_new_rounded,
                          color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isOnline ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        color: _isOnline
                            ? AppTheme.kStatusCompleted
                            : AppTheme.kTextSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.kTextSecondary),
            tooltip: 'Sign Out',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Signed out successfully'),
                  backgroundColor: Colors.grey.shade700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      // --- NEW: Modern Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.kSurfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                activeIcon: Icon(Icons.list_alt_rounded),
                label: 'Jobs'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile'),
          ],

          currentIndex: _selectedIndex,
          onTap: _onItemTapped, // Logic unchanged
          // New Styles
          backgroundColor: AppTheme.kSurfaceColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedItemColor: AppTheme.kPrimaryColor,
          unselectedItemColor: AppTheme.kTextSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ),
    );
  }
}

// --- Home Dashboard Content (UI Re-skinned) ---
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  // --- NEW: Re-skinned Metric Card ---
  Widget _buildMetricCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Color color,
      }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.kSurfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
        boxShadow: [AppTheme.kCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.kTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: AppTheme.kTextSecondary),
          ),
        ],
      ),
    );
  }

  // --- NEW: Re-skinned Action Button ---
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.kSurfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
          boxShadow: [AppTheme.kCardShadow],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: AppTheme.kPrimaryColor),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.kTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.kPagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Today\'s Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.kTextPrimary),
          ),
          const SizedBox(height: 16),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1, // Adjusted for new card style
            children: <Widget>[
              _buildMetricCard(
                context,
                title: 'Jobs Completed',
                value: '3',
                icon: Icons.check_circle_outline_rounded,
                color: AppTheme.kStatusCompleted,
              ),
              _buildMetricCard(
                context,
                title: 'New Requests',
                value: '1',
                icon: Icons.add_alert_rounded,
                color: AppTheme.kStatusAccepted,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Technician Tools',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.kTextPrimary),
          ),
          const SizedBox(height: 16),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1, // Made them square
            children: <Widget>[
              // Logic is unchanged, just passing context now
              _buildActionButton(
                context: context,
                icon: Icons.gps_fixed_rounded,
                label: 'Update Live Location',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Location updated and shared with General Users.'),
                    backgroundColor: AppTheme.kStatusCompleted,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                ),
              ),
              _buildActionButton(
                context: context,
                icon: Icons.assignment_ind_rounded,
                label: 'View All Jobs',
                onTap: () => (context.findAncestorStateOfType<_TechnicianDashboardState>())
                    ?._onItemTapped(1),
              ),
              _buildActionButton(
                context: context,
                icon: Icons.done_all_rounded,
                label: 'Log Job Completion',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Navigating to Job Completion Form...'),
                    backgroundColor: AppTheme.kStatusInProgress,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                ),
              ),
              _buildActionButton(
                context: context,
                icon: Icons.inventory_2_rounded,
                label: 'Manage Inventory',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Opening spare parts inventory...'),
                    backgroundColor: AppTheme.kStatusAccepted,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}