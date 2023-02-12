import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                          Image(image: AssetImage('assets/profile_img.png'))),
                ),
                const SizedBox(height: 20),
                Text('Ankshika',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 70),
                ProfileMenuWidget(
                    title: "Edit Profile", icon: Icons.edit, onPress: () {}),
                const Divider(),
                ProfileMenuWidget(
                    title: "Language", icon: Icons.web, onPress: () {}),
                const Divider(),
               
                ProfileMenuWidget(
                    title: "FAQs", icon: Icons.question_mark, onPress: () {}),
                const Divider(),
                ProfileMenuWidget(
                    title: "Rate this App",
                    icon: Icons.star,
                    onPress: () {}),
                const Divider(),
                ProfileMenuWidget(
                    title: "Share this App",
                    icon: Icons.share,
                    onPress: () {}),
                const Divider(),
                ProfileMenuWidget(
                    title: "Log out",
                    icon: Icons.login_outlined,
                    onPress: () async{
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, '/firstscreen');
                    }),
                const Divider(),
              ],
            ),
          ),
        ),
    );
  }
}

      


class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                // color: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.black))
          : null,
    );
  }
}
