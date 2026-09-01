import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() => {
        'nome': _nome,
      };
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() => {
        'nome': _nome,
        'dependentes': _dependentes.map((d) => d.toJson()).toList(),
      };
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() => {
        'nomeProjeto': _nomeProjeto,
        'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
      };
}

void main() {
   Dependente dep1 = Dependente('Lucas');
  Dependente dep2 = Dependente('Sofia');
  Dependente dep3 = Dependente('Mateus');

  Funcionario func1 = Funcionario('Carlos Silva', [dep1, dep2]);
  Funcionario func2 = Funcionario('Mariana Oliveira', [dep3]);
  Funcionario func3 = Funcionario('João Santos', []);

   List<Funcionario> listaFuncionarios = [func1, func2, func3];

   EquipeProjeto equipe = EquipeProjeto('Sistema de Gestão', listaFuncionarios);

   JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String jsonFormatado = encoder.convert(equipe.toJson());

  print(jsonFormatado);
}
