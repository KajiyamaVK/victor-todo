// test/unit/services/flow_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:taskem/services/flow/flow_service.dart';

void main() {
  group('FlowService', () {
    late FlowService service;

    setUp(() {
      service = FlowService();
    });

    test('complete returns a stub response', () async {
      final response = await service.complete('Hello, AI!');

      expect(response.isStub, isTrue);
      expect(response.content, isNotEmpty);
    });

    test('complete does not throw for any prompt', () async {
      await expectLater(service.complete(''), completes);
      await expectLater(service.complete('Some prompt'), completes);
    });
  });
}
