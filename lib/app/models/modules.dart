enum Modules {
  moduleOne(1, "Módulo Principal"),
  moduleTwo(2, "Módulo Essencial"),
  moduleThree(3, "Módulo Opcional"),
  moduleFour(4, "Módulo Avançado");

  const Modules(this.id, this.name);

  final int id;
  final String name;
}

