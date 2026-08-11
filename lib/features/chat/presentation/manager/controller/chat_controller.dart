import 'package:cr_app/core/network/dio_client.dart';
import 'package:cr_app/core/utils/api_endpoint.dart';
import 'package:cr_app/features/chat/domain/entities/chat_message.dart';
import 'package:cr_app/injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool isLoading = false.obs;

  // Use the shared DioClient which contains the Auth token
  final DioClient _dioClient = sl<DioClient>();

  @override
  void onInit() {
    super.onInit();
    fetchChatHistory();
  }

  Future<void> fetchChatHistory() async {
    isLoading.value = true;
    try {
      final response = await _dioClient.get(ApiEndpoint.chatHistory);

      if (response.data != null && response.data is List) {
        final List<dynamic> data = response.data;
        messages.assignAll(data.map((json) {
          return ChatMessage(
            text: json['message'] as String? ?? '',
            isUser: json['isFromUser'] as bool? ?? false,
            time: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
          );
        }).toList());
      }
    } catch (e) {
      print("History Error: $e");
    } finally {
      // If no history, add welcome message
      if (messages.isEmpty) {
        messages.add(ChatMessage(
          text: "Hello! I am your CR Assistant AI. How can I help you today?",
          isUser: false,
          time: DateTime.now(),
        ));
      }
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    // Add user message locally
    messages.add(ChatMessage(
      text: text,
      isUser: true,
      time: DateTime.now(),
    ));
    textController.clear();
    _scrollToBottom();

    isLoading.value = true;

    try {
      // Use shared DioClient to send message to backend /api/chat/send
      final response = await _dioClient.post(
        ApiEndpoint.chatSend,
        data: {"message": text},
      );

      if (response.data != null) {
        // Extract fields safely
        final aiMessage = response.data['message'] as String? ?? '';
        final isFromUser = response.data['isFromUser'] as bool? ?? false;

        messages.add(ChatMessage(
          text: aiMessage,
          isUser: isFromUser,
          time: DateTime.now(),
        ));
      }
    } catch (e) {
      print("Chat Error: $e");
      messages.add(ChatMessage(
        text: "Sorry, I couldn't reach the server. Please try again.",
        isUser: false,
        time: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}