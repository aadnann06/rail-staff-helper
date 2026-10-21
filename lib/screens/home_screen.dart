import 'package:flutter/material.dart';
import 'employee_profile_screen.dart';
import 'monthly_duty_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color(0xFF0B3D62);
  static const Color textColor = Color(0xFF12385B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.train, size: 30),
            SizedBox(width: 12),
            Text(
              'Rail Staff Helper',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 18,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeCard(context),
                      const SizedBox(height: 22),

                      _buildFeatureGrid(context, isDesktop),
                      const SizedBox(height: 28),

                      const Text(
                        'Select Your Staff Category',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: 55,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 18),

                      _buildStaffCategories(isDesktop),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEAF4FF),
            Color(0xFFF5F9FF),
          ],
        ),
        border: Border.all(
          color: Color(0xFFD6E7F8),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 500;

          return Row(
            children: [
              Container(
                width: compact ? 70 : 90,
                height: compact ? 70 : 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD2E6FA),
                ),
                child: Icon(
                  Icons.person,
                  size: compact ? 42 : 55,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back,',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF456987),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Railway Employee',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: const [
                        Icon(
                          Icons.badge_outlined,
                          size: 19,
                          color: Color(0xFF456987),
                        ),
                        SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            'Employee Profile',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF456987),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                size: 32,
                color: primaryColor,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, bool isDesktop) {
    final cards = [
      _FeatureData(
        title: 'My Profile',
        subtitle: 'View & manage your profile',
        icon: Icons.person,
        iconColor: Colors.blue,
        backgroundColor: Color(0xFFF1F7FF),
   onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const EmployeeProfileScreen(),
    ),
  );
},
      ),
      _FeatureData(
        title: 'New Duty',
        subtitle: 'Add new duty entry',
        icon: Icons.train,
        iconColor: Colors.green,
        backgroundColor: Color(0xFFF0FAF5),
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const MonthlyDutyScreen(),
    ),
  );
},
      ),
      _FeatureData(
        title: 'TA / DA',
        subtitle: 'Calculate TA / DA',
        icon: Icons.currency_rupee,
        iconColor: Colors.orange,
        backgroundColor: Color(0xFFFFFAEF),
        onTap: () {},
      ),
      _FeatureData(
        title: 'PDF Reports',
        subtitle: 'Generate & view reports',
        icon: Icons.description,
        iconColor: Colors.deepPurple,
        backgroundColor: Color(0xFFF6F2FF),
        onTap: () {},
      ),
      _FeatureData(
        title: 'Duty History',
        subtitle: 'View past duty records',
        icon: Icons.history,
        iconColor: Colors.teal,
        backgroundColor: Color(0xFFF0FBFC),
        onTap: () {},
      ),
    ];

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (context, index) {
          return _buildFeatureCard(cards[index]);
        },
      );
    }

    return Column(
      children: cards
          .map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildFeatureCard(card),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFeatureCard(_FeatureData data) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: data.onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: data.backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: data.iconColor.withAlpha(35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: data.iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF52718D),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCategories(bool isDesktop) {
    final categories = [
      _StaffCategory('RPF', Icons.shield_outlined),
      _StaffCategory('Loco Pilot', Icons.train),
      _StaffCategory('ALP', Icons.person),
      _StaffCategory('Guard', Icons.person_pin),
      _StaffCategory('TC / TTE', Icons.confirmation_number_outlined),
      _StaffCategory('Other Staff', Icons.groups),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isDesktop ? 3.2 : 2.2,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFD6E2EE),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  color: primaryColor,
                  size: 27,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: 0,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
        NavigationDestination(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      onDestinationSelected: (index) {},
    );
  }
}

class _FeatureData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap,
  });
}

class _StaffCategory {
  final String title;
  final IconData icon;

  const _StaffCategory(this.title, this.icon);
}