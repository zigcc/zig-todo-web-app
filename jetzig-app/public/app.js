async function onWindowLoad() {
  console.log('onWindowLoad');
  const content = document.getElementById('todo-content');
  const title = document.getElementById('todo-title');
  document.getElementById('btn-submit').addEventListener('click', async () => {
    console.log('btn-submit clicked');
    const body = content.value;
    const id = title.value;
    console.log(body, id);
    const resp = await fetch('/api/todos', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ content: body, id: id }),
    });
    content.value = '';
    title.value = '';
    if (!resp.ok) {
      const msg = await resp.text();
      alert(`Failed to create todo, msg:${msg}`);
      return;
    }
    const r = await resp.json();
    alert(`Todo created successfully, title:${r.id}`);
    localStorage.setItem(r.id, '');
  });

  const search_title = document.getElementById('search-title');
  const search_result = document.getElementById('search-result');
  document.getElementById('btn-search').addEventListener('click', async () => {
    console.log('btn-search clicked');
    const value = search_title.value;
    const resp = await fetch(`/api/todos/${value}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (!resp.ok) {
      const msg = await resp.text();
      alert(`Failed to fetch todo, msg:${msg}`);
      return;
    }
    const r = await resp.json();
    if(r.found) {
      search_result.innerHTML = r.data.content;
    } else {
      search_result.innerHTML = 'Todo not found';
    }
  });

}

window.onload = onWindowLoad;
