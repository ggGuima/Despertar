

class Usuario {
  int? id;
  String nome;
  String idade;
  String sexo;

  Usuario(this.id, this.nome, this.idade, this.sexo);
  Usuario.novo(this.nome, this.idade, this.sexo);
  Map<String, dynamic> toMap() {
    return{
      'Usuario_id': this.id,
      'Usuario_nome': this.nome,
      'Usuario_idade': this.idade,
      'Usuario_sexo': this.sexo
    };
  }

  static Usuario fromMap (Map<String, dynamic> map){
    return Usuario(
      map['Usuario_id'],
      map['Usuario_nome'] ?? '',
      map['Usuario_idade']?.toString() ?? '',
      map['Usuario_sexo']?.toString() ?? ''
    );
  }
  static List<Usuario> fromMaps (List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }
}