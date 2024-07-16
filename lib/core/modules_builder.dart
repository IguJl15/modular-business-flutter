

enum ModuleHardCoded {
  one(1, "Módulo Principal"),
  two(2, "Módulo Essencial"),
  three(3, "Módulo Opcional"),
  four(4, "Módulo Complexo");

  const ModuleHardCoded(this.id, this.name);

  final int id;
  final String name;
}