import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SubmitReviewScreen extends StatefulWidget {
  const SubmitReviewScreen({super.key});

  @override
  State<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final _commentController = TextEditingController();
  int _rating = 0;
  File? _imageFile;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _submitReview() async {
    if (_rating == 0 || _commentController.text.isEmpty) return;

    setState(() => _loading = true);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docId = const Uuid().v4();

    String? photoUrl;
    if (_imageFile != null) {
      final ref = FirebaseStorage.instance.ref('review_photos/$docId.jpg');
      await ref.putFile(_imageFile!);
      photoUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('reviews').doc(docId).set({
      'userId': userId,
      'rating': _rating,
      'comment': _commentController.text,
      'photoUrl': photoUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Write a Review")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Your Rating", style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return IconButton(
                  icon: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange[300],
                  ),
                  onPressed: () => setState(() => _rating = i + 1),
                );
              }),
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            _imageFile == null
                ? ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text("Add a Photo"),
                  )
                : Image.file(_imageFile!, height: 120),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Submit Review"),
            ),
          ],
        ),
      ),
    );
  }
}
