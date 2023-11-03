import 'package:chat_app_mobile/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //lấy thông tin người dùng hiện tại
    final String currenUserId = _firebaseAuth.currentUser!.uid;
    final String currenUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //tạo mói tin nhắn
    Message newMessage = new Message(
        receiverId: receiverId,
        timestamp: timestamp,
        senderEmail: currenUserEmail,
        senderId: currenUserId,
        message: message);
    //xây dựng id phòng trò chuyện từ id người dùng và id người nhận hiện tại
    List<String> ids = [currenUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    //thêm tin nhắn vào database
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
