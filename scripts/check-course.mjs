import { readdir, readFile, stat } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
const root = fileURLToPath(new URL('../',import.meta.url));
const files = ['index.html', ...(await readdir(path.join(root,'lessons'))).filter(x=>x.endsWith('.html')).map(x=>'lessons/'+x),...(await readdir(path.join(root,'reference'))).filter(x=>x.endsWith('.html')).map(x=>'reference/'+x)];
const issues = [];
let linkCount=0;
for (const file of files) {
  const html = await readFile(path.join(root,file),'utf8');
  if (!html.includes('lang="zh-CN"') || !html.includes('viewport')) issues.push(`${file}: missing language/viewport`);
  for (const [,raw] of html.matchAll(/(?:href|src)="([^"]+)"/g)) {
    if (/^(https?:|mailto:|data:)/.test(raw)) continue;
    const [url,fragment] = raw.replaceAll('&amp;','&').split('#');
    const target=path.resolve(root,path.dirname(file),decodeURIComponent(url||path.basename(file)));
    try {
      await stat(target); linkCount++;
      if (fragment && target.endsWith('.html')) {
        const content = await readFile(target,'utf8');
        if (!content.includes(`id="${decodeURIComponent(fragment)}"`)) issues.push(`${file}: missing fragment ${raw}`);
      }
    } catch { issues.push(`${file}: missing local target ${raw}`); }
  }
}
const lessonFiles = files.filter(f=>f.startsWith('lessons/'));
if (lessonFiles.length!==44) issues.push(`Expected 44 lessons, found ${lessonFiles.length}`);
for (const file of (await readdir(path.join(root,'content'))).filter(x=>x.endsWith('.json'))) {
  const lessons=JSON.parse(await readFile(path.join(root,'content',file),'utf8'));
  for (const l of lessons) {
    const plain = l.sections.map(s=>s.html.replace(/<[^>]*>/g,'')).join('');
    if (plain.length<600) issues.push(`Lesson ${l.id}: explanation unexpectedly short`);
    if (l.quiz.options.length!==2 || [...l.quiz.options[0]].length!==[...l.quiz.options[1]].length) issues.push(`Lesson ${l.id}: quiz answer length mismatch`);
    if (l.prerequisites.some(id=>id>=l.id||id<1)) issues.push(`Lesson ${l.id}: invalid prerequisite`);
  }
}
if (issues.length) { console.error(issues.join('\n')); process.exitCode=1; }
else console.log(`PASS: ${lessonFiles.length} lessons, ${files.length} HTML files, ${linkCount} local links and anchors checked.`);
