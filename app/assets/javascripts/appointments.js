$(document).ready(function() {
  var d, date, m, moveTime, newForm, refetch_events_and_close_dialog, resizeTime, setTime, showEventDetails, y;
  date = new Date();
  d = date.getDate();
  m = date.getMonth();
  y = date.getFullYear();
  $("#calendar").fullCalendar({
    header: {
      left: "prev,next today",
      center: "title",
      right: "month,agendaWeek,agendaDay"
    },
    editable: true,
    selectable: true,
    allDayDefault: false,
    events: "/appointments.json",
    select: function(start, end, startDate, endDate, allDay, jsEvent, view) {
        viewer = $('#calendar').fullCalendar('getView');
        if (viewer.name == "month") {
          console.log(viewer);
        $('.fc-event').popover('destroy');
        $("#calendar").fullCalendar("changeView", "agendaDay").fullCalendar("gotoDate", start);
      } else {
         console.log(viewer);
         console.log(start);
         console.log(end);
         $.when($.ajax({
                      url: "/appointments/newdata",
                      success: function(data) {
                        $("#new_appointment_description2").html(data["form"]);
                         if ($('#datetimepicker4').length){

                          $('body').off('click', '.multiselect')
                          $('body').on('click', '.multiselect', function(e){
                            $(this).parent().toggleClass('open');
                            e.stopPropagation();
                          });
                          


           $('#datetimepicker4').clockpicker({
           default: "now",
           twelvehour: true,
           donetext: "Done",
           afterDone: function() {
                            var timeplus = $('#datetimepicker4').val();
            
                                  var ar88 = timeplus.split(/:| /g);
                                  if (ar88[0] == 12) {
                                    ar88[0] = Number(ar88[0])-11
                                  } else {
                                   ar88[0] =  Number(ar88[0])+1
                                  };
                                  if (ar88[0] == 12) {
                                    if (ar88[2] == "PM") {
                                    ar88[2] = "AM"
                                    } else {
                                      ar88[2] = "PM"
                                    };
                                  };
                                  
                                  var timeplus2 = ar88.join(" ");
                                  var timeplus3 = timeplus2.replace(" ", ":");
                                  $('#datetimepicker5').val(timeplus3);
                                              }
                                });
                                
                         


                         
                                $('#datetimepicker5').clockpicker({
                                  
                                 default: "now",
                                 twelvehour: true,
                                 donetext: "Done",

                                });

                                
                        


                          
                                $('#datetimepicker6').datepicker({
                                  orientation: "top auto",
                                   autoclose: true,
                                   todayBtn: true,
                                   todayHighlight: true,
                                })
                                .on('show', function(e) {
                              var $popup = $('.datepicker');
                              $popup.click(function () { return false; });
                          });;




                              starts = start.toString();
                                  var splits = starts.split(" ");
                                  var timesplit = splits[4].split(":");
                                  var startmon = splits[1]
                                  switch (startmon) {
                                      case "Jan":
                                          newmon = "01";
                                          break;
                                      case "Feb":
                                          newmon = "02";
                                          break;
                                      case "Mar":
                                          newmon = "03";
                                          break;
                                      case "Apr":
                                          newmon = "04";
                                          break;
                                      case "May":
                                          newmon = "05";
                                          break;
                                      case "Jun":
                                          newmon = "06";
                                          break;
                                      case "Jul":
                                          newmon = "07";
                                          break;
                                      case "Aug":
                                          newmon = "08";
                                          break;
                                      case "Sep":
                                          newmon = "09";
                                          break;
                                      case "Oct":
                                          newmon = "10";
                                          break;
                                      case "Nov":
                                          newmon = "11";
                                          break;
                                      case "Dec":
                                          newmon = "12";
                                          break;
                                        }
                                  if (timesplit[0] >= 13) {
                                          timesplit[0] = Number(timesplit[0])-12
                                          var fintime = "PM"
                                        } else if (timesplit[0] == 0){
                                          timesplit[0] = Number(timesplit[0])+12
                                          var fintime = "AM"
                                        } else if (timesplit[0] == 12){
                                          var fintime = "PM"
                                        } else {
                                         var fintime = "AM"
                                        };

                              ends = end.toString();
                                  var splitend = ends.split(" ");
                                  var timesplitend = splitend[4].split(":");
                                  if (timesplitend[0] >= 13) {
                                          timesplitend[0] = Number(timesplitend[0])-12
                                          var fintimeend = "PM"
                                        } else {
                                         var fintimeend = "AM"
                                        };




                            $('#datetimepicker4').val(timesplit[0] + ":" + timesplit[1] + " " + fintime);
                            $('#datetimepicker5').val(timesplitend[0] + ":" + timesplitend[1] + " " + fintimeend);
                            $('#datetimepicker6').val(newmon + "/" + splits[2] + "/" + splits[3]);
                                  console.log("settime");
                                  $('.multisel').multiselect({
                                          maxHeight: 200,
                                          enableFiltering: true,
                                          filterBehavior: 'text',
                                          enableCaseInsensitiveFiltering: true,
                                          filterPlaceholder: 'Search',
                                      });
                                   $(document).ready(function(){
                                    $('.multisel').siblings('.btn-group').children('.multiselect').css('width', '153px').css('left', '14px');
                                    
                                  });

                                } else {
                                  console.log('not ready yet');
                                }
                    }})).then( finishform());
        
       

      


function finishform() {
          $('.fc-cell-overlay').popover('destroy');
        $('.fc-event').popover('destroy');
        $('.fc-cell-overlay').popover({
          title: "Create New Appointment",
          width: 500,
          animation: false,
          trigger: 'manual',
          container: 'body',
          placement: 'top',
          content: "<div id='new_appointment_description2'></div>",
          html: true,
          template: '<div class="popover" style="width:500px" role="tooltip"><h3 class="popover-title" style="text-align:center;"></h3><div class="popover-content"></div></div>'
        }).popover('show');





settime();

}

               
function settime() {
 
          

}





        
      };
    },
    viewDestroy: function(view) {
      $('.fc-event').popover('destroy');
      $('.fc-cell-overlay').popover('destroy');
      

    },
    viewRender: function(view) { /*
      $(".fc-widget-content").popover({
          title: "Creat New Appointment",
          width: 500,
          trigger: 'click',
          container: 'body',
          placement: 'top',
          content: "test",
          html: true,
          template: '<div class="popover" style="width:500px" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
        }); */

    },
    eventDrop: function(event, dayDelta, minuteDelta, allDay) {
      console.log('saving on drop');
      moveTime(event, dayDelta, minuteDelta, allDay);
    },
    eventResize: function(event, dayDelta, minuteDelta, allDay) {
      console.log('saving on resize');
      resizeTime(event, dayDelta, minuteDelta, allDay);
    },
    eventClick: function(event, jsEvent, view) {
       $('.fc-event').popover('destroy');
       $('.fc-cell-overlay').popover('destroy');
      showEventDetails(event)
      
      ;
      $(this).popover('show');
    }
  }, showEventDetails = function(event) {
    var $delete_event, $edit_event, $event_actions, $event_description, $view_event, title;
    $("#event_desc_dialog").html("");
    $event_description = $("<div />").html(event.description).attr("id", "edit_appointment_description");
    $event_actions = $("<div />").attr("id", "event_actions");
    $edit_event = $("<span />").attr("id", "edit_event").html("<a class='btn mybtn btn-large btn-primary' style='width: 100%;' href = 'javascript:void(0);' onclick ='editIt(" + event.id + ")'>Edit Appointment</a>");
    $view_event = $("<span />").attr("id", "view_event").html("<a class='btn mybtn btn-large btn-success' style='width: 100%;' href = 'javascript:void(0);' onclick ='viewIt(" + event.id + ")'>View Workout</a>");
    $delete_event = $("<span />").attr("id", "delete_event");
    if (event.recurring) {
      title = event.title + "(Recurring)";
      $delete_event.html("&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.deleteIt(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>");
      $delete_event.append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.deleteIt(" + event.id + ", " + true + ")'>Delete All In Series</a>");
      $delete_event.append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.deleteIt(" + event.id + ", \"future\")'>Delete All Future Events</a>");
    } else {
      title = event.title;
      starts = event.start.toString();
      var splits = starts.split(" ");
      var timesplit = splits[4].split(":");
      if (timesplit[0] >= 13) {
              timesplit[0] = Number(timesplit[0])-12
              var fintime = "PM"
            } else if (timesplit[0] == 0) {
              timesplit[0] = Number(timesplit[0])+12
              var fintime = "AM"
            }else {
             var fintime = "AM"
            };
      if (event.allp instanceof Array){allp = event.allp.join(", ")}else{allp = event.allp};
      $delete_event.html("<a class='btn mybtn btn-large btn-danger' style='width: 100%;' href = 'javascript:void(0);' onclick ='deleteIt(" + event.id + ", " + false + ")'>Delete Appointment</a>");
    }
    $event_actions.append($view_event).append("<br />").append("<br />").append($edit_event).append("<br />").append("<br />").append($delete_event);
    $("#event_desc_dialog").append($event_description).append($event_actions);
    $(".fc-event").popover({
      title: "Appointment with " + title,
      width: 500,
      animation: false,
      trigger: 'manual',
      container: 'body',
      placement: 'top',
      content: "<div id='edit_appointment_description2'></div><div id='hidepop'><div class='field'> When: <span class='date'>" + splits[0] + " " + splits[1] + " " + splits[2] + " at " + timesplit[0] + ":" + timesplit[1] + " " + fintime +
      "</span></div> <div class='field' style='margin-bottom:-5px;'> Who: <span class='who'>" + allp + "</span></div>" + "<br />" + 
      "<a class='btn-sm mybtn btn-small btn-primary' style='width: 30%; margin-right: 15px; padding-left: 10px; padding-right: 10px; margin-left: 3px;' href = 'javascript:void(0);' onclick ='editIt(" + event.id + ")'>Edit Time</a>" +
      "<a class='btn-sm mybtn btn-small btn-success' style='width: 96px; margin-right: 15px; padding-left: 12px; padding-right: 12px;' href = 'javascript:void(0);' onclick ='viewIt(" + event.id + ")'>Workout</a>" + 
      "<a class='btn-sm mybtn btn-small btn-danger' style='width: 30%; padding-left: 17px; padding-right: 17px;' href = 'javascript:void(0);' onclick ='deleteIt(" + event.id + ", " + false + ")'>Delete</a></div>",
      html: true,
      template: '<div class="popover" style="width:500px" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
    });





  }, 
  $("#create_event_dialog, #event_desc_dialog").on("submit", "#new_appointment2", function(event) {
    event.preventDefault();
    return $.ajax({
      type: "POST",
      data: $(this).serialize(),
      url: $(this).attr("action"),
      success: function(){
      refetch_events_and_close_dialog;
      console.log('aptbuilt');
      }

    });
  }), $("#create_event_dialog, #event_desc_dialog").on("submit", ".edit_appointment", function(event) {
    event.preventDefault();
    return $.ajax({
      type: "POST",
      data: $(this).serialize(),
      url: $(this).attr("action"),
      success: function(){
        refetch_events_and_close_dialog;
        console.log('jseditwork')
      }
    });
  }), this.editIt = function(event_id) {
    $.ajax({
      url: "/appointments/" + event_id + "/editordata",
      success: function(data) {
        console.log(data["apt"]);
        console.log(data["id"]);
        $("#edit_appointment_description2").html(data["form"]);



        if ($('#datetimepicker7').length){

                          $('body').off('click', '.multiselect')
                          $('body').on('click', '.multiselect', function(e){
                            $(this).parent().toggleClass('open');
                            e.stopPropagation();
                          });
                          


           $('#datetimepicker7').clockpicker({
           default: "now",
           twelvehour: true,
           donetext: "Done",
           afterDone: function() {
                            var timeplus = $('#datetimepicker7').val();
            
                                  var ar88 = timeplus.split(/:| /g);
                                  if (ar88[0] == 12) {
                                    ar88[0] = Number(ar88[0])-11
                                  } else {
                                   ar88[0] =  Number(ar88[0])+1
                                  };
                                  if (ar88[0] == 12) {
                                    if (ar88[2] == "PM") {
                                    ar88[2] = "AM"
                                    } else {
                                      ar88[2] = "PM"
                                    };
                                  };
                                  
                                  var timeplus2 = ar88.join(" ");
                                  var timeplus3 = timeplus2.replace(" ", ":");
                                  $('#datetimepicker8').val(timeplus3);
                                              }
                                });
                                
                         


                         
                                $('#datetimepicker8').clockpicker({
                                  
                                 default: "now",
                                 twelvehour: true,
                                 donetext: "Done",

                                });

                                
                        


                          
                                $('#datetimepicker9').datepicker({
                                  orientation: "top auto",
                                   autoclose: true,
                                   todayBtn: true,
                                   todayHighlight: true,
                                })
                                .on('show', function(e) {
                              var $popup = $('.datepicker');
                              $popup.click(function () { return false; });
                          });;

                      $('.multisel2').siblings('.btn-group').children('.multiselect').css('width', '182px').css('left', '-15px');
                      $('#hidepop').css('display', 'none');
                      $('.arrow').css('display', 'none');

                      $('.multisel2').multiselect('select', data["id"]);

                      var startedit = data["apt"].start.toString();

                                  var splitsedit = startedit.split(" ");
                                  var timesplitedit = splitsedit[4].split(":");
                                  var startmonedit = splitsedit[2]
                                  switch (startmonedit) {
                                      case "Jan":
                                          newmonedit = "01";
                                          break;
                                      case "Feb":
                                          newmonedit = "02";
                                          break;
                                      case "Mar":
                                          newmonedit = "03";
                                          break;
                                      case "Apr":
                                          newmonedit = "04";
                                          break;
                                      case "May":
                                          newmonedit = "05";
                                          break;
                                      case "Jun":
                                          newmonedit = "06";
                                          break;
                                      case "Jul":
                                          newmonedit = "07";
                                          break;
                                      case "Aug":
                                          newmonedit = "08";
                                          break;
                                      case "Sep":
                                          newmonedit = "09";
                                          break;
                                      case "Oct":
                                          newmonedit = "10";
                                          break;
                                      case "Nov":
                                          newmonedit = "11";
                                          break;
                                      case "Dec":
                                          newmonedit = "12";
                                          break;
                                        }
                                  if (timesplitedit[0] >= 13) {
                                          timesplitedit[0] = Number(timesplitedit[0])-12
                                          var fintimeedit = "PM"
                                        } else if (timesplitedit[0] == 0){
                                          timesplitedit[0] = Number(timesplitedit[0])+12
                                          var fintimeedit = "AM"
                                        } else if (timesplitedit[0] == 12){
                                          var fintimeedit = "PM"
                                        } else {
                                         var fintimeedit = "AM"
                                        };


                                var endedit = data["apt"].end.toString();
                                  var splitendedit = endedit.split(" ");
                                  var timesplitendedit = splitendedit[4].split(":");
                                  if (timesplitendedit[0] >= 13) {
                                          timesplitendedit[0] = Number(timesplitendedit[0])-12
                                          var fintimeendedit = "PM"
                                        } else {
                                         var fintimeendedit = "AM"
                                        };



                            $('#datetimepicker7').val(timesplitedit[0] + ":" + timesplitedit[1] + " " + fintimeendedit);
                            $('#datetimepicker8').val(timesplitendedit[0] + ":" + timesplitendedit[1] + " " + fintimeendedit);
                            $('#datetimepicker9').val(newmonedit + "/" + splitsedit[1] + "/" + splitsedit[3]);





                            $('body').on('submit','#edit_appointment_' + data["apt"].id, function(event){
                                  event.preventDefault;

                                  var val8 = $('#datetimepicker9').val();
                                  var ar1 = val8.split("/");
                                  var it1 = ar1[0];
                                  var it2 = ar1[1];
                                  var it3 = ar1[2];
                                  $("select#appointment_start_at_1i option:selected").val(it3);
                                  $("select#appointment_end_at_1i option:selected").val(it3);
                                  $("select#appointment_start_at_2i option:selected").val(it1);
                                  $("select#appointment_end_at_2i option:selected").val(it1);
                                  $("select#appointment_start_at_3i option:selected").val(it2);
                                  $("select#appointment_end_at_3i option:selected").val(it2);


                                  var val9 = $('#datetimepicker7').val();
                                  var ar19 = val9.split(/:| /g);
                                  if (ar19[2] == "PM" && ar19[0] != 12) {
                                    ar19[0] = Number(ar19[0])+12
                                  };
                                  $("select#appointment_start_at_4i option:selected").val(ar19[0]);
                                  $("select#appointment_start_at_5i option:selected").val(ar19[1]);


                                  var val7 = $('#datetimepicker8').val();
                                  var ar17 = val7.split(/:| /g);
                                  if (ar17[2] == "PM" && ar17[0] != 12) {
                                    ar17[0] = Number(ar17[0])+12
                                  };
                                  $("select#appointment_end_at_4i option:selected").val(ar17[0]);
                                  $("select#appointment_end_at_5i option:selected").val(ar17[1]);

                                  $('#edit_appointment_' + data["apt"].id).trigger("submit.rails");
                                  $('.fc-cell-overlay').popover('destroy');
                                  $('.fc-event').popover('destroy');

                                  $("#calendar").fullCalendar("refetchEvents");



                                  return false
                                });








}


      }
    });
  }, this.viewIt = function(event_id) {
    $.redirect("workouts/trans", {
      id: event_id
    }, "GET");
  }, this.deleteIt = function(event_id, delete_all) {
    $('.fc-cell-overlay').popover('destroy');
    $('.fc-event').popover('destroy');
    $.ajax({
      dataType: "script",
      type: "delete",
      url: "/appointments/" + event_id,
      success: refetch_events_and_close_dialog
    });
  }, this.newWork = function(event_id) {
    $.redirect("workouts/new", {
      id: event_id
    }, "GET");
  }, refetch_events_and_close_dialog = function() {
    $("#calendar").fullCalendar("refetchEvents");
    $(".dialog:visible").dialog("destroy");
  }, newForm = {
    display: function(options) {
      var endTime, startTime;
      options = {};
      $("#event_form").trigger("reset");
      startTime = options["start_at"] || new Date();
      endTime = options["end_at"] || new Date(startTime.getTime());
      if (startTime.getTime() === endTime.getTime()) {
        endTime.setMinutes(startTime.getMinutes() + 15);
      }
      setTime("#appointment_start_at", startTime);
      setTime("#appointment_end_at", endTime);
      $("#create_event_dialog").dialog({
        title: "New Appointment",
        modal: false,
        width: 500,
        close: function(event, ui) {
          $("#create_event_dialog").dialog("destroy");
        }
      });
    }
  }, {
    fetch: function() {
      $.ajax({
        type: "get",
        dataType: "script",
        async: true,
        url: "/appointments/new"
      });
    }
  }, setTime = function(type, time) {
    var $day, $hour, $minute, $month, $year;
    $year = $(type + "_1i");
    $month = $(type + "_2i");
    $day = $(type + "_3i");
    $hour = $(type + "_4i");
    $minute = $(type + "_5i");
    $year.val(time.getFullYear());
    $month.prop("selectedIndex", time.getMonth());
    $day.prop("selectedIndex", time.getDate() - 1);
    $hour.prop("selectedIndex", time.getHours());
    $minute.prop("selectedIndex", time.getMinutes());
  }, moveTime = function(event, dayDelta, minuteDelta, allDay) {
    return $.ajax({
      data: "title=" + event.name + "&day_delta=" + dayDelta + "&minute_delta=" + minuteDelta,
      dataType: "script",
      type: "post",
      url: '/appointments/' + event.id + '/move'
    });
  }, resizeTime = function(event, dayDelta, minuteDelta, allDay) {
    return $.ajax({
      data: "title=" + event.name + "&day_delta=" + dayDelta + "&minute_delta=" + minuteDelta,
      dataType: "script",
      type: "post",
      url: '/appointments/' + event.id + '/resize'
    });
  });
});

