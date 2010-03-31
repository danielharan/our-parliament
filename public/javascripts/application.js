jQuery(function() {
  $("#home_search").blur(function() {
    var currentValue = $(this).val();
    var newValue = currentValue;
    if (currentValue == "" || currentValue == "Enter a Keyword") {
      newValue = "Enter a  Keyword";
    }
    $(this).val(newValue);
  });

  $("#home_search").focus(function() {
      var currentValue = $(this).val();
      var newValue = currentValue;
      if (currentValue == "Enter a Keyword") {
        newValue = "";
      }
      $(this).val(newValue);
  });
});
