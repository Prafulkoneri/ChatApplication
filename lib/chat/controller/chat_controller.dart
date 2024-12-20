import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

   String? currentUserId;
   String? otherUserId;

  ChatController({ this.currentUserId,  this.otherUserId});

  TextEditingController messageController = TextEditingController();

  String get chatId {
    return currentUserId.hashCode <= otherUserId.hashCode
        ? '${currentUserId}_${otherUserId}'
        : '${otherUserId}_${currentUserId}';
  }

  Stream<QuerySnapshot> get messagesStream {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> initState(context) async {
    print("ChatController initialized for chatId: $chatId");
  }
  Future<void> sendMessage({String? message, File? file, String? type}) async {
    if ((message == null || message.isEmpty) && file == null) return;

    String? fileUrl;

    try {
      if (file != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        String filePath = 'chats/$chatId/$fileName';
        final reference = _storage.ref(filePath);
        UploadTask uploadTask = reference.putFile(file);
             TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        if (snapshot.state == TaskState.success) {
          fileUrl = await snapshot.ref.getDownloadURL();
        } else {
          throw FirebaseException(
            plugin: "firebase_storage",
            message: "File upload failed with state: ${snapshot.state}",
          );
        }
      }
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'receiverId': otherUserId,
        'message': message ?? '',
        'fileUrl': fileUrl ?? '',
        'type': type ?? 'text',
        'timestamp': FieldValue.serverTimestamp(),
      });

      messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
