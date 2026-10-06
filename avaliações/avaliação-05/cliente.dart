import 'dart:convert';
import 'package:http/http.dart' as http;

// Função responsável por calcular a situação acadêmica do aluno
String calcularSituacao(double media, int faltas) {
  if (faltas > 20) {
    return 'Reprovado por Faltas';
  } else if (media < 6.0) {
    return 'Reprovado';
  } else {
    return 'Aprovado';
  }
}

void main() async {
  final url = Uri.parse('http://localhost:8080/api/alunos');

  try {
    // 1. Faz a requisição HTTP GET para o servidor
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> listaAlunos = jsonDecode(response.body);

      // Imprime o cabeçalho formatado
      print('=' * 75);
      print('${'ID'.padRight(5)} ${'NOME'.padRight(15)} ${'DISCIPLINA'.padRight(18)} ${'MEDIA'.padRight(8)} ${'FALTAS'.padRight(8)} MENSAGEM');
      print('=' * 75);

      // 2. Itera sobre os alunos e aplica a regra de negócio
      for (var item in listaAlunos) {
        final int id = item['id'];
        final String nome = item['nome'];
        final String disciplina = item['disciplina'];
        final double media = (item['media'] as num).toDouble();
        final int faltas = item['faltas'];

        final String mensagem = calcularSituacao(media, faltas);

        // Imprime a linha com espaçamento padronizado
        print(
          '${id.toString().padRight(5)} '
          '${nome.padRight(15)} '
          '${disciplina.padRight(18)} '
          '${media.toStringAsFixed(1).padRight(8)} '
          '${faltas.toString().padRight(8)} '
          '$mensagem',
        );
      }
      print('=' * 75);
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao conectar ao servidor: $e');
  }
}