import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ggt_assignment/widgets/customTextStyle.dart';
import 'package:ggt_assignment/toast.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  bool isEditing = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      _emailController.text = user!.email ?? '';
    }
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user!.email).get();
      if (doc.exists) {
        _ageController.text = doc['age'] ?? '';
        _genderController.text = doc['gender'] ?? '';
        _nationalityController.text = doc['nationality'] ?? '';
      }
    }
  }

  Future<void> _updateProfile() async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.email).set({
        'age': _ageController.text,
        'gender': _genderController.text,
        'nationality': _nationalityController.text,
      }, SetOptions(merge: true));

      showToast(message: 'Profile updated successfully.');
      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = getCustomTextStyle(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (isEditing)
                    Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          readOnly: true, // Email field is read-only
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _genderController,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _nationalityController,
                          decoration: InputDecoration(
                            labelText: 'Nationality',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateProfile,
                          child: Text('Save'),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${_emailController.text}', style: textStyle),
                        SizedBox(height: 10),
                        Text('Age: ${_ageController.text}', style: textStyle),
                        Text('Gender: ${_genderController.text}', style: textStyle),
                        Text('Nationality: ${_nationalityController.text}', style: textStyle),
                      ],
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
