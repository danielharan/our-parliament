/**
 * Written by Rob Schmitt, The Web Developer's Blog
 * http://webdeveloper.beforeseven.com/
 */

/**
 * The following variables may be adjusted
 */
var active_color = '#000'; // Colour of user provided text
var inactive_color = '#808080'; // Colour of default text

/**
 * No need to modify anything below this line
 */

jQuery(document).ready(function() {
  jQuery("input.default-value").css("color", inactive_color);
  var default_values = new Array();
  jQuery("input.default-value").focus(function() {
    if (!default_values[this.id]) {
      default_values[this.id] = this.value;
    }
    if (this.value == default_values[this.id]) {
      this.value = '';
      this.style.color = active_color;
    }
    jQuery(this).blur(function() {
      if (this.value == '') {
        this.style.color = inactive_color;
        this.value = default_values[this.id];
      }
    });
  });
});
