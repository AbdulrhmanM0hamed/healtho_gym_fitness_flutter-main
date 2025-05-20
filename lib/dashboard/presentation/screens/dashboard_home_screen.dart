import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/core/di/service_locator.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/screens/all_exercises_screen.dart';
import 'package:healtho_gym/dashboard/features/exercise/presentation/viewmodels/exercise_cubit.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/viewmodels/exercise_category_cubit.dart';
import 'package:healtho_gym/dashboard/features/health_tip/presentation/screens/health_tips_list_screen.dart';
import 'package:healtho_gym/dashboard/features/user/presentation/screens/users_list_screen.dart';
import 'package:healtho_gym/dashboard/features/exercise_category/presentation/screens/exercise_categories_screen.dart';
import 'package:healtho_gym/dashboard/presentation/widgets/dashboard_menu_item.dart';
import 'package:healtho_gym/dashboard/routes/dashboard_routes.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const Center(child: Text('Dashboard Overview')),
    const HealthTipsListScreen(),
    const UsersListScreen(),
    BlocProvider(
      create: (context) => sl<ExerciseCategoryCubit>()..loadCategories(),
      child: const ExerciseCategoriesScreen(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ExerciseCubit>()),
        BlocProvider(create: (context) => sl<ExerciseCategoryCubit>()),
      ],
      child: const AllExercisesScreen(),
    ),
    const Center(child: Text('Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        title: const Text(
          'Healtho Gym Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
     
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: TColor.secondary,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'admin@healthogym.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            DashboardMenuItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              isSelected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            DashboardMenuItem(
              icon: Icons.spa,
              title: 'Health Tips',
              isSelected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            DashboardMenuItem(
              icon: Icons.people,
              title: 'Users',
              isSelected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            DashboardMenuItem(
              icon: Icons.category,
              title: 'Exercise Categories',
              isSelected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            DashboardMenuItem(
              icon: Icons.fitness_center,
              title: 'All Exercises',
              isSelected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
            DashboardMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              isSelected: _selectedIndex == 5,
              onTap: () => _onItemTapped(5),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, DashboardRoutes.login);
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Side Navigation for larger screens
          if (MediaQuery.of(context).size.width >= 1200)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              extended: true,
              backgroundColor: Colors.white,
              selectedLabelTextStyle: TextStyle(
                color: TColor.secondary,
                fontWeight: FontWeight.bold,
              ),
              selectedIconTheme: IconThemeData(
                color: TColor.secondary,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.spa_outlined),
                  selectedIcon: Icon(Icons.spa),
                  label: Text('Health Tips'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('Users'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.category_outlined),
                  selectedIcon: Icon(Icons.category),
                  label: Text('Exercise Categories'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.fitness_center_outlined),
                  selectedIcon: Icon(Icons.fitness_center),
                  label: Text('All Exercises'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          // Main content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
} 