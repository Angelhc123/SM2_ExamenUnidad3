import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcService {
  static final NfcService _instance = NfcService._internal();
  factory NfcService() => _instance;
  NfcService._internal();

  // Verificar disponibilidad de NFC
  Future<bool> isNfcAvailable() async {
    try {
      final NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
      return availability == NFCAvailability.available;
    } catch (e) {
      return false;
    }
  }

  // Leer pulsera NFC y obtener código universitario
  Future<String> readNfcCard() async {
    try {
      // Verificar disponibilidad
      final bool available = await isNfcAvailable();
      if (!available) {
        throw Exception('NFC no está disponible en este dispositivo');
      }

      // print('🔍 Iniciando polling NFC...');

      // Iniciar sesión NFC con timeout más corto para lectura inmediata
      final NFCTag tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 5),
        iosMultipleTagMessage:
            'Múltiples tags detectados, por favor acerque solo una pulsera',
        iosAlertMessage: 'Leyendo pulsera...',
      );

      // Verificar que es un tag válido
      if (tag.id.isEmpty) {
        throw Exception('Tag NFC inválido');
      }

      // Leer datos del tag
      final String codigoUniversitario = await _extractCodigoFromTag(tag);

      return codigoUniversitario;
    } catch (e) {
      throw Exception('Error al leer NFC: $e');
    } finally {
      // Finalizar sesión NFC
      await FlutterNfcKit.finish(iosAlertMessage: 'Lectura completada');
    }
  }

  // Extraer código universitario del tag NFC - Optimizado para MIFARE Classic
  Future<String> _extractCodigoFromTag(NFCTag tag) async {
    try {
      final String tagId = tag.id;

      // print('🏷️ Tag detectado:');
      // print('  - ID: $tagId');
      // print('  - Tipo: ${tag.type}');
      // print('  - Standard: ${tag.standard}');
      // print('  - NDEF disponible: ${tag.ndefAvailable}');

      // Método 1: Intentar leer datos NDEF si están disponibles
      if (tag.ndefAvailable == true) {
        try {
          final ndefRecords = await FlutterNfcKit.readNDEFRecords();
          // print('📄 Registros NDEF encontrados: ${ndefRecords.length}');

          if (ndefRecords.isNotEmpty) {
            for (var record in ndefRecords) {
              if (record.payload != null && record.payload!.isNotEmpty) {
                final String payload = String.fromCharCodes(record.payload!);
                // print('📝 Payload NDEF: $payload');

                // Buscar formato específico: "codigo:XXXXXXXX"
                if (payload.contains('codigo:')) {
                  final String codigo = payload.split('codigo:')[1].trim();
                  // print('✅ Código encontrado en NDEF: $codigo');
                  return codigo;
                }

                // Si el payload es un código directo (solo números/letras)
                if (RegExp(r'^[A-Z0-9]{6,12}$').hasMatch(payload.trim())) {
                  // print('✅ Código directo en NDEF: ${payload.trim()}');
                  return payload.trim();
                }
              }
            }
          }
        } catch (e) {
          // print('⚠️ Error leyendo NDEF: $e');
        }
      }

      // Método 2: Para MIFARE Classic - usar el ID hexadecimal del tag
      if (tag.type.toString().toLowerCase().contains('mifare') ||
          tag.standard.toString().toLowerCase().contains('14443')) {
        // Convertir ID hexadecimal a diferentes formatos
        final String hexId = tagId.toLowerCase().replaceAll(' ', '');
        // print('🔢 Procesando MIFARE Classic ID: $hexId');

        // Opción 1: Usar ID hexadecimal completo como código (en minúsculas)
        if (hexId.length >= 6) {
          final String codigoHex = hexId;
          // print('✅ Usando ID hex como código: $codigoHex');
          return codigoHex;
        } // Opción 2: Convertir hex a decimal y usar como código
        try {
          final int decimalId = int.parse(hexId, radix: 16);
          String codigoDecimal = decimalId.toString();
          // print('✅ Código decimal del ID: $codigoDecimal');

          // Si es muy largo, tomar los últimos 8 dígitos
          if (codigoDecimal.length > 8) {
            codigoDecimal = codigoDecimal.substring(codigoDecimal.length - 8);
          }

          return codigoDecimal;
        } catch (e) {
          // print('⚠️ Error convirtiendo hex a decimal: $e');
        }
      }

      // Método 3: Fallback - usar ID del tag directamente
      final String cleanId = tagId
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll(':', '');
      if (cleanId.length >= 6) {
        final String codigo =
            cleanId.length > 8
                ? cleanId.substring(cleanId.length - 8)
                : cleanId;
        // print('✅ Usando ID limpio como código: $codigo');
        return codigo;
      }

      // print('❌ No se pudo extraer código válido');
      throw Exception('No se pudo extraer un código válido de la tarjeta');
    } catch (e) {
      // print('❌ Error en extracción: $e');
      throw Exception('Error al extraer código del tag: $e');
    }
  }

  // Escribir código universitario a una pulsera NFC (para configuración)
  Future<void> writeCodigoToNfc(String codigoUniversitario) async {
    try {
      // Verificar disponibilidad
      final bool available = await isNfcAvailable();
      if (!available) {
        throw Exception('NFC no está disponible en este dispositivo');
      }

      // Por ahora, esta funcionalidad está pendiente de implementar
      // según el formato específico de las pulseras NFC
      throw Exception('Funcionalidad de escritura NFC en desarrollo');
    } catch (e) {
      throw Exception('Error al escribir NFC: $e');
    }
  }

  // Leer NFC y mostrar resultado inmediatamente
  Future<String> readNfcWithResult() async {
    try {
      // print('📱 =================================');
      // print('📱 INICIANDO LECTURA NFC');
      // print('📱 =================================');

      // Verificar disponibilidad
      final bool available = await isNfcAvailable();
      if (!available) {
        throw Exception('❌ NFC no está disponible en este dispositivo');
      }

      // print('📱 ✅ NFC disponible, iniciando polling...');

      // Iniciar polling NFC
      final NFCTag tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 8),
        iosAlertMessage: '🔍 Acerque la pulsera al dispositivo...',
      );

      // print('📱 🏷️ Tag NFC detectado!');
      // print('📱 ID del Tag: ${tag.id}');

      if (tag.id.isEmpty) {
        throw Exception('❌ Tag NFC inválido (ID vacío)');
      }

      // Extraer código
      final String codigo = await _extractCodigoFromTag(tag);

      // print('📱 =================================');
      // print('📱 ✅ LECTURA EXITOSA');
      // print('📱 Código extraído: $codigo');
      // print('📱 =================================');

      return codigo;
    } catch (e) {
      // print('📱 =================================');
      // print('📱 ❌ ERROR EN LECTURA NFC');
      // print('📱 Error: $e');
      // print('📱 =================================');
      rethrow;
    } finally {
      try {
        await FlutterNfcKit.finish(iosAlertMessage: '✅ Lectura completada');
        // print('📱 🔚 Sesión NFC finalizada');
      } catch (e) {
        // print('📱 ⚠️ Error finalizando sesión: $e');
      }
    }
  }

  // Detener cualquier operación NFC en curso
  Future<void> stopNfcSession() async {
    try {
      await FlutterNfcKit.finish();
    } catch (e) {
      // Ignorar errores al finalizar
    }
  }
}
