

class Medicamento {
  int? id;
  String nome;
  String frequencia;
  String periodo;

  Medicamento(this.id, this.nome, this.frequencia, this.periodo);
  Medicamento.novo(this.nome, this.frequencia, this.periodo);
  Map<String, dynamic> toMap() {
    return{
      'Medicamento_id': this.id,
      'Medicamento_nome': this.nome,
      'Medicamento_Frequencia': this.frequencia,
      'Medicamento_periodo': this.periodo
    };
  }

  static Medicamento fromMap (Map<String, dynamic> map){
    return Medicamento(
      map['Medicamento_id'],
      map['Medicamento_nome'] ?? '',
      map['Medicamento_Frequencia']?.toString() ?? '',
      map['Medicamento_periodo']?.toString() ?? ''
    );
  }
  static List<Medicamento> fromMaps (List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Medicamento.fromMap(maps[i]);
    });
  }
}