
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ChatbotService{
 
  static Future<String> getChatbotResponse(String userMessage) async {
    try {
      final response = await http.put(
        Uri.parse('http://38.128.233.67:5555/generate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'sentences': [userMessage],
          
          //length of response 
          'tokens_to_generate': 300,
          'temperature': 1.0,
          'add_BOS': true,
          'top_k': 0,
          'top_p': 0.9,
          'greedy': false,
          'all_probs': false,
          'repetition_penalty': 1.2,
          'min_tokens_to_generate': 2,
        }),
      );

      print("response $response");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Extract the 'sentences' field
        if (jsonResponse.containsKey('sentences')) {
          final List<dynamic> sentences = jsonResponse['sentences'];
          return sentences.isNotEmpty ? sentences[0] : 'No response from chatbot';
        } else {
          throw Exception('Sentences field not found in response');
        }
      } else {
        throw Exception('Failed to load chatbot response');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to connect to chatbot API');
    }
  }
}

