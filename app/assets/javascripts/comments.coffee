# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/#

$ ->
  questionId = $('.answers').data('questionId')
  console.log questionId
  str = '/questions/' + questionId + '/comments'
  console.log str

  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    console.log data
    comment = $.parseJSON(data['comment'])
    console.log comment
    $('.question-list').append(JST['templates/question-comment']({comment: comment}))

