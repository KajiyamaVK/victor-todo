// lib/services/flow/flow_service.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:victor_todo/services/flow/flow_response.dart';

/// Stub client for the FLOW LiteLLM Proxy.
///
/// This is plumbing only — no AI features are active in v1.
/// The HTTP client, auth headers, and base URL resolution are real.
/// The [complete] method returns a hardcoded stub response.
///
/// Environment variables (loaded from .env):
///   FLOW_API_KEY  — Bearer token for the proxy.
///   FLOW_BASE_URL — Proxy URL (optional, defaults to production URL).
///
/// When AI features are activated, only the [complete] method body changes.
class FlowService {
  FlowService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _defaultBaseUrl =
      'https://flow.ciandt.com/flow-llm-proxy/v1';

  /// Returns the base URL, preferring the env var over the default.
  /// Gracefully handles the case where dotenv is not yet initialised
  /// (e.g., in unit tests that don't call dotenv.load).
  String get _baseUrl {
    try {
      return dotenv.env['FLOW_BASE_URL'] ?? _defaultBaseUrl;
    } catch (_) {
      return _defaultBaseUrl;
    }
  }

  /// Returns the API key from the environment, or null if not set or not
  /// initialised.
  String? get _apiKey {
    try {
      return dotenv.env['FLOW_API_KEY'];
    } catch (_) {
      return null;
    }
  }

  /// Sends a completion request to the FLOW proxy.
  ///
  /// Currently returns a [FlowResponse] with stubbed content without making
  /// an HTTP call. Replace the stub body with a real HTTP POST when
  /// activating AI features.
  ///
  /// [prompt] is the user's input to be sent to the LLM.
  Future<FlowResponse> complete(String prompt) async {
    // Stub: return immediately without making an HTTP call.
    // Fields are referenced to satisfy linter.
    // ignore: unnecessary_statements
    (_baseUrl, _apiKey, _client, prompt);

    return const FlowResponse(
      content: 'AI features are not yet active.',
      isStub: true,
    );
  }
}
