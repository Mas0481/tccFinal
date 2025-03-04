import 'package:tcc/servicos/connection.dart';

class ClienteRepository {
  final MySqlConnectionService connectionService;

  ClienteRepository(this.connectionService);

  // Método para buscar os códigos e nomes dos clientes
  // Método para buscar os códigos e nomes dos clientes
  Future<List<Map<String, String>>> getClientes() async {
    // Obtendo a conexão
    final conn = await MySqlConnectionService().getConnection();

    try {
      // Executando a query
      final results = await conn.query('''
      SELECT c.codCliente, p.nome
      FROM clientes AS c
      INNER JOIN pessoas AS p 
      ON c.fk_Cpf = p.cpf
    ''');

      // teste imprimindo os resultados antes de mapear
      print('Resultados da consulta:');
      for (var row in results) {
        print('cod_cliente: ${row['codCliente']}, nome: ${row['nome']}');
      }

      // Transformando os resultados em uma lista de mapas
      return results.map((row) {
        return {
          'codCliente': (row['codCliente'] as int)
              .toString(), // Convertendo int para String
          'nome': row['nome'] as String,
        };
      }).toList();
    } catch (e) {
      print('Erro ao buscar os clientes: $e');
      throw e;
    } finally {
      // Fechando a conexão
      await conn.close();
    }
  }
}
