# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.question-votes').bind 'ajax:success', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $('.question-votes').html(JST["templates/votes"]({object: question}))

