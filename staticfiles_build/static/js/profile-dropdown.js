/**
 * Profile dropdown menu functionality
 */
document.addEventListener('DOMContentLoaded', function() {
    const profileLink = document.querySelector('.user-profile-link');
    const profileDropdown = document.querySelector('.profile-dropdown');
    
    if (profileLink && profileDropdown) {
        // Toggle dropdown on click
        profileLink.addEventListener('click', function(e) {
            e.preventDefault(); // Prevent the default link behavior
            
            // Toggle dropdown visibility
            if (profileDropdown.style.display === 'block') {
                profileDropdown.style.display = 'none';
            } else {
                profileDropdown.style.display = 'block';
                profileDropdown.style.animation = 'fadeInUp 0.3s ease forwards';
            }
        });
        
        // Close the dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!profileLink.contains(e.target) && !profileDropdown.contains(e.target)) {
                profileDropdown.style.display = 'none';
            }
        });
    }
});