$(document).ready(function()
 {

   //Handles menu drop down`enter code here`
  $('body').off('click');
  $('body').on('click', function(e){
     $('.fc-event').popover('destroy');
     $('.fc-cell-overlay').popover('destroy');
  });
  $('body').off('click', '.fc-button');
  $('body').on('click', '.fc-button', function(e){
     $('.fc-event').popover('destroy');
     $('.fc-cell-overlay').popover('destroy');
  });
  $('body').off('click', '.fc-agenda-axis');
  $('body').on('click', '.fc-agenda-axis', function(e){
     $('.fc-event').popover('destroy');
     $('.fc-cell-overlay').popover('destroy');
  });
 /* $('body').off('mouseover', '.fc-button');
  $('body').on('mouseover', '.fc-button', function(e){
    $('.fc-event-inner').popover('destroy');
  }); */
  

   
  $('body').off('click', '.popover');
  $('body').on('click', '.popover', function(e) {
       e.stopPropagation();
    });
  $('body').off('click', '.fc-widget-content');
  $('body').on('click', '.fc-widget-content', function(e) {
       e.stopPropagation();
    });
  
  $('body').off('click', '.fc-event');
  $('body').on('click', '.fc-event', function(e) {
       e.stopPropagation();
    });

  $('body').off('click', '.fc-cell-overlay');
  $('body').on('click', '.fc-cell-overlay', function(e) {
       e.stopPropagation();
    });

  $('body').off('click', '.fc-content');
  $('body').on('click', '.fc-content', function(e) {
       e.stopPropagation();
    });

  $('body').on('shown.bs.popover', '.fc-cell-overlay', function () {
  
});
     
  

 });




  $(document).ready(function(){

    $('body').on('submit','#new_appointment2', function(event){
      event.preventDefault;

      var val8 = $('#datetimepicker6').val();
      var ar1 = val8.split("/");
      var it1 = ar1[0];
      var it2 = ar1[1];
      var it3 = ar1[2];
      $("select#appointment_start_at_1i option:selected").val(it3);
      $("select#appointment_end_at_1i option:selected").val(it3);
      $("select#appointment_start_at_2i option:selected").val(it1);
      $("select#appointment_end_at_2i option:selected").val(it1);
      $("select#appointment_start_at_3i option:selected").val(it2);
      $("select#appointment_end_at_3i option:selected").val(it2);


      var val9 = $('#datetimepicker4').val();
      var ar19 = val9.split(/:| /g);
      if (ar19[2] == "PM" && ar19[0] != 12) {
        ar19[0] = Number(ar19[0])+12
      };
      $("select#appointment_start_at_4i option:selected").val(ar19[0]);
      $("select#appointment_start_at_5i option:selected").val(ar19[1]);


      var val7 = $('#datetimepicker5').val();
      var ar17 = val7.split(/:| /g);
      if (ar17[2] == "PM" && ar17[0] != 12) {
        ar17[0] = Number(ar17[0])+12
      };
      $("select#appointment_end_at_4i option:selected").val(ar17[0]);
      $("select#appointment_end_at_5i option:selected").val(ar17[1]);

      $('#new_appointment2').trigger("submit.rails");
      $('.fc-cell-overlay').popover('destroy');

      $("#calendar").fullCalendar("refetchEvents");



      return false
    });
      


  });

$(document).ready(function(){

    
      


  });


