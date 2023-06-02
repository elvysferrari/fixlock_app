class DBTable{
  String get dropTables => '''
    DROP TABLE IF EXISTS dispositivo;
    DROP TABLE IF EXISTS dispositivo_registro;
    DROP TABLE IF EXISTS regiao;
    DROP TABLE IF EXISTS condominio;
  ''';

  String get dipositivo => '''
    CREATE TABLE IF NOT EXISTS dispositivo (
      id_dis INTEGER, 
      dsc_dis TEXT, 
      ser_dis TEXT, 
      id_con INTEGER
    );
  ''';

  String get dispositivoRegistro => '''
    CREATE TABLE IF NOT EXISTS dispositivo_registro(
      dta_reg TEXT, 
      dsc_reg TEXT, 
      id_dis INTEGER, 
      id_tec INTEGER
    );
  ''';

  String get deletaDispositivoRegistro => '''
    DELETE FROM dispositivo_registro;
  ''';

  String get regiao => '''
    CREATE TABLE IF NOT EXISTS regiao(
      id_reg INTEGER, 
      nom_reg TEXT
    );
  ''';

  String get condominio => '''
    CREATE TABLE IF NOT EXISTS condominio(
      id_con INTEGER, 
      nom_con TEXT, 
      id_reg INTEGER
    );
  ''';

  String get deletaTodosRegistro => '''
    DELETE FROM regiao;
    DELETE FROM condominio;
    DELETE FROM dispositivo;
    DELETE FROM dispositivo_registro;
  ''';

}