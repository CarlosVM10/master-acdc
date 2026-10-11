# dev.codeja.shop

Base del proyecto de tienda para el Máster Arquitecto IA, con arquitectura hexagonal preparada desde el inicio.
Toda persona o agente debe leer primero [AGENTS.md](AGENTS.md) antes de proponer cambios.
El ciclo de verificación se ejecuta con `./scripts/acdc-verify.sh --fast`.
El formato se comprueba con Spotless y el hook `pre-commit` de Lefthook.
Claude Code y OpenCode aplican además el gate automático descrito en `docs/lab-s03.md`.
