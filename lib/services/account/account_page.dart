import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'bookings_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary user data
    const String userName = "Zayro Team";
    const String userEmail = "zayro.team@gmail.com";
    const String userPhone = "07401210633";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: ZayroColors.zayroBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile info
            CircleAvatar(
              radius: 50,
              backgroundColor: ZayroColors.zayroBlue,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(userName,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(userPhone, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Text(userEmail, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            // Profile actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ZayroColors.zayroBlue),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock),
                    label: const Text("Change Password"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ZayroColors.zayroBlue),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Feature List
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text("My Bookings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Saved Addresses"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Payment Methods"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications Settings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            const Divider(height: 40, thickness: 1),

            // Help & Policies
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help & Support"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Terms & Conditions"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // Logout
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement logout
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(200, 45)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
