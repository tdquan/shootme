$('.messages.index').ready(function() {
  if ($('.messages.index').length > 0) {
    var updateChat = function() {
      $.ajax({
        url: "refresh_chat",
        dataType: "script"
      });
    };

    setInterval(updateChat, 10000);
  }
});
