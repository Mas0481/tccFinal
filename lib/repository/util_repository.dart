import 'package:tcc/servicos/connection.dart';

class UtilRepository {
  final MySqlConnectionService connectionService;

  UtilRepository(this.connectionService);

  Future<List<Map<String, String>>> getVeiculos() async {
    final conn = await connectionService.getConnection();

    try {
      final results = await conn.query('''
        SELECT placa, modelo, fabricante, cor, categoria
        FROM veiculos
      ''');

      return results.map((row) {
        return {
          'placa': row['placa'] as String? ?? '',
          'modelo': row['modelo'] as String? ?? '',
          'fabricante': row['fabricante'] as String? ?? '',
          'cor': row['cor'] as String? ?? '',
          'categoria': row['categoria'] as String? ?? '',
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar os veículos: $e');
      throw e;
    } finally {
      await conn.close();
    }
  }

  Future<List<Map<String, String>>> getMotoristas() async {
    final conn = await connectionService.getConnection();

    try {
      final results = await conn.query('''
        SELECT m.codMotorista AS codMotorista, p.nome, m.cnhNumero, m.cnhCategoria
        FROM motoristas m
        JOIN pessoas p ON m.codMotorista = p.cpf
      ''');

      return results.map((row) {
        return {
          'codMotorista': row['codMotorista']?.toString() ?? '',
          'nome': row['nome']?.toString() ?? '',
          'cnhNumero': row['cnhNumero']?.toString() ?? '',
          'cnhCategoria': row['cnhCategoria']?.toString() ?? '',
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar os motoristas: $e');
      throw e;
    } finally {
      await conn.close();
    }
  }
}
