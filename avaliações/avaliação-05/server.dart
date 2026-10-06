import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class Aluno {
  final int id;
  final String nome;
  final String disciplina;
  final double media;
  final int faltas;

  Aluno({
    required this.id,
    required this.nome,
    required this.disciplina,
    required this.media,
    required this.faltas,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'disciplina': disciplina,
        'media': media,
        'faltas': faltas,
      };
}

// Lista em memória com alunos de teste
final List<Aluno> alunos = [
  Aluno(id: 1, nome: 'Lucas', disciplina: 'Programação', media: 8.5, faltas: 5),
  Aluno(id: 2, nome: 'Maria', disciplina: 'Banco de Dados', media: 5.0, faltas: 10),
  Aluno(id: 3, nome: 'João', disciplina: 'Redes', media: 7.0, faltas: 22),
  Aluno(id: 4, nome: 'Ana', disciplina: 'Sistemas', media: 4.5, faltas: 25),
];

Response jsonResponse(Object data, {int statusCode = 200}) {
  return Response(
    statusCode,
    body: jsonEncode(data),
    headers: {'content-type': 'application/json'},
  );
}

Response _listarAlunos(Request request) {
  final listMap = alunos.map((a) => a.toJson()).toList();
  return jsonResponse(listMap);
}

void main() async {
  final app = Router();
  app.get('/api/alunos', _listarAlunos);

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(app.call);
  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}