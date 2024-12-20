import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final String? fileUrl;
  final String type;
  final DateTime? timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.fileUrl,
    required this.type,
    this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'] ?? '',
      fileUrl: map['fileUrl'],
      type: map['type'] ?? 'text',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
