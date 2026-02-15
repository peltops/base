// Custom JavaScript for Keycloak theme

// Add any custom client-side functionality here
document.addEventListener('DOMContentLoaded', function() {
    console.log('Custom Keycloak theme loaded');
    
    // Example: Add password strength indicator
    const passwordInput = document.getElementById('password');
    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            // Add password strength logic here if needed
        });
    }
});
