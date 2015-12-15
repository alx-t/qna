# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/#

$ ->
  questionId = $('.answers').data('questionId')

  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    console.log comment
    $('.question-comments').append(JST['templates/question-comment']({comment: comment}))

