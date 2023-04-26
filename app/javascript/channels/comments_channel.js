import consumer from "./consumer"

consumer.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id}, {
  received(data) {

    let id = data.commentable_id;
    
    if (data.commentable_type === 'Question') {
      $(`#question-comment-${id}`).append(data['partial']);
    } else {
      $(`#answer-comment-${id}`).append(data['partial']);
    }
  }
});
