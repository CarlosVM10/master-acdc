# Guía AC/DC para agentes y colaboradores

Lee este archivo antes de proponer o aplicar cambios. Si una petición entra en conflicto con estas reglas, explica el conflicto y pide autorización explícita.

## Arquitectura (exigida desde S17–S18)

- `domain` contiene modelo y puertos: no depende de Spring, `application` ni `infrastructure`.
- `application` orquesta casos de uso y sólo depende de `domain`.
- `infrastructure` implementa puertos y contiene adaptadores, configuración y frameworks; puede depender de las capas interiores.
- Los adaptadores de entrada no acceden directamente a persistencia ni a detalles de otros adaptadores. Las dependencias entre capas serán verificadas con ArchUnit en S18.

## Código y pruebas

- Java 25, formato `google-java-format`, sin imports no usados; nombres en inglés y clases en `PascalCase`, métodos/campos en `camelCase`.
- Los tests se llaman `*Test`; los de integración, `*IntegrationTest`; describe el comportamiento con nombres `should...When...`.
- Desde S15 el mutation score mínimo será **80 %** global y **70 %** por clase modificada; no se rebaja sin una decisión documentada.

## Seguridad

- Nunca añadas secretos, tokens, contraseñas, llaves privadas, ficheros `.env*` ni datos personales reales al repositorio, logs o fixtures.
- Usa variables de entorno y datos sintéticos. Redacta valores sensibles antes de mostrar comandos, diffs o evidencias.

## Verify (obligatorio)

- Ejecuta exactamente `./scripts/acdc-verify.sh --fast` antes de declarar una tarea terminada. Para una validación completa usa `./scripts/acdc-verify.sh --full`.
- No ignores, desactives ni modifiques el verificador, los hooks, el plugin, `pom.xml`, `config/`, `.github/` o `.env*` sin permiso humano explícito.
- No uses `--skipTests`, `-DskipTests`, exclusiones de tests, ni suprimidos para hacer pasar la verificación.
