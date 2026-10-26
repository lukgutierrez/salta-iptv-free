# 📺 TV Links Pro - Lista IPTV Personal (Salta & Argentina)

Repositorio para gestionar tu propia lista **Extended M3U** de canales de televisión en vivo mediante flujos HLS directos (`.m3u8`).

---

## 🚀 ¿Cómo funciona?

1. **Lista M3U:** El archivo [`salta.m3u`](salta.m3u) contiene las directivas `#EXTINF` con nombres, logos, categorías y las URLs directas de transmisión.
2. **Hospedado en GitHub:** Al estar subido a GitHub (o GitHub Gist), obtenés un enlace directo tipo **Raw**.
3. **Auto-actualizable:** Cada vez que agregues un canal o actualices un enlace caído en GitHub, todas tus aplicaciones (Televizo, TiviMate, CloudStream, VLC, etc.) descargarán los cambios automáticamente sin necesidad de reconfigurar nada.

---

## 📁 Archivos del Proyecto

- [`salta.m3u`](salta.m3u): Archivo principal con la lista de canales.

---

## 🔎 ¿Cómo capturar nuevos enlaces (.m3u8)?

Si querés agregar otro canal local o nacional desde su página web oficial:

1. Abrí Google Chrome (o Firefox/Brave/Edge) en tu PC.
2. Entrá al sitio web del canal donde se reproduce la transmisión en vivo.
3. Presioná `F12` (o clic derecho -> **Inspeccionar**) para abrir las **DevTools**.
4. Seleccioná la pestaña **Network** (Red).
5. En la caja de filtro, escribí `m3u8`.
6. Dale play al video o recargá la página (`F5`).
7. Vas a ver aparecer solicitudes con nombres como `master.m3u8`, `playlist.m3u8` o `index.m3u8`.
8. Hacé clic derecho sobre la petición -> **Copy** -> **Copy link address**.
9. Pegá ese enlace en [`salta.m3u`](salta.m3u) siguiendo la estructura explicada abajo.

---

## 📝 Estructura de un canal en `salta.m3u`

```m3u
#EXTINF:-1 tvg-id="ID_UNICO" tvg-name="NOMBRE_CANAL" tvg-logo="URL_DEL_LOGO" group-title="GRUPO",NOMBRE VISIBLE
https://url-del-stream.m3u8
```

### Parámetros:
- `tvg-id`: Identificador para guías EPG (opcional).
- `tvg-name`: Nombre estándar del canal.
- `tvg-logo`: Enlace directo a una imagen PNG/JPG transparente del logo.
- `group-title`: Categoría en la que aparecerá (ej: `Salta`, `Nacionales`, `Noticias`, `Deportes`).
- `NOMBRE VISIBLE`: Texto que se mostrará en la lista del reproductor.

---

## 🌐 Subir a GitHub y obtener el enlace RAW

### Paso 1: Subir el repositorio a GitHub
Si tenés [GitHub CLI](https://cli.github.com/) instalado:
```bash
git init
git add .
git commit -m "feat: inicializar lista iptv salta"
gh repo create tv-links-pro --public --source=. --push
```
O desde la web de GitHub:
1. Creá un nuevo repositorio público llamado `tv-links-pro`.
2. Subí el archivo `salta.m3u`.

### Paso 2: Obtener el enlace RAW
1. Entrá a tu repositorio en GitHub y hacé clic en `salta.m3u`.
2. Hacé clic en el botón **Raw** (arriba a la derecha del visor de código).
3. La URL en tu navegador se verá similar a:
   ```text
   https://raw.githubusercontent.com/TU_USUARIO/tv-links-pro/main/salta.m3u
   ```
4. **¡Ese es el enlace que usarás en todas tus aplicaciones!**

---

## 📱 Configuración en Reproductores

### 1. CloudStream (Android / Android TV / Fire TV)
1. Instalá el plugin o repositorio compatible con M3U (como **M3UPlaylistPlayer**).
2. En la configuración del proveedor, pegá tu enlace `Raw` de GitHub.
3. Tus canales aparecerán organizados por categorías.

### 2. Televizo (Android / Android TV)
1. Abrí Televizo -> Menú -> **Playlists**.
2. Tocá el botón **+** (Nueva lista de reproducción) -> **Nueva lista M3U**.
3. Nombre de la lista: `Salta TV`.
4. URL de la lista de reproducción: Pegá tu enlace `Raw`.
5. Guardá y listo.

### 3. TiviMate (Recomendado para Smart TV Android / Google TV)
1. Abrí TiviMate -> **Añadir lista de reproducción** -> **Lista M3U**.
2. Ingresá la URL Raw de GitHub.
3. Activá la opción de auto-actualización al iniciar.

### 4. VLC Media Player (PC / Móvil)
- **PC:** `Ctrl + N` (Abrir volcado de red) -> Pegá la URL Raw -> Reproducir.
- **Móvil:** Pestaña *Más* -> *Flujo* -> Pegá la URL.
