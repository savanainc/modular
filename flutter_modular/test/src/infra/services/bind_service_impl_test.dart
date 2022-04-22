import 'package:mocktail/mocktail.dart';
import 'package:modular_core/modular_core.dart';
import 'package:flutter_modular/src/shared/either.dart';
import 'package:flutter_modular/src/domain/errors/errors.dart';
import 'package:flutter_modular/src/infra/services/bind_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mocks.dart';

void main() {
  final injector = InjectorMock();
  final service = BindServiceImpl(injector);

  group('getBind', () {
    test('should get bind', () {
      when(() => injector.get<String>()).thenReturn(BindEntry(bind: BindEmpty(), value: 'test'));
      expect(service.getBind<String>().map((r) => r.value).getOrElse((left) => ''), 'test');
    });
    test('should throw error not found bind', () {
      when(() => injector.get<String>()).thenThrow(BindNotFound('String'));
      expect(service.getBind<String>().fold(id, id), isA<BindNotFoundException>());
    });
  });

  group('dispose', () {
    test('should return true', () {
      when(() => injector.dispose<String>()).thenReturn(true);
      expect(service.disposeBind<String>().getOrElse((left) => false), true);
    });
  });

  group('releaseScopedBinds', () {
    test('should return true', () {
      when(() => injector.removeScopedBinds());
      expect(service.releaseScopedBinds().getOrElse((left) => throw left), unit);
    });
  });
}
