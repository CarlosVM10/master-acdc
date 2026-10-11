@AGENTS.md

# Reglas específicas de Claude Code

- Los hooks de `.claude/settings.json` inyectan contexto al iniciar, protegen la zona AC/DC, formatean Java tras cada edición y ejecutan el gate al parar.
- El gate permite **3 intentos** de corrección por sesión. Si el tercero falla, detente y escala a una persona con el informe de `acdc-verify`.
- La zona protegida es `config/`, `.claude/`, `.opencode/`, `.github/`, `pom.xml` y `.env*`. No la edites sin autorización explícita del usuario.
- Cuando un hook bloquee una acción, no intentes evadirlo: explica qué permiso o decisión humana hace falta.
