import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_register_page.dart';
import '../auth.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> showLogoutDialog() async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await signOut();
            },
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  Widget infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 55)),

            const SizedBox(height: 18),

            Text(
              user?.email ?? "Guest User",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "Welcome back 👋",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            infoTile(
              icon: Icons.email_outlined,
              title: "Email",
              subtitle: user?.email ?? "Unknown",
            ),

            infoTile(
              icon: Icons.fingerprint,
              title: "User ID",
              subtitle: user?.uid ?? "",
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: user?.uid ?? ""));

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("UID copied")));
                },
              ),
            ),

            infoTile(
              icon: Icons.info_outline,
              title: "App Version",
              subtitle: "1.0.0",
            ),

            infoTile(
              icon: Icons.flutter_dash,
              title: "Built With",
              subtitle: "Flutter + Firebase",
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.logout),
                label: const Text("Sign Out", style: TextStyle(fontSize: 16)),
                onPressed: showLogoutDialog,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
