import 'package:mysql1/mysql1.dart';

class MySQLConnection {
  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: 'localhost', // Exemplo: '127.0.0.1' ou 'seu_ip'
      port: 3306, // Porta padrão
      user: 'hoot',
      password: '',
      db: 'projeto_final',
    );
    return await MySqlConnection.connect(settings);
  }
}
