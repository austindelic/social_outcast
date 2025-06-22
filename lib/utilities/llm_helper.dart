import 'dart:convert';
import 'package:culture_lessons/culture_lessons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_outcast/data/trip_data.dart';

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

  Future<List<Puzzle>> generateOptionsQuestions(int unitId) async {
    // Generate a prompt for the AI
    // The prompt is a string that describes what you want the AI to do
    // In this case, we want it to generate a JSON array of questions
    final genre = UnitData.unitData[unitId]!.title;
    final tripId = UnitData.unitData[unitId]!.tripId;
    final fromCountry = TripData.tripData[tripId]!.fromCountry;
    final toCountry = TripData.tripData[tripId]!.toCountry;

    final prompt =
        ''' "You are a friendly quizmaster AI. Generate a JSON array of 10 fun and educational multiple-choice questions about world cultures, traditions, or geography. Each question should be an object with the following fields: question (the question text), choices (an array of 4 possible answers), and answer (the correct answer, which must match one of the choices). Return only the JSON array, not a string or any extra commentary. Do not wrap the array in quotes or markdown. The output must be valid JSON and directly parsable. Example output:  [
    {
      "answer": "3",
      "category": "Dining Etiquette",
      "option1": "Leave a 15-20% cash tip on the table for the excellent service.",
      "option2": "Find your server and hand them a cash tip directly to show your appreciation.",
      "option3": "Do not leave a tip. Pay the exact amount on the bill at the front register.",
      "option4": "Ask the manager if you can add a tip to your credit card payment.",
      "question_sentence": "You've just finished a wonderful dinner at a restaurant in Kyoto and the service was impeccable. As an American used to tipping, what is the correct and respectful action to take?"
    },
    {
      "answer": "2",
      "category": "Dining Etiquette",
      "option1": "Stick them standing upright into the remaining rice in your bowl.",
      "option2": "Place them neatly together on the provided chopstick rest ('hashioki') or lay them across the top of your empty bowl.",
      "option3": "Cross them over your plate to signal you are finished with your meal.",
      "option4": "Use your chopsticks to point to the server to get their attention for the bill.",
      "question_sentence": "You are taking a break during a meal and need to put your chopsticks down. What is the one action you should absolutely AVOID doing as it is a major cultural taboo related to funeral rites?"
    },"

Purpose: The User who lives in $fromCountry is traveling to $toCountry. The user wants to avoid being a bad manner and being an annoying tourist.
Task: Generate a JSON list of 4-option 10 questions in a concrete situation=$genre ,4 options, and the answer.''';

    // { \"question\": \"In India, what is the name of the festival of colors?\", \"choices\": [\"Diwali\", \"Holi\", \"Navratri\", \"Ganesh Chaturthi\"], \"answer\": \"Holi\" } ]"
    final response = await getResponse(prompt);
    print('Response: $response');
    final List jsonResponse = jsonDecode(response);
    final List<Puzzle> questions = [];
    for (var question in jsonResponse) {
      final questionSentence = question['question'];
      final option1 = question['option1'];
      final option2 = question['option2'];
      final option3 = question['option3'];
      final option4 = question['option4'];
      final answer = int.parse(question['answer']);

      questions.add(
        Puzzle(
          id: DateTime.now().millisecondsSinceEpoch,
          unitId: unitId,
          prompt: questionSentence,
          type: PuzzleType.multipleChoice,
          options: [option1, option2, option3, option4],
          correctIndex: answer,
        ),
      );
    }
    return questions;
  }

  static Future<List<String>> generateLessons(
    String level,
    String purpose,
    String fromCountry,
    String toCountry,
  ) async {
    final genresText =
        "['Transportation', 'Hotel Behavior', 'Accent', 'Shopping Etiquette', 'Laws and Rules', 'Business Situation', 'Home Stay', 'Basic Language', 'Behavior on Street', 'Dining Etiquette', 'Technology Use and Communication', 'Cultural Sensitivities', 'Greetings and Introductions', 'Slang']";
    final prompt =
        '''
Make sure the response is only a JSON array of strings, each representing a genre, and no text else
      Pick 6 genres from the list: $genresText based on user's preference: \n Level: $level \n From: $fromCountry \n To: $toCountry \n purpose: $purpose. 
      Output example: ["Transportation", "Dining Etiquette", "Accent", "Shopping Etiquette", "Laws and Rules", "Technology Use and Communication"]
''';
    final response = await getResponse(prompt);
    print('Response: $response');
    final responseJson = jsonDecode(response);
    print(responseJson);
    return List<String>.from(responseJson);
  }
}

class GeminiHelper {
  static String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  static String apiKey = dotenv.env['GEMINI_API']!;

