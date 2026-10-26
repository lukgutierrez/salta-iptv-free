# 📺 TV Links Pro - Sistema Automatizado de IPTV (Salta & Argentina)

> **Lista IPTV profesional, modular y auto-mantenida.**
> Cuenta con verificación automática de canales caídos, integración de Guía de Programación (EPG) y compilación automática mediante GitHub Actions.

---

## 📊 Canales y Estado Actual

- **Total canales cargados:** **10 canales** (5 de Salta + 5 Nacionales).
- **Canales de Salta:**
  1. Multivisión Federal Salta (`ONLINE`)
  2. Canal 7 Salta (`ONLINE`)
  3. Neox TV Salta (`ONLINE`)
  4. Canal 10 Salta (`OFFLINE / Requiere Token`)
  5. Telefe Salta Canal 11 (`OFFLINE / Requiere Token`)
- **Canales Nacionales / Temáticos:**
  6. TyC Sports HD (`ONLINE`)
  7. América TV (`ONLINE`)
  8. 24/7 Canal de Noticias (`ONLINE`)
  9. Argentinísima Satelital (`ONLINE`)
  10. VIVE TV Noticias (`ONLINE`)

---

## 🏗️ Arquitectura Modular y Escalable

El proyecto está diseñado para crecer sin desordenarse:

```text
TV LINKS PRO/
├── .github/
│   └── workflows/
│       └── build-and-check.yml   # CI/CD: Chequea streams caídos y compila diario
├── channels/                     # Fuentes separadas por región o género
│   ├── salta.m3u                 # Canales de Salta
│   └── argentina.m3u             # Canales nacionales
├── scripts/
│   └── build.py                  # Validador de enlaces y compilador
├── salta.m3u                     # Lista compilada SOLO Salta
├── playlist.m3u                  # Lista compilada COMPLETA (Salta + Argentina + EPG)
└── README.md
```

---

## 🚀 ¿Cómo subir el proyecto a GitHub de forma profesional?

### 1. Iniciar sesión en GitHub (desde la consola)
Ejecutá en tu terminal:
```powershell
gh auth login
```
*(Elegí `GitHub.com` -> `HTTPS` -> `Yes` para autenticarte vía navegador web).*

### 2. Crear y subir el repositorio automáticamente
Una vez autenticado, ejecutás un solo comando:
```powershell
gh repo create tv-links-pro --public --source=. --remote=origin --push
```
*Si preferís crearlo desde la web de GitHub, creás el repo con nombre `tv-links-pro` y corrés:*
```powershell
git remote add origin https://github.com/TU_USUARIO/tv-links-pro.git
git branch -M main
git push -u origin main
```

---

## 🔗 Tus Enlaces RAW para reproductores

Una vez subido a tu cuenta de GitHub, tus URLs directas serán:

| Lista | Descripción | URL para Televizo / TiviMate / CloudStream |
|---|---|---|
| **Lista Maestra (Recomendada)** | Salta + Canales Nacionales + EPG | `https://raw.githubusercontent.com/TU_USUARIO/tv-links-pro/main/playlist.m3u` |
| **Solo Salta** | Exclusiva de Salta | `https://raw.githubusercontent.com/TU_USUARIO/tv-links-pro/main/salta.m3u` |

---

## ⚙️ Automatización (GitHub Actions)

El proyecto incluye un flujo automático en [`.github/workflows/build-and-check.yml`](.github/workflows/build-and-check.yml):
- Todos los días a las 06:00 UTC (o cada vez que hacés un `git push`), GitHub ejecuta el script.
- Valida si algún canal se cayó.
- Re-compila las listas `playlist.m3u` y `salta.m3u`.
- Si hubo cambios, los guarda automáticamente en el repositorio.

---

## 🛠️ Cómo probar y compilar localmente en tu PC

Podés correr el verificador en cualquier momento desde tu terminal:
```powershell
# Solo compilar listas
python scripts/build.py

# Compilar y verificar si los canales responden ONLINE en vivo
python scripts/build.py --check
```
