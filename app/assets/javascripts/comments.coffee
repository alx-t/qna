# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/#

$ ->
  $('form#new_comment').bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    for value in errors
      $(this).before '<p class="error">' + value + '</p>'

  questionId = $('.answers').data('questionId')
  
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    $('p').remove('.error')
    comment = $.parseJSON(data['comment'])
    if comment.commentable_type == 'Question'
      $('.question-comments-list').append(JST['templates/question-comment']({comment: comment}))
      $('#comment_body').val('')
    if comment.commentable_type == 'Answer'
      $('.answer-comments-list').append(JST['templates/question-comment']({comment: comment}))
      $('.answer-new-comment #comment_body').val('')

