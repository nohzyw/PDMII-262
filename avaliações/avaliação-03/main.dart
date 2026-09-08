import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  Database? db;

  try {
    String pathDb = p.join(Directory.current.path, 'alunos.db');
    print('Caminho do banco de dados: $pathDb\n');

    print('--- Operação 1 e 2: Criando/Abrindo Banco de Dados e Tabela ---');
    db = await databaseFactory.openDatabase(
      pathDb,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE tb_alunos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              idade INTEGER NOT NULL
            )
          ''');
          print('Tabela "tb_alunos" criada com sucesso!');
        },
      ),
    );
    print('Conexão com o banco estabelecida com sucesso.\n');

    print('--- Operação 3: Inserindo Alunos ---');
    List<Map<String, dynamic>> alunosParaInserir = [
      {'nome': 'João Silva', 'idade': 20},
      {'nome': 'Maria Oliveira', 'idade': 22},
      {'nome': 'Carlos Souza', 'idade': 19},
    ];

    for (var aluno in alunosParaInserir) {
      try {
        int idInserido = await db.insert('tb_alunos', aluno);
        print('Aluno "${aluno['nome']}" inserido com sucesso (ID: $idInserido).');
      } catch (e) {
        print('Erro ao inserir o aluno "${aluno['nome']}": $e');
      }
    }
    print('');

    print('--- Operação 4: Listando Alunos ---');
    try {
      List<Map<String, dynamic>> alunos = await db.query('tb_alunos');

      if (alunos.isEmpty) {
        print('Nenhum aluno encontrado no banco de dados.');
      } else {
        print('Lista de alunos cadastrados:');
        for (var aluno in alunos) {
          print('ID: ${aluno['id']} | Nome: ${aluno['nome']} | Idade: ${aluno['idade']}');
        }
      }
    } catch (e) {
      print('Erro ao consultar a tabela tb_alunos: $e');
    }

  } on DatabaseException catch (e) {
    print('\n[ERRO DE BANCO DE DADOS]: $e');
  } on SocketException catch (e) {
    print('\n[ERRO DE ARQUIVO/SISTEMA]: ${e.message}');
  } catch (e, stackTrace) {
    print('\n[ERRO INESPERADO]: $e');
    print('Stack trace: $stackTrace');
  } finally {
    if (db != null && db.isOpen) {
      try {
        await db.close();
        print('\nConexão com o banco de dados fechada com sucesso.');
      } catch (e) {
        print('\nErro ao fechar o banco de dados: $e');
      }
    }
  }
}