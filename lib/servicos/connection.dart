import 'package:mysql1/mysql1.dart';

class MySqlConnectionService {
  final ConnectionSettings settings = ConnectionSettings(
    host: '100.122.103.5',
    port: 3306,
    user: 'tcc',
    password: 'tcc123',
    db: 'projeto_final',
  );

  Future<MySqlConnection> getConnection() async {
    try {
      final connection = await MySqlConnection.connect(settings);
      print('Conexão estabelecida com sucesso!');
      return connection;
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
      rethrow;
    }
  }
}
