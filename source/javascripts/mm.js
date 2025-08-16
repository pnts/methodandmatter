// This is where it all goes :)

// Essay Category Filtering
document.addEventListener('DOMContentLoaded', function() {
  var filterLinks = document.querySelectorAll('.filter-link');
  var essayItems = document.querySelectorAll('.essay-item');
  
  // Handle filter link clicks
  for (var i = 0; i < filterLinks.length; i++) {
    filterLinks[i].addEventListener('click', function(e) {
      e.preventDefault(); // Prevent default anchor behavior
      var category = this.dataset.category;
      
      // Update active link
      for (var j = 0; j < filterLinks.length; j++) {
        filterLinks[j].classList.remove('active');
      }
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
  }
  
  // Filter essays function
  function filterEssays(category) {
    for (var i = 0; i < essayItems.length; i++) {
      if (category === 'all' || essayItems[i].dataset.category === category) {
        essayItems[i].style.display = 'block';
      } else {
        essayItems[i].style.display = 'none';
      }
    }
  }
  
  // Handle initial URL hash
  function handleInitialHash() {
    var hash = window.location.hash;
    if (hash && hash.indexOf('#category-') === 0) {
      var category = hash.replace('#category-', '');
      var targetLink = document.querySelector('[data-category="' + category + '"]');
      if (targetLink) {
        for (var i = 0; i < filterLinks.length; i++) {
          filterLinks[i].classList.remove('active');
        }
        targetLink.classList.add('active');
        filterEssays(category);
      }
    }
  }
  
  // Handle browser back/forward
  window.addEventListener('hashchange', handleInitialHash);
  
  // Initialize with URL hash if present
  handleInitialHash();
});
