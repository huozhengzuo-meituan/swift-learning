/* 本地增强：课程正文不依赖脚本；浏览器存储只记录自报练习，不代表能力认证。 */
(() => {
  'use strict';
  const storageKey = 'swift-learning-progress-v1';
  let progress = {};
  let storageAvailable = true;
  function warnStorage() {
    storageAvailable = false;
    if (document.querySelector('.storage-warning')) return;
    const message = document.createElement('p');
    message.className = 'storage-warning';
    message.setAttribute('role', 'status');
    message.textContent = '此浏览器未允许保存进度，本次勾选仅在当前页面有效。可用下方导出按钮保存，或在 NOTES.md 手动记录。';
    document.querySelector('main')?.prepend(message);
  }
  try {
    const saved = JSON.parse(localStorage.getItem(storageKey) || '{}');
    if (saved && typeof saved === 'object' && !Array.isArray(saved)) {
      for (const [id, value] of Object.entries(saved)) {
        if (/^\d+$/.test(id) && Number(id) >= 1 && Number(id) <= 44 && typeof value === 'string' && !Number.isNaN(Date.parse(value))) progress[id] = value;
      }
    }
  } catch { warnStorage(); }
  function renderProgress() {
    const count = Object.keys(progress).length;
    document.querySelectorAll('[data-progress-count]').forEach(el => { el.textContent = `${count} / 44 课已练习`; });
    document.querySelectorAll('progress').forEach(el => { el.value = count; });
    document.querySelectorAll('[data-lesson-card]').forEach(card => {
      const badge = card.querySelector('[data-status]');
      if (badge) badge.textContent = progress[card.dataset.lessonCard] ? '已练习' : '待学习';
    });
    const finish = document.querySelector('[data-complete]');
    if (finish) {
      const done = Boolean(progress[finish.dataset.complete]);
      finish.textContent = done ? '撤销本课练习记录' : '我已独立完成练习';
      finish.setAttribute('aria-pressed', String(done));
    }
  }
  document.querySelector('[data-complete]')?.addEventListener('click', event => {
    const id = event.currentTarget.dataset.complete;
    if (progress[id]) delete progress[id]; else progress[id] = new Date().toISOString();
    if (storageAvailable) { try { localStorage.setItem(storageKey, JSON.stringify(progress)); } catch { warnStorage(); } }
    renderProgress();
  });
  document.querySelector('[data-export]')?.addEventListener('click', () => {
    const blob = new Blob([JSON.stringify({course:'swift-learning',exportedAt:new Date().toISOString(),practiced:progress},null,2)], {type:'application/json'});
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a'); link.href = url; link.download = 'swift-learning-progress.json'; link.click();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  });
  document.querySelectorAll('[data-quiz]').forEach(form => {
    form.addEventListener('submit', event => {
      event.preventDefault();
      const selected = form.querySelector('input:checked');
      const output = form.querySelector('.feedback');
      if (!selected) { output.textContent = '请先选择一个答案。'; return; }
      const correct = selected.value === form.dataset.answer;
      output.textContent = `${correct ? '回答正确。' : '再想一想。'} ${form.dataset.explanation}`;
    });
  });
  let activeModule = 'all';
  const search = document.querySelector('[data-search]');
  function filter() {
    const query = (search?.value || '').trim().toLocaleLowerCase();
    let count = 0;
    document.querySelectorAll('[data-lesson-card]').forEach(card => {
      const visible = (activeModule === 'all' || card.dataset.module === activeModule) && card.textContent.toLocaleLowerCase().includes(query);
      card.hidden = !visible; if (visible) count++;
    });
    document.querySelectorAll('[data-module-section]').forEach(section => { section.hidden = ![...section.querySelectorAll('[data-lesson-card]')].some(card => !card.hidden); });
    const result = document.querySelector('[data-search-result]');
    if (result) result.textContent = `显示 ${count} 节课程`;
  }
  search?.addEventListener('input', filter);
  document.querySelectorAll('[data-filter]').forEach(button => button.addEventListener('click', () => {
    activeModule = button.dataset.filter;
    document.querySelectorAll('[data-filter]').forEach(other => other.setAttribute('aria-pressed',String(other === button)));
    filter();
  }));
  renderProgress();
})();
