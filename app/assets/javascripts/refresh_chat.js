$('.messages.index').ready(function() {
  var updateChat = function() {
    $.ajax({
      url: "refresh_chat",
      dataType: "script"
    });
  };

  setInterval(updateChat, 5000);
});
