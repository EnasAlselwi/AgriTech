import os
import glob
import re

screens = sorted(
    glob.glob('design_reference/stitch_agritech_mobile_auth_redesign/agritech_*/code.html'),
    key=lambda x: int(re.search(r'agritech_(\d+)', x).group(1))
)

for sc in screens:
    name = os.path.basename(os.path.dirname(sc))
    with open(sc, 'r', encoding='utf-8', errors='ignore') as f:
        html = f.read()
    
    # check dark mode
    has_dark = 'dark:' in html
    
    # check nav items
    nav_matches = re.findall(r'<nav[^>]*>(.*?)</nav>', html, re.DOTALL)
    
    # extract title / h1 / h2
    title = re.search(r'<title>(.*?)</title>', html)
    h1 = re.search(r'<h1[^>]*>(.*?)</h1>', html, re.DOTALL)
    h2 = re.search(r'<h2[^>]*>(.*?)</h2>', html, re.DOTALL)
    
    t_str = title.group(1).strip() if title else ''
    h1_str = re.sub(r'<[^>]+>', '', h1.group(1)).strip() if h1 else ''
    h2_str = re.sub(r'<[^>]+>', '', h2.group(1)).strip() if h2 else ''
    h1_clean = ' '.join(h1_str.split())
    h2_clean = ' '.join(h2_str.split())

    # find bottom nav buttons
    nav_buttons = []
    if nav_matches:
        spans = re.findall(r'<span[^>]*>(.*?)</span>', nav_matches[0], re.DOTALL)
        clean_spans = [' '.join(re.sub(r'<[^>]+>', '', s).split()) for s in spans if s.strip()]
        nav_buttons = [s for s in clean_spans if len(s) > 1 and len(s) < 30][:6]

    print(f"Screen: {name}")
    print(f"  Title: {t_str} | H1: {h1_clean} | H2: {h2_clean}")
    print(f"  Dark mode classes: {has_dark}")
    print(f"  Nav buttons: {nav_buttons}")

