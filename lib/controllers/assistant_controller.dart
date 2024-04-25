import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ai_writing_assistant/controllers/rest_api.dart';
import 'package:flutter_ai_writing_assistant/models/assistant_result_model.dart';
import 'package:flutter_ai_writing_assistant/utils/constants.dart';
import 'package:flutter_ai_writing_assistant/utils/enums.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class AssistantController {

  late final GenerativeModel model;

  AssistantController() {
    model = GenerativeModel(
      model: 'gemini-1.0-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 2048,
        temperature: 0.9,
        topP: 1,
        topK: 1,
      ),
    );
  }

  Future<AssistantResultModel?> check(String input, {GeminiVersion version = GeminiVersion.v1_0}) async {
    if (input.isEmpty) {
      return null;
    }

    if (version == GeminiVersion.v1_0) {
      return await _checkGeminiV1_0(input);
    }

    return await _checkGeminiV1_5(input);
  }

  // Using Gemini 1.0 Pro model
  Future<AssistantResultModel?> _checkGeminiV1_0(String input) async {
    try {
      final response = await model.generateContent(
        [
          Content.multi(
              [
                ... structuredParts,
                TextPart("sentence: $input"),
                TextPart("result: "),
              ]
          )
        ],
      );

      if (response.text == null) {
        return null;
      }
      //debugPrint('=====> RESULT: ${response.text}');

      return AssistantResultModel.fromJson(jsonDecode(response.text!), input);
    }
    catch (err) {
      debugPrint('=====> v1.0 Check ERROR: $err');
    }
    return null;
  }

  // Using Gemini 1.5 Pro model
  Future<AssistantResultModel?> _checkGeminiV1_5(String input) async {
    try {
      http.Response? response = await RestApi.getDataFromServer(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent?key=$apiKey',
        {
          "contents": [
            {
              "parts": [
                {
                  "text": freePromptText.replaceAll("{{input}}", input),
                },
              ],
            },
          ],
          "generationConfig": {
            "response_mime_type": "application/json"
          },
        },
      );

      if (response == null) {
        return null;
      }
      //debugPrint('=====> RESULT: ${response.body}');
      Map map = jsonDecode(response.body);
      String jsonResult = map["candidates"][0]["content"]["parts"][0]["text"];
      var decodeRes = jsonDecode(jsonResult);
      if (decodeRes is List) {
        decodeRes = decodeRes[0];
      }
      return AssistantResultModel.fromJson(decodeRes, input);
    }
    catch (err) {
      debugPrint('=====> v1.5 Check ERROR: $err');
    }
    return null;
  }

}