# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

question_ready = ->
  $('.question').bind 'ajax:success', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $('.question_votes').html("#{ j render(question/votes, question) }")

$(document).ready(question_ready)
$(document).on('page:load', question_ready)
$(document).on('page:update', question_ready)

