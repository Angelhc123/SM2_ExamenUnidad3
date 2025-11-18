import 'package:flutter_test/flutter_test.dart';
import 'package:sm2_examenunidad3/models/alumno_model.dart';
import 'package:sm2_examenunidad3/models/usuario_model.dart';
import 'package:sm2_examenunidad3/models/asistencia_model.dart';
import 'package:sm2_examenunidad3/models/presencia_model.dart';
import 'package:sm2_examenunidad3/config/api_config.dart';

void main() {
  // ============================================================================
  // TEST 1: Pruebas del Modelo AlumnoModel
  // ============================================================================
  group('TEST 1 - Modelo AlumnoModel', () {
    test('T1.1: AlumnoModel debe crearse correctamente desde JSON', () {
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

      final alumno = AlumnoModel.fromJson(json);

      expect(alumno.id, '123');
      expect(alumno.nombre, 'Juan');
      expect(alumno.apellido, 'Pérez');
      expect(alumno.dni, '12345678');
      expect(alumno.codigoUniversitario, 'C2021001');
      expect(alumno.estado, true);
    });

    test('T1.2: AlumnoModel debe convertirse correctamente a JSON', () {
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

      final json = alumno.toJson();

      expect(json['_id'], '456');
      expect(json['nombre'], 'María');
      expect(json['apellido'], 'García');
      expect(json['dni'], '87654321');
      expect(json['codigo_universitario'], 'C2021002');
      expect(json['estado'], true);
    });
  });

  // ============================================================================
  // TEST 2: Pruebas del Modelo UsuarioModel
  // ============================================================================
  group('TEST 2 - Modelo UsuarioModel', () {
    test('T2.1: UsuarioModel debe crearse correctamente desde JSON', () {
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

      final usuario = UsuarioModel.fromJson(json);

      expect(usuario.id, 'user123');
      expect(usuario.nombre, 'Carlos');
      expect(usuario.apellido, 'López');
      expect(usuario.dni, '11223344');
      expect(usuario.email, 'carlos@example.com');
      expect(usuario.rango, 'admin');
      expect(usuario.estado, 'activo');
    });

    test('T2.2: UsuarioModel debe tener valores por defecto', () {
      final json = {
        '_id': 'user456',
        'nombre': 'Ana',
        'apellido': 'Torres',
        'dni': '55667788',
        'email': 'ana@example.com',
      };

      final usuario = UsuarioModel.fromJson(json);

      expect(usuario.rango, 'guardia');
      expect(usuario.estado, 'activo');
    });
  });

  // ============================================================================
  // TEST 3: Pruebas del Modelo AsistenciaModel
  // ============================================================================
  group('TEST 3 - Modelo AsistenciaModel', () {
    test('T3.1: AsistenciaModel debe crearse con datos completos', () {
      final fechaHora = DateTime(2025, 11, 18, 10, 30);
      final json = {
        '_id': 'asist001',
        'nombre': 'Pedro',
        'apellido': 'Ramírez',
        'dni': '44556677',
        'codigo_universitario': 'C2021100',
        'siglas_facultad': 'ING',
        'siglas_escuela': 'IS',
        'tipo': 'alumno',
        'fecha_hora': fechaHora.toIso8601String(),
        'entrada_tipo': 'entrada',
        'puerta': 'Puerta Principal',
      };

      final asistencia = AsistenciaModel.fromJson(json);

      expect(asistencia.id, 'asist001');
      expect(asistencia.nombre, 'Pedro');
      expect(asistencia.tipo, 'alumno');
      expect(asistencia.entradaTipo, 'entrada');
      expect(asistencia.puerta, 'Puerta Principal');
    });

    test('T3.2: AsistenciaModel debe manejar autorización manual', () {
      final asistencia = AsistenciaModel(
        id: 'asist002',
        nombre: 'Laura',
        apellido: 'Sánchez',
        dni: '88990011',
        codigoUniversitario: 'C2021200',
        siglasFacultad: 'MED',
        siglasEscuela: 'MH',
        tipo: 'alumno',
        fechaHora: DateTime.now(),
        entradaTipo: 'entrada',
        puerta: 'Puerta Este',
        autorizacionManual: true,
        razonDecision: 'Tarjeta NFC no disponible',
        guardiaId: 'guard001',
      );

      expect(asistencia.autorizacionManual, true);
      expect(asistencia.razonDecision, isNotNull);
      expect(asistencia.guardiaId, 'guard001');
    });
  });

  // ============================================================================
  // TEST 4: Pruebas del Modelo PresenciaModel
  // ============================================================================
  group('TEST 4 - Modelo PresenciaModel', () {
    test('T4.1: PresenciaModel debe crearse correctamente desde JSON', () {
      final json = {
        '_id': 'pres001',
        'estudiante_id': 'alumno123',
        'estudiante_dni': '22334455',
        'estudiante_nombre': 'Roberto Díaz',
        'facultad': 'Ingeniería',
        'escuela': 'Ingeniería de Sistemas',
        'hora_entrada': '2025-11-18T08:00:00.000Z',
        'punto_entrada': 'Puerta Principal',
        'esta_dentro': true,
        'guardia_entrada': 'guard001',
      };

      final presencia = PresenciaModel.fromJson(json);

      expect(presencia.id, 'pres001');
      expect(presencia.estudianteId, 'alumno123');
      expect(presencia.estudianteNombre, 'Roberto Díaz');
      expect(presencia.estaDentro, true);
      expect(presencia.puntoEntrada, 'Puerta Principal');
    });

    test('T4.2: PresenciaModel debe convertirse a JSON correctamente', () {
      final horaEntrada = DateTime(2025, 11, 18, 8, 0);
      final presencia = PresenciaModel(
        id: 'pres002',
        estudianteId: 'alumno456',
        estudianteDni: '66778899',
        estudianteNombre: 'Elena Vargas',
        facultad: 'Derecho',
        escuela: 'Derecho',
        horaEntrada: horaEntrada,
        puntoEntrada: 'Puerta Este',
        estaDentro: false,
        guardiaEntrada: 'guard002',
        horaSalida: horaEntrada.add(Duration(hours: 4)),
        puntoSalida: 'Puerta Oeste',
      );

      final json = presencia.toJson();

      expect(json['_id'], 'pres002');
      expect(json['estudiante_nombre'], 'Elena Vargas');
      expect(json['esta_dentro'], false);
      expect(json['facultad'], 'Derecho');
      expect(json['punto_salida'], 'Puerta Oeste');
    });

    test('T4.3: PresenciaModel debe calcular tiempo en campus', () {
      final horaEntrada = DateTime.now().subtract(Duration(hours: 3, minutes: 30));
      final presencia = PresenciaModel(
        id: 'pres003',
        estudianteId: 'alumno789',
        estudianteDni: '11223344',
        estudianteNombre: 'Juan Pérez',
        facultad: 'Ingeniería',
        escuela: 'Sistemas',
        horaEntrada: horaEntrada,
        puntoEntrada: 'Puerta Norte',
        estaDentro: true,
        guardiaEntrada: 'guard003',
      );

      expect(presencia.estaDentro, true);
      expect(presencia.statusPresencia, isNotNull);
      expect(presencia.tiempoFormateado, contains('h'));
    });
  });

  // ============================================================================
  // TEST 5: Pruebas de Configuración API
  // ============================================================================
  group('TEST 5 - Configuración API', () {
    test('T5.1: ApiConfig debe retornar URL base válida', () {
      final baseUrl = ApiConfig.baseUrl;

      expect(baseUrl, isNotEmpty);
      expect(baseUrl.startsWith('http'), true);
      expect(baseUrl.contains('railway.app') || baseUrl.contains('192.168'), true);
    });

    test('T5.2: ApiConfig debe generar endpoints correctos', () {
      expect(ApiConfig.loginUrl, contains('/login'));
      expect(ApiConfig.usuariosUrl, contains('/usuarios'));
      expect(ApiConfig.asistenciasUrl, contains('/asistencias'));
      expect(ApiConfig.alumnosUrl, contains('/alumnos'));
      expect(ApiConfig.visitasUrl, contains('/visitas'));
      expect(ApiConfig.facultadesUrl, contains('/facultades'));
      expect(ApiConfig.escuelasUrl, contains('/escuelas'));
    });

    test('T5.3: Todos los endpoints deben usar el baseUrl', () {
      final baseUrl = ApiConfig.baseUrl;

      expect(ApiConfig.loginUrl.startsWith(baseUrl), true);
      expect(ApiConfig.usuariosUrl.startsWith(baseUrl), true);
      expect(ApiConfig.asistenciasUrl.startsWith(baseUrl), true);
      expect(ApiConfig.facultadesUrl.startsWith(baseUrl), true);
      expect(ApiConfig.escuelasUrl.startsWith(baseUrl), true);
    });
  });
}
