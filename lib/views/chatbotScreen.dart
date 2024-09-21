import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navin_chatbot/services/chatbot_service.dart';
import 'package:lottie/lottie.dart';  // Import Lottie

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({
        'text': _controller.text,
        'isUser': true,
      });
      _isLoading = true; 
    });

    final userMessage = _controller.text;
    _controller.clear();

    try {
      final chatbotResponse = await ChatbotService.getChatbotResponse(userMessage);

      setState(() {
        messages.add({
          'text': chatbotResponse,
          'isUser': false,
        });
      });
    } catch (error) {
      setState(() {
        messages.add({
          'text': 'Erreur : Impossible de récupérer la réponse du chatbot.',
          'isUser': false,
        });
      });
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  Widget _buildMessage(String message, bool isUser) {
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          _buildAvatar(isUser),
          SizedBox(width: 8.0.w),
        ],
        Flexible(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 14.0.w),
                margin: EdgeInsets.symmetric(vertical: 5.0.h),
                decoration: BoxDecoration(
                  color: isUser ? Color(0XFF4EC1E0) : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomLeft: isUser ? Radius.circular(10.r) : Radius.circular(0),
                    bottomRight: isUser ? Radius.circular(0) : Radius.circular(10.r),
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 179, 179, 179).withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20.0.h),
            ],
          ),
        ),
        if (isUser) ...[
          SizedBox(width: 8.0.w),
          _buildAvatar(isUser),
        ],
      ],
    );
  }

  // Function to display the chatbot avatar and Lottie typing animation while waiting
  Widget _buildTypingIndicator() {
    double radius = 25.r;
    double circleAvatarRadius = radius - 5.0.r;
    double greenDotHeight = 10.h;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: radius,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: circleAvatarRadius,
                    backgroundColor: Colors.grey[300],
                    child: CircleAvatar(
                      radius: 18.0.r,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        "assets/images/chatavatar.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1.0.h,
                  right: 5.0.w,
                  child: Container(
                    width: greenDotHeight,
                    height: greenDotHeight,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0.h),
          ],
        ),
        const SizedBox(width: 8.0),
        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
          child: Lottie.asset(
            "assets/icons/typingDots.json", 
            width: 50, 
            height: 50, 
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(bool isUser) {
    double radius = 25.r;
    double circleAvatarRadius = radius - 5.0.r;
    double greenDotHeight = 10.h;

    if (!isUser) {
      return Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: radius,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: circleAvatarRadius,
                  backgroundColor: Colors.grey[300],
                  child: CircleAvatar(
                    radius: 18.0.r,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      "assets/images/chatavatar.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 1.0.h,
                right: 5.0.w,
                child: Container(
                  width: greenDotHeight,
                  height: greenDotHeight,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0.h),
        ],
      );
    } else {
      return Column(
        children: [
          CircleAvatar(
            backgroundColor: Color(0XFF57D7CA),
            radius: radius,
            child: Image.asset("assets/images/avatar.jpg"),
          ),
          SizedBox(height: 20.0.h),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("NAVIN LLM"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0.r),
              itemCount: messages.length + (_isLoading ? 1 : 0),
              reverse: true,
              itemBuilder: (context, index) {
                if (_isLoading && index == 0) {
                  return _buildTypingIndicator();
                }

                final message = messages.reversed.toList()[_isLoading ? index - 1 : index];
                return _buildMessage(
                  message['text'],
                  message['isUser'],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 8.0.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Entrez un message...",
                        border: InputBorder.none,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        _sendMessage();
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0XFF4EC1E0), Color(0XFF57D7CA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/sendicon.svg",
                          width: 24.w,
                          height: 24.h,
                          placeholderBuilder: (context) => const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.0.h),
        ],
      ),
    );
  }
}
