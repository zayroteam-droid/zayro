import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  // CONTACT DETAILS
  static const String email = "zayro.team@gmail.com";
  static const String phone = "07401210633";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// HEADER
            const Text(
              "Need help? We’re here for you",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// WHATSAPP
            supportButton(
              icon: Icons.chat,
              label: "WhatsApp",
              onTap: () {
                openWhatsApp();
              },
            ),

            /// CALL
            supportButton(
              icon: Icons.call,
              label: "Call Us",
              onTap: () {
                makeCall();
              },
            ),

            /// EMAIL
            supportButton(
              icon: Icons.email,
              label: "Email Us",
              onTap: () {
                sendEmail();
              },
            ),

            /// LIVE CHAT (Coming soon)
            supportButton(
              icon: Icons.support_agent,
              label: "Live Chat (Coming Soon)",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Live chat coming soon"),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            /// HELP TOPICS
            const Text(
              "Help Topics",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            helpItem("Booking help"),
            helpItem("Payment issues"),
            helpItem("Tracking orders"),
            helpItem("Cancel / refund"),

            const Spacer(),

            /// FOOTER
            const Divider(),

            const Text(
              "Working hours: 9:00 AM – 5:00 PM\n"
              "Response time: Usually within 30 minutes",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // =======================
  // BUTTON UI
  // =======================
  Widget supportButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget helpItem(String text) {
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  // =======================
  // ACTIONS
  // =======================
  void openWhatsApp() async {
    final uri = Uri.parse("https://wa.me/44$phone");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void makeCall() async {
    final uri = Uri.parse("tel:$phone");
    await launchUrl(uri);
  }

  void sendEmail() async {
    final uri = Uri.parse("mailto:$email");
    await launchUrl(uri);
  }
}
