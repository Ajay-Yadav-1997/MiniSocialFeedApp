import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController bioCtrl;

  @override
  void initState() {
    nameCtrl = TextEditingController(text: widget.user.name);
    bioCtrl = TextEditingController(text: widget.user.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text('Edit Profile',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.user.photo ??
                      'https://i.pravatar.cc/150?img=3'), // default image
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),

            // Name Field
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Name',
                    hintText: 'Enter your name',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bio Field
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  controller: bioCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Bio',
                    hintText: 'Tell something about yourself',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  shadowColor: Colors.blue,
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user.uid)
                      .update({
                    'displayName': nameCtrl.text,
                    'bio': bioCtrl.text,
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
