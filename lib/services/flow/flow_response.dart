// lib/services/flow/flow_response.dart
//
// Response data class for FLOW LiteLLM Proxy calls.

/// Represents a response from the FLOW LiteLLM Proxy.
///
/// [isStub] is true when the response is a hardcoded stub
/// rather than a real AI-generated response.
class FlowResponse {
  const FlowResponse({required this.content, this.isStub = false});

  /// The text content of the response.
  final String content;

  /// True when this response is a stub, not a real AI response.
  final bool isStub;
}
