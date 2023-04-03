$(document).on('turbolinks:load', function() {
  $('.vote').on('ajax:success', function (e) {
    let resource = e.detail[0];
    $(`#${resource.votable_name}-rating-${resource.votable_id}`).html(resource.rating);
  })
    .on('ajax:error', function (e) {
      let errors = e.detail[0];
      $.each(errors, function (index, value) {
        $('.votes-errors').append('<p>' + value + '</p>');
      })
    })
});
