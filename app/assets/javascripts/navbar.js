document.addEventListener("turbolinks:load", function() {
  $(document).ready(function() {
    // Check for click events on the navbar burger icon
    $(".navbar-burger").click(function() {
        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        $(".navbar-burger").toggleClass("is-active");
        $(".navbar-menu").toggleClass("is-active");
      });

    $(".navbar-link").click(function() {
      console.log('navbar clicked!');
      $(".has-dropdown").toggleClass("is-active");
      });
    });
  });