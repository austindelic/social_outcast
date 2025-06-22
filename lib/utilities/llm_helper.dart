import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HackClubAIHelper {
  static const String apiUrl = 'https://ai.hackclub.com/chat/completions';

  static Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load response');
    }
  }
}

class GeminiHelper {
  static String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  static String apiKey = dotenv.env['GEMINI_API']!;

  static Future<String> generateQuestions() async {
    final prompt =
        '''Purpose: The American User is traveling to Japan. The user wants to avoid being a bad manner and being an annoying tourist.
Task: Generate a JSON list of 4-option 6 questions in a concrete situation x all 10 situations, 4 options, and the answer.''';
    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {
          "responseMimeType": "application/json",
          "responseSchema": {
            "type": "object",
            "properties": {
              "questions": {
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "question_sentence": {"type": "string"},
                    "category": {
                      "type": "string",
                      "enum": [
                        "Arrival & First Impressions",
                        "Hotel & Accommodation Behavior",
                        "Dining Etiquette",
                        "Personal Space & Behavior in Public",
                        "Time & Punctuality",
                        "Shopping Etiquette",
                        "Laws, Rules & “Unspoken” Norms",
                        "Transport Etiquette",
                        "Technology Use & Communication",
                        "Cultural & Religious Sensitivities",
                      ],
                    },
                    "option1": {"type": "string"},
                    "option2": {"type": "string"},
                    "option3": {"type": "string"},
                    "option4": {"type": "string"},
                    "answer": {
                      "type": "string",
                      "enum": ["1", "2", "3", "4"],
                    },
                  },
                  "required": [
                    "question_sentence",
                    "category",
                    "option1",
                    "option2",
                    "option3",
                    "option4",
                    "answer",
                  ],
                },
              },
            },
            "required": ["questions"],
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      return response.body; // Return the raw response body
    } else {
      throw Exception('Failed to load response');
    }
  }

  static Future<String> generateLessons(String genreListText, String level, String purpose, String fromCountry, String toCountry) async {
    final prompt = '''
        Pick 6 genres based on user's preference from the list: $genreListText \n Level: $level \n From: $fromCountry \n To: $toCountry \n purpose: $purpose. 
''';
    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {
          "responseMimeType": "application/json",
          "responseSchema": {
            "type": "array",
            "items": {"type": "string"},
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      return response.body; // Return the raw response body
    } else {
      throw Exception('response error: ${response.body}');
    }
  }
}

class GroqHelper
{
  static String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  static String apiKey = dotenv.env['GEMINI_API']!;
  static Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {
          "responseMimeType": "application/json",
          "responseSchema": {
            "type": "object",
            "properties": {
              "response": {"type": "string"},
            },
            "required": ["response"],
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      return response.body; // Return the raw response body
    } else {
      throw Exception('response error: ${response.body}');
    }
  }
}
