import 'package:tcc/servicos/connection.dart';

class ProcessosRepository {
  final MySqlConnectionService connectionService;

  ProcessosRepository(this.connectionService);

  Future<List<Map<String, String>>> getProcessos() async {
    // Obtendo a conexão
    final conn = await MySqlConnectionService().getConnection();

    try {
      // Executando a query
      final results = await conn.query('''
      SELECT e.codProcesso, e.nomeProcesso
      FROM processos AS e
    ''');

      // teste imprimindo os resultados antes de mapear
      print('Resultados da consulta:');
      for (var row in results) {
        print('cod: ${row['codProcesso']}, nome: ${row['nomeProcesso']}');
      }

      // Transformando os resultados em uma lista de mapas
      return results.map((row) {
        return {
          'codProcesso': (row['codProcesso'] as int?)?.toString() ??
              '', // Convertendo int para String e tratando null
          'nomeProcesso': row['nomeProcesso'] as String? ?? '', // Tratando null
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar os processos: $e');
      throw e;
    } finally {
      // Fechando a conexão
      await conn.close();
    }
  }

  Future<Map<String, String>?> findProcessoById(int id) async {
    // Obtendo a conexão
    final conn = await MySqlConnectionService().getConnection();

    try {
      // Executando a query
      final results = await conn.query('''
      SELECT e.codProcesso, e.nomeProcesso
      FROM processos AS e
      WHERE e.codProcesso = ?
    ''', [id]);

      if (results.isNotEmpty) {
        final row = results.first;
        return {
          'codProcesso': (row['codProcesso'] as int).toString(),
          'nomeProcesso': row['nomeProcesso'] as String,
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar o processo: $e');
      throw e;
    } finally {
      // Fechando a conexão
      await conn.close();
    }
  }

  Future<Map<String, String>?> findProcessoByName(String nomeProcesso) async {
    // Obtendo a conexão
    final conn = await MySqlConnectionService().getConnection();

    try {
      // Executando a query
      final results = await conn.query('''
      SELECT e.codProcesso, e.nomeProcesso, e.tempoProcesso
      FROM processos AS e
      WHERE e.nomeProcesso = ?
    ''', [nomeProcesso]);

      if (results.isNotEmpty) {
        final row = results.first;
        return {
          'codProcesso': (row['codProcesso'] as int).toString(),
          'nomeProcesso': row['nomeProcesso'] as String,
          'tempoProcesso':
              row['tempoProcesso'] as String, // Incluindo tempoProcesso
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar o processo: $e');
      throw e;
    } finally {
      // Fechando a conexão
      await conn.close();
    }
  }
}
