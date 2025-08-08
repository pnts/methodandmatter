// This is where it all goes :)

// Essay Category Filtering
document.addEventListener('DOMContentLoaded', function() {
  const filterButtons = document.querySelectorAll('.filter-btn');
  const essayItems = document.querySelectorAll('.essay-item');
  
  // Handle filter button clicks
  filterButtons.forEach(button => {
    button.addEventListener('click', function() {
      const category = this.dataset.category;
      
      // Update active button
      filterButtons.forEach(btn => btn.classList.remove('active'));
      this.classList.add('active');
      
      // Filter essays
      filterEssays(category);
      
      // Update URL hash
      if (category === 'all') {
        history.replaceState(null, null, window.location.pathname);
      } else {
        history.replaceState(null, null, '#category-' + category);
      }
    });
  });
  
  // Filter essays function
  function filterEssays(category) {
    essayItems.forEach(item => {
      if (category === 'all' || item.dataset.category === category) {
        item.style.display = 'block';
      } else {
        item.style.display = 'none';
      }
    });
  }
  
  // Handle initial URL hash
  function handleInitialHash() {
    const hash = window.location.hash;
    if (hash && hash.startsWith('#category-')) {
      const category = hash.replace('#category-', '');
      const targetButton = document.querySelector(`[data-category="${category}"]`);
      if (targetButton) {
        filterButtons.forEach(btn => btn.classList.remove('active'));
        targetButton.classList.add('active');
        filterEssays(category);
      }
    }
  }
  
  // Handle browser back/forward
  window.addEventListener('hashchange', handleInitialHash);
  
  // Initialize with URL hash if present
  handleInitialHash();
});
