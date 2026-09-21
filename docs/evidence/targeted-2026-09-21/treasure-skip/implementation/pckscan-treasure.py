# Offline read-only scan of the Godot .pck (v3, 4.5) for treasure room scenes; dumps [connection] lines.
import struct, re
p = "/Users/yanchenxin/Library/Application Support/Steam/steamapps/common/Slay the Spire 2/SlayTheSpire2.app/Contents/Resources/Slay the Spire 2.pck"
f = open(p, "rb")
assert f.read(4) == b"GDPC"
ver, major, minor, patch = struct.unpack("<4I", f.read(16))
flags, files_base, dir_off = struct.unpack("<IQQ", f.read(20))
f.seek(dir_off)
count, = struct.unpack("<I", f.read(4))
print("pck", ver, major, minor, patch, "flags", flags, "base", files_base, "count", count)
hits = []
for i in range(count):
    n, = struct.unpack("<I", f.read(4))
    name = f.read(n).rstrip(b"\0").decode()
    off, size = struct.unpack("<QQ", f.read(16))
    f.read(16); fl, = struct.unpack("<I", f.read(4))
    if re.search(r"treasure", name, re.I) and name.endswith((".tscn", ".scn")):
        hits.append((name, off, size, fl))
for name, off, size, fl in hits:
    print("==", name, size, fl)
    f.seek(files_base + off if flags & 2 else off)
    data = f.read(size)
    if data[:4] in (b"RSRC", b"RSCC"):
        print("  (binary scn) OnProceedButtonReleased:", b"OnProceedButtonReleased" in data, "OnProceedButtonPressed:", b"OnProceedButtonPressed" in data)
        continue
    text = data.decode("utf-8", "replace")
    for line in text.splitlines():
        if line.startswith("[connection") or "ProceedButton" in line or ("script" in line and "NTreasureRoom" in line):
            print("  ", line)
