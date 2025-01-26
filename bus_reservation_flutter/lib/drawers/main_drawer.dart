import 'package:bus_reservation/utils/constants.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Header image container with decoration
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://www.allrideapps.com/wp-content/uploads/2020/07/fc5b11fb-b135-4537-96ae-c3872b2164cb.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Text(
              'Bus Reservation',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
          // Drawer items with styles
          _buildDrawerItem(
            context,
            icon: Icons.bus_alert,
            text: 'Add Bus',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameAddBusPage);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.route,
            text: 'Add Route',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameAddRoutePage);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.schedule,
            text: 'Add Schedule',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameAddSchedulePage);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.book_online,
            text: 'View Reservations',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameReservationPage);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.login_outlined,
            text: 'Admin Login',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameLoginPage);
            },
          ),
        ],
      ),
    );
  }

  // Helper method to create a styled drawer item
  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Icon(
        icon,
        color: Colors.blueGrey, // Custom icon color
        size: 28,
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87, // Text color
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      tileColor: Colors.grey[100], // Background color of each tile
      hoverColor: Colors.blueGrey[50], // Hover color when tile is focused
      onTap: onTap,
    );
  }
}