  static Future<String> generateOptionsQuestions(
    String fromCountry,
    String toCountry,
  ) async {
    final prompt =
        ''' "You are a friendly quizmaster AI. Generate a JSON array of 10 fun and educational multiple-choice questions about world cultures, traditions, or geography. Each question should be an object with the following fields: question_sentence (the question text), category, choices (an array of 4 possible answers), and answer (the correct answer, which must match one of the choices). Return only the JSON array, not a string or any extra commentary. Do not wrap the array in quotes or markdown. The output must be valid JSON and directly parsable. Example output: [ { \"question\": \"Which Japanese festival is known for its fireworks displays?\", \"choices\": [\"Hanami\", \"Obon\", \"Tanabata\", \"Setsubun\"], \"answer\": \"Tanabata\" }, { \"question\": \"In India, what is the name of the festival of colors?\", \"choices\": [\"Diwali\", \"Holi\", \"Navratri\", \"Ganesh Chaturthi\"], \"answer\": \"Holi\" } ]"
Purpose: The User who lives in $fromCountry is traveling to $toCountry. The user wants to avoid being a bad manner and being an annoying tourist.
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

  static Future<String> generateLessons(
    String genreListText,
    String level,
    String purpose,
    String fromCountry,
    String toCountry,
  ) async {
    final prompt =
        '''

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

class OpenAIHelper {
  static String apiUrl = 'https://api.openai.com/v1/chat/completions';
  static String apiKey = dotenv.env['OPENAI_API']!;

  static Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
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

  Future<List<Puzzle>> generateOptionsQuestions(int unitId) async {
    // Generate a prompt for the AI
    // The prompt is a string that describes what you want the AI to do
    // In this case, we want it to generate a JSON array of questions
    final genre = UnitData.unitData[unitId]!.title;
    final tripId = UnitData.unitData[unitId]!.tripId;
    final fromCountry = TripData.tripData[tripId]!.fromCountry;
    final toCountry = TripData.tripData[tripId]!.toCountry;

    final prompt =
        ''' "You are a friendly quizmaster AI. Generate a JSON array of 10 fun and educational multiple-choice questions about world cultures, traditions, or geography. Each question should be an object with the following fields: question (the question text), choices (an array of 4 possible answers), and answer (the correct answer, which must match one of the choices). Return only the JSON array, not a string or any extra commentary. Do not wrap the array in quotes or markdown. The output must be valid JSON and directly parsable. Example output:  [
    {
      "answer": "3",
      "category": "Dining Etiquette",
      "option1": "Leave a 15-20% cash tip on the table for the excellent service.",
      "option2": "Find your server and hand them a cash tip directly to show your appreciation.",
      "option3": "Do not leave a tip. Pay the exact amount on the bill at the front register.",
      "option4": "Ask the manager if you can add a tip to your credit card payment.",
      "question_sentence": "You've just finished a wonderful dinner at a restaurant in Kyoto and the service was impeccable. As an American used to tipping, what is the correct and respectful action to take?"
    },
    {
      "answer": "2",
      "category": "Dining Etiquette",
      "option1": "Stick them standing upright into the remaining rice in your bowl.",
      "option2": "Place them neatly together on the provided chopstick rest ('hashioki') or lay them across the top of your empty bowl.",
      "option3": "Cross them over your plate to signal you are finished with your meal.",
      "option4": "Use your chopsticks to point to the server to get their attention for the bill.",
      "question_sentence": "You are taking a break during a meal and need to put your chopsticks down. What is the one action you should absolutely AVOID doing as it is a major cultural taboo related to funeral rites?"
    },"

Purpose: The User who lives in $fromCountry is traveling to $toCountry. The user wants to avoid being a bad manner and being an annoying tourist.
Task: Generate a JSON list of 4-option 10 questions in a concrete situation=$genre ,4 options, and the answer.''';

    // { \"question\": \"In India, what is the name of the festival of colors?\", \"choices\": [\"Diwali\", \"Holi\", \"Navratri\", \"Ganesh Chaturthi\"], \"answer\": \"Holi\" } ]"
    final response = await getResponse(prompt);
    print('Response: $response');
    final List jsonResponse = jsonDecode(response);
    final List<Puzzle> questions = [];
    for (var question in jsonResponse) {
      final questionSentence = question['question'];
      final option1 = question['option1'];
      final option2 = question['option2'];
      final option3 = question['option3'];
      final option4 = question['option4'];
      final answer = int.parse(question['answer']);

      questions.add(
        Puzzle(
          id: DateTime.now().millisecondsSinceEpoch,
          unitId: unitId,
          prompt: questionSentence,
          type: PuzzleType.multipleChoice,
          options: [option1, option2, option3, option4],
          correctIndex: answer,
        ),
      );
    }
    return questions;
  }

  static Future<List<String>> generateLessons(
    String level,
    String purpose,
    String fromCountry,
    String toCountry,
  ) async {
    final genresText =
        "['Transportation', 'Hotel Behavior', 'Accent', 'Shopping Etiquette', 'Laws and Rules', 'Business Situation', 'Home Stay', 'Basic Language', 'Behavior on Street', 'Dining Etiquette', 'Technology Use and Communication', 'Cultural Sensitivities', 'Greetings and Introductions', 'Slang']";
    final prompt =
        '''
Make sure the response is only a JSON array of strings, each representing a genre, and no text else
      Pick 6 genres from the list: $genresText based on user's preference: \n Level: $level \n From: $fromCountry \n To: $toCountry \n purpose: $purpose. 
      Output example: ["Transportation", "Dining Etiquette", "Accent", "Shopping Etiquette", "Laws and Rules", "Technology Use and Communication"]
''';
    var response = await getResponse(prompt);
    final cleanedResponse = response
      .replaceAll(RegExp(r'^```json\s*'), '')
      .replaceAll(RegExp(r'\s*```$'), '')
      .trim();
    response = cleanedResponse;
    print('Response: $response');
    final responseJson = jsonDecode(response);
    print(responseJson);
    return List<String>.from(responseJson);
  }
}
class GroqHelper {
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
