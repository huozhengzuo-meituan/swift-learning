// 只向本机提供课程文件；不安装依赖，不暴露到局域网。
import http from 'node:http';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { realpath, stat, readFile } from 'node:fs/promises';
const port = Number(process.argv[2] || 8766);
if (!Number.isInteger(port) || port < 1024 || port > 65535) throw new Error('Port must be an integer from 1024 to 65535');
const root = await realpath(fileURLToPath(new URL('../',import.meta.url)));
const types = {'.html':'text/html; charset=utf-8','.css':'text/css; charset=utf-8','.js':'text/javascript; charset=utf-8','.json':'application/json; charset=utf-8','.md':'text/plain; charset=utf-8','.swift':'text/plain; charset=utf-8','.sh':'text/plain; charset=utf-8'};
const server = http.createServer(async (request,response) => {
  if (!['GET','HEAD'].includes(request.method)) { response.writeHead(405,{Allow:'GET, HEAD'}); response.end(); return; }
  try {
    const url = new URL(request.url,'http://127.0.0.1');
    const pathname = decodeURIComponent(url.pathname);
    const candidate = await realpath(path.join(root,pathname === '/' ? 'index.html' : pathname));
    if (candidate !== root && !candidate.startsWith(root+path.sep)) { response.writeHead(403); response.end('Forbidden'); return; }
    if (!(await stat(candidate)).isFile()) { response.writeHead(404); response.end('Not found'); return; }
    const data = await readFile(candidate);
    response.writeHead(200,{'Content-Type':types[path.extname(candidate)]||'text/plain; charset=utf-8','X-Content-Type-Options':'nosniff','Cache-Control':'no-cache'});
    response.end(request.method==='HEAD'?undefined:data);
  } catch (error) {
    response.writeHead(error instanceof URIError ? 400 : 404); response.end('Not found');
  }
});
server.on('error',error=>{ console.error(`无法启动本地课程服务：${error.message}`); process.exitCode=1; });
server.listen(port,'127.0.0.1',()=>console.log(`Swift Native Lab: http://127.0.0.1:${port} (Ctrl+C 停止)`));
