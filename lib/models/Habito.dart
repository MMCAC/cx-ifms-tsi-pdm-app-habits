class Habito {
  int? id;
  String nome;
  String? dataCriacao;   // Data de criação do hábito (yyyy-MM-dd)
  String? dataConclusao; // Data de conclusão do hábito (yyyy-MM-dd)

  Habito({
    this.id,
    required this.nome,
    this.dataCriacao,
    this.dataConclusao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dataCriacao': dataCriacao,
      'dataConclusao': dataConclusao,
    };
  }

  factory Habito.fromMap(Map<String, dynamic> map) {
    return Habito(
      id: map['id'],
      nome: map['nome'],
      dataCriacao: map['dataCriacao'],
      dataConclusao: map['dataConclusao'],
    );
  }

  void marcarComoConcluido() {
    dataConclusao = DateTime.now().toIso8601String().split('T')[0]; // yyyy-MM-dd
  }

  void desmarcarConclusao() {
    dataConclusao = null;
  }

  bool foiConcluidoHoje() {
    final hoje = DateTime.now().toIso8601String().split('T')[0];
    return dataConclusao == hoje;
  }
}
