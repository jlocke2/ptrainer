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







    select: (startDate, endDate, allDay, jsEvent, view ) ->
      if allDay
             $("#calendar").fullCalendar("changeView", "agendaDay").fullCalendar "gotoDate", startDate
      else
         newForm.display({
          start_at: new Date(startDate.getTime()),
          end_at: new Date(endDate.getTime()),
          allDay: allDay
        });
        
        
      return

    eventDrop: (event, dayDelta, minuteDelta, allDay) ->
      console.log('saving on drop')
      moveTime event, dayDelta, minuteDelta, allDay
      return

    eventResize: (event, dayDelta, minuteDelta, allDay) ->
      console.log('saving on resize')
      resizeTime event, dayDelta, minuteDelta, allDay
      return


    eventClick: (event, jsEvent, view) ->
      showEventDetails event



   
          
 



    showEventDetails = (event) ->
     

      
      $("#event_desc_dialog").html ""
      $event_description = $("<div />").html(event.description).attr("id", "edit_appointment_description")
      $event_actions = $("<div />").attr("id", "event_actions")
      $edit_event = $("<span />").attr("id", "edit_event").html("<a href = 'javascript:void(0);' onclick ='editIt(" + event.id + ")'>Edit</a>")
      $view_event = $("<span />").attr("id", "view_event").html("<a href = 'javascript:void(0);' onclick ='viewIt(" + event.id + ")'>View Workout For This Appointment</a>")
      $add_workout = $("<span />").attr("id", "add_workout").html("<a href = 'javascript:void(0);' onclick ='newWork(" + event.id + ")'>Add Workout To This Appointment</a>")
      $delete_event = $("<span />").attr("id", "delete_event")
      if event.recurring
        title = event.title + "(Recurring)"
        
        # Cannot be refactored as of now, the event bubbling of the eventClick of the fullCalendar is the culprit
        $delete_event.html "&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.deleteIt(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>"
        $delete_event.append "&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.deleteIt(" + event.id + ", " + true + ")'>Delete All In Series</a>"
        $delete_event.append "&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.deleteIt(" + event.id + ", \"future\")'>Delete All Future Events</a>"
      else
        title = event.title
        $delete_event.html "<a href = 'javascript:void(0);' onclick ='deleteIt(" + event.id + ", " + false + ")'>Delete</a>"

      $event_actions.append($edit_event).append(" | ").append $delete_event.append(" <br /> "). append $add_workout. append(" <br /> ").append $view_event
      $("#event_desc_dialog").append($event_description).append $event_actions
      $("#event_desc_dialog").dialog
        title: title
        modal: true
        width: 500
        close: (event, ui) ->
          $("#event_desc_dialog").html ""
          $("#event_desc_dialog").dialog "destroy"

       
            
        

      return


      
    $("#create_event_dialog, #event_desc_dialog").on "submit", "#new_appointment", (event) ->
      event.preventDefault()
      $.ajax
        type: "POST"
        data: $(this).serialize()
        url: $(this).attr("action")
        success: refetch_events_and_close_dialog
        

    $("#create_event_dialog, #event_desc_dialog").on "submit", ".edit_appointment", (event) ->
      event.preventDefault()
      $.ajax
        type: "POST"
        data: $(this).serialize()
        url: $(this).attr("action")
        success: refetch_events_and_close_dialog
        




    @editIt = (event_id) ->
        $.ajax
          url: "/appointments/" + event_id + "/edit"

          success: (data) ->
            $("#edit_appointment_description").html data["form"]
        return

    @viewIt = (event_id) ->
        $.redirect "workouts/trans",
          id: event_id
        , "GET"
        return

    @deleteIt = (event_id, delete_all) ->
      $.ajax
        dataType: "script"
        type: "delete"
        url: "/appointments/" + event_id
        success: refetch_events_and_close_dialog
      return

    @newWork = (event_id) ->
        $.redirect "workouts/new",
          id: event_id
        , "GET"
          
        return

    refetch_events_and_close_dialog = ->
        $("#calendar").fullCalendar "refetchEvents"
        $(".dialog:visible").dialog "destroy"
        return
    

    
    

    newForm = display: (options) ->
        options = {}  if typeof (options) is "undefined"
        $("#event_form").trigger "reset"
        startTime = options["start_at"] or new Date()
        endTime = options["end_at"] or new Date(startTime.getTime())
        endTime.setMinutes startTime.getMinutes() + 15  if startTime.getTime() is endTime.getTime()
        setTime "#appointment_start_at", startTime
        setTime "#appointment_end_at", endTime
      
      # FullcalendarEngine.Form.fetch()
        $("#create_event_dialog").dialog
          title: "New Event"
          modal: true
          width: 500
          close: (event, ui) ->
            $("#create_event_dialog").dialog "destroy"
            return

        return

      fetch: ->
        $.ajax
          type: "get"
          dataType: "script"
          async: true
          url: "/appointments/new"

        return

      setTime = (type, time) ->
        $year = $(type + "_1i")
        $month = $(type + "_2i")
        $day = $(type + "_3i")
        $hour = $(type + "_4i")
        $minute = $(type + "_5i")
        $year.val time.getFullYear()
        $month.prop "selectedIndex", time.getMonth()
        $day.prop "selectedIndex", time.getDate() - 1
        $hour.prop "selectedIndex", time.getHours()
        $minute.prop "selectedIndex", time.getMinutes()
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

  

