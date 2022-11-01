$(document).ready(function () {
  $("form").submit(function (event) {
    var formData = {
      name: $("#name").val(),
      email: $("#email").val(),
      phone: $("#phone").val(),
      desc: $("#desc").val(),
    };

    $.ajax({
      type: "POST",
      url: "https://jfe2srquo2.execute-api.ap-southeast-1.amazonaws.com/form_submit/form_submit_resource",
      data: JSON.stringify(formData),
      dataType: "json",
      contentType: "application/json; charset=utf-8",
      crossDomain: "true",
      encode: true,
      success: function () {
        alert("Successful");
        document.getElementById("contact-form").reset();
    location.reload();
      },
      error: function () {
        alert("unsuccessful");
      }
    }).done(function (data) {
      console.log(data);
    });

    event.preventDefault();
  });
});
