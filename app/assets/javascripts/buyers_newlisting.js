var separator = "&";

function getNewUrl(old_url, new_value, field) {
  var field_length = field.length
  var old_val = old_url.substring(old_url.indexOf(field) + field_length,
    old_url.indexOf(separator));
  var first_substr = old_url.substring(0,old_url.indexOf(field) + field_length);
  var second_substr = old_url.substring(old_url.indexOf(field) + field_length);
  var second_substr_without_val = second_substr.substring(
      second_substr.indexOf(separator));
  return first_substr + new_value + second_substr_without_val;
}

// when any of the fields change, replace the old value with the new value
$('#site').change(function() {
  var old_url = $('#new_buyer').attr('href');
  var new_value = this.value;
  var field = "site=";
  $('#new_buyer').attr('href', getNewUrl(old_url, new_value, field));
});

$('#link').chang(function() {
  var old_url = $('#new_buyer').attr('href');
  var new_value = this.value;
  var field = "link=";
  $('#new_buyer').attr('href', getNewUrl(old_url, new_value, field));
})

