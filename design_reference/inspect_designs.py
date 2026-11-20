import sys
import os
import glob
import re

sys.stdout.reconfigure(encoding='utf-8')

for f in sorted(glob.glob('design_reference/stitch_agritech_mobile_auth_redesign/agritech_*/code.html')):
    screen_name = os.path.basename(os.path.dirname(f))
    with open(f, 'r', encoding='utf-8', errors='ignore') as fp:
        c = fp.read()
    imgs = set(re.findall(r'src=["\']([^"\']+)["\']', c))
    bgs = set(re.findall(r'url\(["\']?([^"\')]+)["\']?\)', c))
    all_refs = imgs.union(bgs)
    font_refs = [x for x in all_refs if 'font' in x or 'woff' in x or 'ttf' in x]
    img_refs = [x for x in all_refs if x not in font_refs]
    print(f"=== {screen_name} ===")
    for r in img_refs:
        print(f"  {r}")

