#!/usr/bin/env bash
#
# gen-audio-menu.sh -- regenerate the waybar output-device dropdown from the
# live PipeWire sink list. Writes (next to this script):
#   audio-menu.xml  GTK menu (id "menu") shown by the wireplumber module
#   audio-menu.map  slot index -> sink name, read back by audio-output.sh --slot
#
# Run at waybar start (see launch.sh). Re-run it + reload waybar to pick up a
# device you (un)plugged after login. Both outputs are machine-specific and
# .gitignored, so this works unchanged on any machine.
#
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
command -v pactl >/dev/null || exit 0

default="$(pactl get-default-sink 2>/dev/null || true)"
json="$(pactl -f json list sinks 2>/dev/null || echo '[]')"

XML="$DIR/audio-menu.xml" MAP="$DIR/audio-menu.map" DEFAULT="$default" \
python3 - "$json" <<'PY'
import json, os, sys, html
data = json.loads(sys.argv[1] or "[]")
default = os.environ.get("DEFAULT", "").strip()

xml = ['<?xml version="1.0" encoding="UTF-8"?>', '<interface>',
       '  <object class="GtkMenu" id="menu">']
names = []
for i, s in enumerate(data):
    name = s["name"]
    desc = s.get("description") or name
    names.append(name)
    # No "current device" marker here: waybar builds this menu once at startup,
    # so a baked-in mark would go stale after a switch. The live indicator is the
    # wireplumber tooltip ({node_name}) instead.
    label = html.escape(desc)
    xml.append(f'    <child><object class="GtkMenuItem" id="sink{i}">'
               f'<property name="label">{label}</property></object></child>')
xml.append('    <child><object class="GtkSeparatorMenuItem" id="sep"/></child>')
xml.append('    <child><object class="GtkMenuItem" id="mixer">'
           '<property name="label">   Volume mixer…</property></object></child>')
xml += ['  </object>', '</interface>', '']

with open(os.environ["XML"], "w") as f:
    f.write("\n".join(xml))
with open(os.environ["MAP"], "w") as f:
    f.write("\n".join(names) + ("\n" if names else ""))
PY
