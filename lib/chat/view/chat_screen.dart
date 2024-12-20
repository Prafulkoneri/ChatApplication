import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _chatId {
    return widget.currentUserId.hashCode <= widget.otherUserId.hashCode
        ? '${widget.currentUserId}_${widget.otherUserId}'
        : '${widget.otherUserId}_${widget.currentUserId}';
  }

  Future<void> _sendMessage({String? message, File? file, String? type}) async {
    if ((message == null || message.isEmpty) && file == null) return;

    String? fileUrl;

    try {
      if (file != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        String filePath = 'chats/$_chatId/$fileName';
        final reference = _storage.ref(filePath);

        print('Uploading file to: $filePath'); 

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
          .doc(_chatId)
          .collection('messages')
          .add({
        'senderId': widget.currentUserId,
        'receiverId': widget.otherUserId,
        'message': message ?? '',
        'fileUrl': fileUrl ?? '',
        'type': type ?? 'text',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(_chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
                    bool isMe = message['senderId'] == widget.currentUserId;

                    return ListTile(
                      title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: message['type'] == 'text'
                              ? Text(
                                  message['message'] ?? '',
                                  style: TextStyle(
                                      color:
                                          isMe ? Colors.white : Colors.black),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    // Handle image/document preview
                                  },
                                  child: message['type'] == 'photo'
                                      ? Image.network(
                                          message['fileUrl'] ?? '',
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image),
                                        )
                                      : Icon(Icons.file_present),
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () =>
                      _sendMessage(message: _messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
