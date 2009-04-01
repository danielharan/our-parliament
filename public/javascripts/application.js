jQuery(function() {
  $("#home_search").blur(function() {
    var currentValue = $(this).val();
    var newValue = currentValue;
    if (currentValue == "") {
      newValue = "Enter a Postal Code or Keywords";
    }
    $(this).val(newValue);
  });

  $("#home_search").focus(function() {
      var currentValue = $(this).val();
      var newValue = currentValue;
      if (currentValue == "Enter a Postal Code or Keywords") {
        newValue = "";
      }
      $(this).val(newValue);
  });
});
