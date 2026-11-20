import os
import re

for n in [1, 15]:
    path = f'design_reference/stitch_agritech_mobile_auth_redesign/agritech_{n}/code.html'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    # Strip HTML tags but keep some structure
    text = re.sub(r'<script.*?</script>', '', content, flags=re.DOTALL)
    text = re.sub(r'<style.*?</style>', '', text, flags=re.DOTALL)
    lines = [l.strip() for l in re.sub(r'<[^>]+>', '\n', text).splitlines() if l.strip()]
    with open(f'design_reference/agritech_{n}_text.txt', 'w', encoding='utf-8') as out:
        out.write('\n'.join(lines))
    print(f"Written agritech_{n}_text.txt ({len(lines)} lines)")

