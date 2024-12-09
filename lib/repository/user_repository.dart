import 'package:tcc/servicos/connection.dart';

class UserRepository {
  final MySqlConnectionService _connectionService;

  UserRepository(this._connectionService);

  Future<bool> authenticate(String username, String password) async {
    final conn = await _connectionService.getConnection();
    try {
      final results = await conn.query(
        'SELECT password FROM usuarios WHERE username = ?',
        [username],
      );

      if (results.isEmpty) {
        return false; // Usuário não encontrado
      }

      final storedHash = results.first['password'] as String;
      //final inputHash = sha256.convert(utf8.encode(password)).toString(); código de ingresso deve usar a mesma criptografia.
      final inputHash = password.toString();

      return inputHash == storedHash;
    } catch (e) {
      print("Erro ao autenticar usuário: $e");
      return false; // Retorna falso em caso de erro
    } finally {
      await conn.close();
    }
  }
}
