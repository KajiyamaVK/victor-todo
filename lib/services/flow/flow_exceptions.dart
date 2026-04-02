// lib/services/flow/flow_exceptions.dart
//
// Exception types for FLOW LiteLLM Proxy errors.

/// Base exception for all FLOW service errors.
class FlowException implements Exception {
  const FlowException(this.message);

  /// Human-readable error message.
  final String message;

  @override
  String toString() => 'FlowException: $message';
}

/// Thrown when the FLOW_API_KEY environment variable is missing or invalid.
class FlowAuthException extends FlowException {
  const FlowAuthException() : super('FLOW_API_KEY is missing or invalid.');
}

/// Thrown when a network error prevents reaching the FLOW proxy.
class FlowConnectionException extends FlowException {
  const FlowConnectionException(super.message);
}
