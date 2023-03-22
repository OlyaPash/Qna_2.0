$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    console.log(questionId);
    $('form#edit-question-' + questionId).removeClass('hidden');
  })

  return loadGists()
});

window.loadGists = function () {
  $('.gist').each(function () {
    loadGist($(this));
  })
}

window.loadGist = function ($gist) {
  let callbackName, script, html;
  callbackName = 'c' + Math.random().toString(36).substring(7);

  window[callbackName] = function (gistData) {
    delete window[callbackName];
    html = '<link rel="stylesheet" href="' + encodeURI(gistData.stylesheet) + '"></link>';
    html += gistData.div;
    $gist.html(html);
    return script.parentNode.removeChild(script);
  };

  script = document.createElement('script');
  script.setAttribute('src', [
    $gist.data('src'), $.param({
      callback: callbackName,
      file: $gist.data('file') || ''
    })
  ].join('?'));

  document.body.appendChild(script);
};
