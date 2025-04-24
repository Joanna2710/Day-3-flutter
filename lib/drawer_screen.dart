import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'login_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Wrap the Column in a SingleChildScrollView to make it scrollable
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/images/img17.jpg'),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Joanna Elia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${taskProvider.pendingTaskCount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Task left'),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${taskProvider.completedTaskCount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Task done'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const DrawerItem(
                  icon: Icons.settings,
                  title: 'App Settings',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const DrawerItem(
                  icon: Icons.person,
                  title: 'Change account name',
                ),
                const DrawerItem(
                  icon: Icons.lock,
                  title: 'Change account password',
                ),
                const DrawerItem(
                  icon: Icons.image,
                  title: 'Change account Image',
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Change Mode'),
                  trailing: Switch(
                    value: true,
                    activeColor: const Color(0xFF8875FF),
                    onChanged: (value) {
                      // Implement theme switching
                    },
                  ),
                ),
                // Remove the Spacer which was causing issues
                // const Spacer(),
                const SizedBox(height: 20),
                const DrawerItem(
                  icon: Icons.info,
                  title: 'About US',
                ),
                const DrawerItem(
                  icon: Icons.help,
                  title: 'Help & Feedback',
                ),
                const DrawerItem(
                  icon: Icons.support,
                  title: 'Support US',
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                // Add some bottom padding to ensure the last item is visible
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
