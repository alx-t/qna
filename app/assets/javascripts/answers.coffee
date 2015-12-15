# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.answers').on 'click', '.edit-answer-link', (e) -> 
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.answer-votes').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(".answer-votes#answer_#{answer.id}").html(JST["templates/answer-vote"]({object: answer}))
    $('#answer_body').val('')

  questionId = $('.answers').data('questionId')
  currentUserId = $('.main').data('currentUserId')

  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    $('.answers').append(JST['templates/answer']({answer: answer, current_user_id: currentUserId}))
    $('#answer_body').val('')
    
