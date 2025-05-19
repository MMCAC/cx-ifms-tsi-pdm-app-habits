class Habito {
  int? id;
  String? nome;
  String? emoji;
  bool concluido;
  String? dias;
  String? ultimaAtualizacao;

  Habito({
    this.id,
    this.nome,
    this.emoji,
    this.concluido = false,
    this.dias,
    this.ultimaAtualizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'emoji': emoji,
      'concluido': concluido ? 1 : 0,
      'dias': dias,
      'ultimaAtualizacao': ultimaAtualizacao,
    };
  }

  factory Habito.fromMap(Map<String, dynamic> map) {
    return Habito(
      id: map['id'],
      nome: map['nome'],
      emoji: map['emoji'],
      concluido: map['concluido'] == 1,
      dias: map['dias'],
      ultimaAtualizacao: map['ultimaAtualizacao'],
    );
  }
}