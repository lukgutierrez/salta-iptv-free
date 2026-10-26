#!/usr/bin/env python3
"""
TV Links Pro - Build & Stream Validator Script
Genera automáticamente las listas playlist.m3u y salta.m3u combinando los archivos en channels/
"""

import os
import sys
import argparse
import urllib.request
import re

# Asegurar salida utf-8 en Windows terminal
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass

EPG_URL = "https://iptv-org.github.io/epg/guides/ar.xml"
HEADER = f'#EXTM3U url-tvg="{EPG_URL}" x-tvg-url="{EPG_URL}"\n\n'

def check_url(url, timeout=3):
    try:
        req = urllib.request.Request(
            url,
            headers={
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            }
        )
        with urllib.request.urlopen(req, timeout=timeout) as response:
            return response.status in (200, 206, 301, 302)
    except Exception:
        return False

def parse_m3u_file(filepath):
    channels = []
    with open(filepath, "r", encoding="utf-8") as f:
        lines = [line.strip() for line in f if line.strip()]
    
    current_extinf = None
    for line in lines:
        if line.startswith("#EXTINF:"):
            current_extinf = line
        elif current_extinf and not line.startswith("#"):
            channels.append({
                "extinf": current_extinf,
                "url": line
            })
            current_extinf = None
    return channels

def main():
    parser = argparse.ArgumentParser(description="Compilar y validar listas IPTV.")
    parser.add_argument("--check", action="store_true", help="Validar si las URLs de los canales están activas")
    args = parser.parse_args()

    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    channels_dir = os.path.join(root_dir, "channels")

    if not os.path.exists(channels_dir):
        print(f"[!] Carpeta {channels_dir} no encontrada.")
        sys.exit(1)

    all_channels = []
    salta_channels = []

    for fname in sorted(os.listdir(channels_dir)):
        if fname.endswith(".m3u"):
            fpath = os.path.join(channels_dir, fname)
            channels = parse_m3u_file(fpath)
            print(f"[*] {fname}: {len(channels)} canales encontrados.")
            all_channels.extend(channels)
            if "salta" in fname.lower():
                salta_channels.extend(channels)

    print(f"\n[+] Total de canales combinados: {len(all_channels)}")

    if args.check:
        print("\n[*] Validando estado de los canales (esto puede tardar unos segundos)...")
        active_count = 0
        for ch in all_channels:
            name_match = re.search(r',([^,]+)$', ch["extinf"])
            name = name_match.group(1).strip() if name_match else "Canal desconocido"
            is_ok = check_url(ch["url"])
            status = "✅ ONLINE" if is_ok else "⚠️ OFFLINE/PROTEGIDO"
            if is_ok:
                active_count += 1
            print(f"  - {name}: {status}")
        print(f"\n[+] Canales activos: {active_count}/{len(all_channels)}")

    # Escribir playlist.m3u (Maestra)
    playlist_path = os.path.join(root_dir, "playlist.m3u")
    with open(playlist_path, "w", encoding="utf-8") as f:
        f.write(HEADER)
        for ch in all_channels:
            f.write(f"{ch['extinf']}\n{ch['url']}\n\n")
    print(f"[✔] Generado: playlist.m3u ({len(all_channels)} canales)")

    # Escribir salta.m3u (Solo Salta)
    salta_path = os.path.join(root_dir, "salta.m3u")
    with open(salta_path, "w", encoding="utf-8") as f:
        f.write(HEADER)
        for ch in salta_channels:
            f.write(f"{ch['extinf']}\n{ch['url']}\n\n")
    print(f"[✔] Generado: salta.m3u ({len(salta_channels)} canales)")

if __name__ == "__main__":
    main()
