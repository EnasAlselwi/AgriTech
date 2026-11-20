import os
import glob
import re
import json

screens = sorted(
    glob.glob('design_reference/stitch_agritech_mobile_auth_redesign/agritech_*/code.html'),
    key=lambda x: int(re.search(r'agritech_(\d+)', x).group(1))
)

data = []

for sc in screens:
    name = os.path.basename(os.path.dirname(sc))
    with open(sc, 'r', encoding='utf-8', errors='ignore') as f:
        html = f.read()
    
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
    nav_items = []
    if nav_matches:
        # Find <a> or <button> inside nav
        items = re.findall(r'<(?:a|button)[^>]*>(.*?)</(?:a|button)>', nav_matches[0], re.DOTALL)
        for item in items:
            spans = re.findall(r'<span[^>]*>(.*?)</span>', item, re.DOTALL)
            clean_spans = [' '.join(re.sub(r'<[^>]+>', '', s).split()) for s in spans if s.strip()]
            nav_items.append(clean_spans)

    data.append({
        "folder": name,
        "title": t_str,
        "h1": h1_clean,
        "h2": h2_clean,
        "has_nav": len(nav_matches) > 0,
        "nav_items": nav_items
    })

with open('design_reference/screens_summary.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("Saved screens_summary.json")

