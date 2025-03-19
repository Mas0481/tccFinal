import 'package:tcc/servicos/connection.dart';

class EquipamentosRepository {
  final MySqlConnectionService connectionService;

  EquipamentosRepository(this.connectionService);
  Future<List<Map<String, String>>> getEquipamentos() async {
    // Obtendo a conexão
    final conn = await MySqlConnectionService().getConnection();

    try {
      // Executando a query
      final results = await conn.query('''
      SELECT e.codEquipamento, e.nomeEquipamento
      FROM equipamentos AS e
    ''');

      // teste imprimindo os resultados antes de mapear
      print('Resultados da consulta:');
      for (var row in results) {
        print('cod: ${row['codEquipamento']}, nome: ${row['nomeEquipamento']}');
      }

      // Transformando os resultados em uma lista de mapas
      return results.map((row) {
        return {
          'codEquipamento': (row['codEquipamento'] as int)
              .toString(), // Convertendo int para String
          'nomeEquipamento': row['nomeEquipamento'] as String,
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar os equipamentos: $e');
      throw e;
    } finally {
      // Fechando a conexão
      await conn.close();
    }
  }

// Método para buscar um equipamento pelo ID
  Future<Map<String, String>?> findEquipamentoById(int id) async {
    // Obtendo a conexão
    final conn = await MySqlConnectionService().getConnection();

    try {
      // Executando a query
      final results = await conn.query('''
      SELECT e.codEquipamento, e.nomeEquipamento
      FROM equipamentos AS e
      WHERE e.codEquipamento = ?
    ''', [id]);

      // Verificando se encontrou algum resultado
      if (results.isNotEmpty) {
        final row = results.first;
        return {
          'codEquipamento': (row['codEquipamento'] as int)
              .toString(), // Convertendo int para String
          'nomeEquipamento': row['nomeEquipamento'] as String,
        };
      } else {
        return null; // Retorna null se não encontrar o equipamento
      }
    } catch (e) {
      print('Erro ao buscar o equipamento: $e');
      throw e;
    } finally {
      // Fechando a conexão
      await conn.close();
    }
  }
}
//   }