/**
 * Smooth scrolling functionality for anchor links
 */
document.addEventListener('DOMContentLoaded', function() {
    // Get all links with hash (#) in href
    const anchorLinks = document.querySelectorAll('a[href*="#"]:not([href="#"])');
    
    // Loop through each anchor link
    anchorLinks.forEach(function(link) {
        link.addEventListener('click', function(e) {
            // Get the target href
            const href = this.getAttribute('href');
            
            // Check if the link points to an anchor on the same page
            if (href.indexOf('#') !== -1) {
                const targetPage = href.split('#')[0];
                const targetId = href.split('#')[1];
                const currentPage = window.location.pathname;
                
                // If we're already on the target page or the target page is empty (current page)
                if (targetPage === '' || currentPage.endsWith(targetPage)) {
                    e.preventDefault();
                    
                    // Find the target element
                    const targetElement = document.getElementById(targetId);
                    
                    if (targetElement) {
                        // Scroll smoothly to the target
                        window.scrollTo({
                            top: targetElement.offsetTop - 80, // Offset for header
                            behavior: 'smooth'
                        });
                    }
                }
            }
        });
    });
});
