import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 👤 ACCOUNT
            _sectionTitle('Account'),
            _settingsCard(
              children: [
                _settingsTile(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {},
                ),
                _divider(),
                _settingsTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your password',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// ⚙️ PREFERENCES
            _sectionTitle('Preferences'),
            _settingsCard(
              children: [
                _settingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Manage notification settings',
                  onTap: () {},
                ),
                _divider(),
                _settingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Switch app appearance',
                  trailing: Switch(value: false, onChanged: (_) {}),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// 📄 SUPPORT
            _sectionTitle('Support'),
            _settingsCard(
              children: [
                _settingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _divider(),
                _settingsTile(
                  icon: Icons.info_outline,
                  title: 'About App',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// 🚨 LOGOUT
            _settingsCard(
              children: [
                _settingsTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  titleColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    // FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 SECTION TITLE
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // 🔹 CARD CONTAINER
  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(children: children),
    );
  }

  // 🔹 TILE
  Widget _settingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color iconColor = Colors.blue,
    Color titleColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // 🔹 DIVIDER
  Widget _divider() {
    return const Divider(height: 1, indent: 60);
  }
}
