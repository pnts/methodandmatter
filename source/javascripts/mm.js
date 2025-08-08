// This is where it all goes :)

// Essay Category Filtering
document.addEventListener('DOMContentLoaded', function() {
  var filterButtons = document.querySelectorAll('.filter-btn');
  var essayItems = document.querySelectorAll('.essay-item');
  
  // Handle filter button clicks
  for (var i = 0; i < filterButtons.length; i++) {
    filterButtons[i].addEventListener('click', function() {
      var category = this.dataset.category;
      
      // Update active button
      for (var j = 0; j < filterButtons.length; j++) {
        filterButtons[j].classList.remove('active');
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
      var targetButton = document.querySelector('[data-category="' + category + '"]');
      if (targetButton) {
        for (var i = 0; i < filterButtons.length; i++) {
          filterButtons[i].classList.remove('active');
        }
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
