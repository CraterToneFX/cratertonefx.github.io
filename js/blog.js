const script = document.currentScript;
const category = script.dataset.category || null;
const limit = script.dataset.limit
  ? parseInt(script.dataset.limit, 10)
  : null;

const container = document.getElementById("post-list");

fetch("/data/posts.json")
  .then(res => res.json())
  .then(posts => {
    let filtered = posts
      .sort((a, b) => new Date(b.date) - new Date(a.date));

    if (category) {
      filtered = filtered.filter(p => p.category === category);
    }

    if (limit) {
      filtered = filtered.slice(0, limit);
    }

    filtered.forEach(p => {
      container.innerHTML += `
        <article class="post-card">
          <h2><a href="${p.url}">${p.title}</a></h2>
          <time>${p.date}</time>
          <p>${p.excerpt}</p>
        </article>
      `;
    });
  });


