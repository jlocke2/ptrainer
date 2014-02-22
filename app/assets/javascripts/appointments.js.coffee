# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  date = new Date()
  d = date.getDate()
  m = date.getMonth()
  y = date.getFullYear()

  

  $("#calendar").fullCalendar
    header:
      left: "prev,next today"
      center: "title"
      right: "month,agendaWeek,agendaDay"

    editable: true
    selectable: true
    allDaySlot: false
    allDayDefault: false
    events: "/appointments.json"


    dayClick: (date, allDay, jsEvent, view) ->
      if allDay
             $("#calendar").fullCalendar("changeView", "agendaDay").fullCalendar "gotoDate", date
      else
         eventRender: (event,element) ->
           
        
        
      return
   

    eventDrop: (event, dayDelta, minuteDelta, allDay) ->
      console.log('saving on drop')
      moveTime event, dayDelta, minuteDelta, allDay
      return

    eventResize: (event, dayDelta, minuteDelta, allDay) ->
      console.log('saving on resize')
      resizeTime event, dayDelta, minuteDelta, allDay
      return
        

      return

    moveTime = (event, dayDelta, minuteDelta, allDay) ->
      $.ajax
        data: "title=" + event.name + "&day_delta=" + dayDelta + "&minute_delta=" + minuteDelta
        dataType: "script"
        type: "post"
        url: '/appointments/' + event.id + '/move'

        

    resizeTime = (event, dayDelta, minuteDelta, allDay) ->
      $.ajax
        data: "title=" + event.name + "&day_delta=" + dayDelta + "&minute_delta=" + minuteDelta
        dataType: "script"
        type: "post"
        url: '/appointments/' + event.id + '/resize'
  return
