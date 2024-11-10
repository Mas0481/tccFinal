import 'package:mysql1/mysql1.dart';

class MySqlConnectionService {
  final ConnectionSettings settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'senha',
    db: 'projeto_final1',
  );

  Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(settings);
  }
}
