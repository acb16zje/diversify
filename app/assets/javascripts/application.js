//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require flash_message
//= require visibility_map

// navbutton adds the change class to divs in the
// navbar to allow their styles to change.
function navButton(x) {
  x.classList.toggle("change");
  document.getElementById("navigation").classList.toggle('change');
}
