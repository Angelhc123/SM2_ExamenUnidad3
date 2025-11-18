import 'package:flutter_test/flutter_test.dart';
import 'package:sm2_examenunidad3/models/alumno_model.dart';
import 'package:sm2_examenunidad3/models/usuario_model.dart';
import 'package:sm2_examenunidad3/config/api_config.dart';

void main() {
  group('Pruebas del Modelo AlumnoModel', () {
    test('AlumnoModel debe crearse correctamente desde JSON', () {
      // Arrange
      final json = {
        '_id': '123',
        '_identificacion': 'A001',
        'nombre': 'Juan',
        'apellido': 'Pérez',
        'dni': '12345678',
        'codigo_universitario': 'C2021001',
        'escuela_profesional': 'Ingeniería de Sistemas',
        'facultad': 'Ingeniería',
        'siglas_escuela': 'IS',
        'siglas_facultad': 'ING',
        'estado': true,
      };

      // Act
      final alumno = AlumnoModel.fromJson(json);

      // Assert
      expect(alumno.id, '123');
      expect(alumno.nombre, 'Juan');
      expect(alumno.apellido, 'Pérez');
      expect(alumno.dni, '12345678');
      expect(alumno.codigoUniversitario, 'C2021001');
      expect(alumno.estado, true);
    });

    test('AlumnoModel debe convertirse correctamente a JSON', () {
      // Arrange
      final alumno = AlumnoModel(
        id: '456',
        identificacion: 'A002',
        nombre: 'María',
        apellido: 'García',
        dni: '87654321',
        codigoUniversitario: 'C2021002',
        escuelaProfesional: 'Medicina',
        facultad: 'Medicina Humana',
        siglasEscuela: 'MED',
        siglasFacultad: 'MH',
        estado: true,
      );

      // Act
      final json = alumno.toJson();

      // Assert
      expect(json['_id'], '456');
      expect(json['nombre'], 'María');
      expect(json['apellido'], 'García');
      expect(json['dni'], '87654321');
      expect(json['codigo_universitario'], 'C2021002');
      expect(json['estado'], true);
    });

    test('AlumnoModel debe manejar valores nulos en JSON', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final alumno = AlumnoModel.fromJson(json);

      // Assert
      expect(alumno.id, '');
      expect(alumno.nombre, '');
      expect(alumno.apellido, '');
      expect(alumno.dni, '');
      expect(alumno.estado, false);
    });
  });

  group('Pruebas del Modelo UsuarioModel', () {
    test('UsuarioModel debe crearse correctamente desde JSON', () {
      // Arrange
      final json = {
        '_id': 'user123',
        'nombre': 'Carlos',
        'apellido': 'López',
        'dni': '11223344',
        'email': 'carlos@example.com',
        'password': 'hash123',
        'rango': 'admin',
        'estado': 'activo',
        'puerta_acargo': 'Puerta Principal',
        'telefono': '987654321',
      };

      // Act
      final usuario = UsuarioModel.fromJson(json);

      // Assert
      expect(usuario.id, 'user123');
      expect(usuario.nombre, 'Carlos');
      expect(usuario.apellido, 'López');
      expect(usuario.dni, '11223344');
      expect(usuario.email, 'carlos@example.com');
      expect(usuario.rango, 'admin');
      expect(usuario.estado, 'activo');
      expect(usuario.telefono, '987654321');
    });

    test('UsuarioModel debe tener valores por defecto para rango y estado', () {
      // Arrange
      final json = {
        '_id': 'user456',
        'nombre': 'Ana',
        'apellido': 'Torres',
        'dni': '55667788',
        'email': 'ana@example.com',
      };

      // Act
      final usuario = UsuarioModel.fromJson(json);

      // Assert
      expect(usuario.rango, 'guardia');
      expect(usuario.estado, 'activo');
    });

    test('UsuarioModel debe manejar fechas correctamente', () {
      // Arrange
      final fechaCreacionStr = '2025-01-15T10:30:00.000Z';
      final json = {
        '_id': 'user789',
        'nombre': 'Luis',
        'apellido': 'Martínez',
        'dni': '99887766',
        'email': 'luis@example.com',
        'rango': 'guardia',
        'estado': 'activo',
        'fecha_creacion': fechaCreacionStr,
      };

      // Act
      final usuario = UsuarioModel.fromJson(json);

      // Assert
      expect(usuario.fechaCreacion, isNotNull);
      expect(usuario.fechaCreacion?.year, 2025);
      expect(usuario.fechaCreacion?.month, 1);
      expect(usuario.fechaCreacion?.day, 15);
    });
  });

  group('Pruebas de Configuración API', () {
    test('ApiConfig debe retornar URL de producción correcta', () {
      // Act
      final baseUrl = ApiConfig.baseUrl;

      // Assert
      expect(baseUrl, isNotEmpty);
      expect(baseUrl.startsWith('http'), true);
    });

    test('ApiConfig debe generar URLs de endpoints correctamente', () {
      // Act & Assert
      expect(ApiConfig.loginUrl, contains('/login'));
      expect(ApiConfig.usuariosUrl, contains('/usuarios'));
      expect(ApiConfig.asistenciasUrl, contains('/asistencias'));
      expect(ApiConfig.alumnosUrl, contains('/alumnos'));
      expect(ApiConfig.visitasUrl, contains('/visitas'));
    });

    test('Todas las URLs deben tener el baseUrl como prefijo', () {
      // Act
      final baseUrl = ApiConfig.baseUrl;

      // Assert
      expect(ApiConfig.loginUrl.startsWith(baseUrl), true);
      expect(ApiConfig.usuariosUrl.startsWith(baseUrl), true);
      expect(ApiConfig.asistenciasUrl.startsWith(baseUrl), true);
      expect(ApiConfig.facultadesUrl.startsWith(baseUrl), true);
      expect(ApiConfig.escuelasUrl.startsWith(baseUrl), true);
    });
  });
}
