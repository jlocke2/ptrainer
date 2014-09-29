$(document).ready(function() {
  var d, date, m, moveTime, newForm, refetch_events_and_close_dialog, resizeTime, setTime, showEventDetails, y;
  date = new Date();
  d = date.getDate();
  m = date.getMonth();
  y = date.getFullYear();
  day = date.getDay();
  var allowed = true;
  $("#calendar").fullCalendar({
    header: {
      left: "prev,next today",
      center: "title",
      right: "month,agendaWeek,agendaDay"
    },
    editable: true,
    allDaySlot: false,
    selectable: true,
    allDayDefault: false,
    eventRender: function(event, element) {
            var view = $('#calendar').fullCalendar('getView');
            if (event.class == "unavailable"){
              element.css({'background-color':'grey','border':'grey'})
              event.editable = false
            };
            if (event.class == "gone"){
              element.css({'background-color':'grey','border':'grey'})
            };
            if (event.class == "opentime"){
              element.css({'background-color':'green','border':'green'})
            };
            if (event.class == "requested"){
              element.css({'background-color':'#FF5433','border':'#FF5433'})
              event.editable = false
            };
            if (view.name == 'month' && event.class == "unavailable") {return false};
          },
    events: "/appointments.json",
    getAvailable: function(){



    },
    select: function(start, end, startDate, endDate, allDay, jsEvent, view) {
        viewer = $('#calendar').fullCalendar('getView');
        if (viewer.name == "month") {
         // console.log(viewer);
        $('.fc-event').popover('destroy');
        console.log(start)
        var splitter = start.toString().split(" ");
          var dayofweek = splitter[0];

        switch (dayofweek) {
                                      case "Sun":
                                          newday = "0";
                                          break;
                                      case "Mon":
                                          newday = "1";
                                          break;
                                      case "Tue":
                                          newday = "2";
                                          break;
                                      case "Wed":
                                          newday = "3";
                                          break;
                                      case "Thu":
                                          newday = "4";
                                          break;
                                      case "Fri":
                                          newday = "5";
                                          break;
                                      case "Sat":
                                          newday = "6";
                                          break;
                                     
                                        }


        
         // console.log(dayofweek);
         console.log(calTime.data[newday]);
         $('#calendar').fullCalendar('getView').calendar.options.minTime=calTime.data[newday].start;
          $('#calendar').fullCalendar('getView').calendar.options.maxTime=calTime.data[newday].end;
         



        $("#calendar").fullCalendar("changeView", "agendaDay").fullCalendar("gotoDate", start);
        // console.log(start)
      } else {
        viewer = $('#calendar').fullCalendar('getView');
       //  console.log(viewer);
       //  console.log(start);
      //  console.log(end);
       //  console.log(rolable.type);
         if (rolable.type == "Client") {




          $.when($.ajax({
                      url: "/requests/newform",
                      success: function(data) {
                        $("#new_request").html(data["form"]);
                         if ($('#datetimepicker10').length){

                          $('body').off('click', '.multiselect')
                          $('body').on('click', '.multiselect', function(e){
                            $(this).parent().toggleClass('open');
                            e.stopPropagation();
                          });




                           $('#datetimepicker10').clockpicker({
           default: "now",
           twelvehour: true,
           donetext: "Done",
           afterDone: function() {
                            var timeplus = $('#datetimepicker10').val();
            
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
                                  $('#datetimepicker11').val(timeplus3);
                                              }
                                });
                                
                         


                         
                                $('#datetimepicker11').clockpicker({
                                  
                                 default: "now",
                                 twelvehour: true,
                                 donetext: "Done",

                                });

                                
                        


                          
                                $('#datetimepicker12').datepicker({
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




                            $('#datetimepicker10').val(timesplit[0] + ":" + timesplit[1] + " " + fintime);
                            $('#datetimepicker11').val(timesplitend[0] + ":" + timesplitend[1] + " " + fintimeend);
                            $('#datetimepicker12').val(newmon + "/" + splits[2] + "/" + splits[3]);
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
                    }})).then( finishrequestform());
        
       

      


function finishrequestform() {
          $('.fc-cell-overlay').popover('destroy');
        $('.fc-event').popover('destroy');
        $('.fc-cell-overlay').popover({
          title: "Request Appointment Time",
          width: 500,
          animation: false,
          trigger: 'manual',
          container: 'body',
          placement: 'top',
          content: "<div id='new_request'></div>",
          html: true,
          template: '<div class="popover" style="width:500px" role="tooltip"><h3 class="popover-title" style="text-align:center;"></h3><div class="popover-content"></div></div>'
        }).popover('show');








         };
         










         } else {



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
         





        
      };
    },
    viewDestroy: function(view) {
     // console.log(view);
      $('.fc-event').popover('destroy');
      $('.fc-cell-overlay').popover('destroy');
      

        
    },
    dayRender: function(date, cell, start){
      
    
    },
    viewRender: function(view) {
      // console.log(view);
      
      if (allowed){
            $.ajax({
                url: "/appointments/mastercalendar",
                success: function(data) {
                  console.log(data);
                  var today = new Date();
                    var now = today.getDay();
                    console.log(now)
                    
                      console.log(data.data[now].start);
                    
                      $('#calendar').fullCalendar('getView').calendar.options.minTime=data.data[now].start;
                       $('#calendar').fullCalendar('getView').calendar.options.maxTime=data.data[now].end;

                       calTime = data

                  }


                    });
          
          allowed = false
      };
     
      
     // console.log(dayofweek);
    /*  if (dayofweek == "Wed") {
        $('#calendar').fullCalendar('getView').calendar.options.minTime=2;
       $('#calendar').fullCalendar('getView').calendar.options.maxTime=20;

      } else {
        $('#calendar').fullCalendar('getView').calendar.options.minTime=6;
       $('#calendar').fullCalendar('getView').calendar.options.maxTime=10;
      };
        */
    



      /*
      var view = $('#calendar').fullCalendar('getView');
      if (view.name == 'month'){
        console.log("Welcome to the Month");
      } else if (view.name == 'agendaDay'){
        for (i = 0; i < 12; i++) { 
          $('.fc-slot'+i).css('background-color', 'rgba(128, 128, 128, 0.5)');
        }

        for (i = 40; i < 48; i++) { 
          $('.fc-slot'+i).css('background-color', 'rgba(128, 128, 128, 0.5)');
        }
        
        console.log(view.name);
      }else if (view.name == 'agendaWeek'){
        console.log(view.name);
      };
     
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
      if (event.class == "unavailable") {

       } else {
        console.log('saving on drop');
        moveTime(event, dayDelta, minuteDelta, allDay);
      };
    },
    eventResize: function(event, dayDelta, minuteDelta, allDay) {
      if (event.class == "unavailable") {

       }else {
        console.log('saving on resize');
        resizeTime(event, dayDelta, minuteDelta, allDay);
      };
    },
    eventClick: function(event, jsEvent, view) {
       $('.fc-event').popover('destroy');
       $('.fc-cell-overlay').popover('destroy');
       if (event.class == "unavailable") {

       }else {
        showEventDetails(event)
       };
      
      
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


            ends = event.end.toString();
            var splitsend = ends.split(" ");
            var timesplitend = splitsend[4].split(":");
            if (timesplitend[0] >= 13) {
                    timesplitend[0] = Number(timesplitend[0])-12
                    var fintimeend = "PM"
                  } else if (timesplitend[0] == 0) {
                    timesplitend[0] = Number(timesplitend[0])+12
                    var fintimeend = "AM"
                  }else {
                   var fintimeend = "AM"
                  };






      if (event.allp instanceof Array){allp = event.allp.join(", ")}else{allp = event.allp};
      $delete_event.html("<a class='btn mybtn btn-large btn-danger' style='width: 100%;' href = 'javascript:void(0);' onclick ='deleteIt(" + event.id + ", " + false + ")'>Delete Appointment</a>");
    }
    $event_actions.append($view_event).append("<br />").append("<br />").append($edit_event).append("<br />").append("<br />").append($delete_event);
    $("#event_desc_dialog").append($event_description).append($event_actions);
    if (event.class == "requested") {
      if (rolable.type == "Trainer") {


        $.when($.ajax({
                      url: "/requests/" + event.id + "/formsforpop",
                      success: function(data) {
                        var start = data["start"];
                        var end = data["end"];
                        var name = data["name"];
                        $("#request_list").html(data["popinfo"]);
                        $("#insertconfirm").html(data["confirmform"]);
                        $("#insertdecline").html(data["declineform"]);
                         }})).then( finishpopform());

            function finishpopform() {
          $('.fc-cell-overlay').popover('destroy');
        $('.fc-event').popover('destroy');

            $('.fc-event').popover({
              title: "Current Request",
              width: 500,
              animation: false,
              trigger: 'manual',
              container: 'body',
              placement: 'top',
              content: "<div id='request_list'></div>",
              html: true,
              template: '<div class="popover" style="width:500px" role="tooltip"><h3 class="popover-title" style="text-align:center;"></h3><div class="popover-content"></div></div>'
            });
        }

        


      } else {




         $.when($.ajax({
                      url: "/requests/" + event.id + "/formsforpop",
                      success: function(data) {
                        $("#request_list").html(data["popinfo"]);
                        $("#insertdecline").html(data["declineform"]);
                         }})).then( finishpopform());

            function finishpopform() {
          $('.fc-cell-overlay').popover('destroy');
        $('.fc-event').popover('destroy');

            $('.fc-event').popover({
              title: "Current Request",
              width: 500,
              animation: false,
              trigger: 'manual',
              container: 'body',
              placement: 'top',
              content: "<div id='request_list'></div>",
              html: true,
              template: '<div class="popover" style="width:500px" role="tooltip"><h3 class="popover-title" style="text-align:center;"></h3><div class="popover-content"></div></div>'
            });
        }






       
      };

    } else if (event.class == "gone"){
      if (rolable.type == "Trainer"){
        $(".fc-event").popover({
      title: "Unavailable Time",
      width: 500,
      animation: false,
      trigger: 'manual',
      container: 'body',
      placement: 'top',
      content: "<div id='edit_unavilable'></div><div id='hidepop2'><div class='field'> When: <span class='date'>" + splits[1] + " " + splits[2] + ", " + timesplit[0] + ":" + timesplit[1] + " " + fintime + " to " + timesplitend[0] + ":" + timesplitend[1] + " " + fintimeend + 
      "</span></div>" + "<br />" + 
      "<a class='btn-sm mybtn btn-small btn-primary' style='width: 94px; margin-right: 48px; padding-left: 20px; padding-right: 10px; margin-left: 3px;display:inline-block;' href = 'javascript:void(0);' onclick ='editItun(" + event.id + ")'>Edit Time</a>" +
      "<a class='btn-sm mybtn btn-small btn-danger' style='width: 94px; padding-left: 26px; padding-right: 17px;display:inline-block;' href = 'javascript:void(0);' onclick ='deleteItun(" + event.id + ", " + false + ")'>Cancel</a></div>",
      html: true,
      template: '<div class="popover" style="width:500px" role="tooltip"><div class="arrow arrowhide"></div><h3 class="popover-title" style="text-align:center; "></h3><div class="popover-content"></div></div>'
    });

      } else {

      };
    } else if (event.class == "opentime") {
      if (rolable.type == "Client"){
        $(".fc-event").popover({
      title: event.title,
      width: 500,
      animation: false,
      trigger: 'manual',
      container: 'body',
      placement: 'top',
      content: "<div id='edit_avilable_group'></div><div id='hidepop2'><div class='field'> When: <span class='date'>" + splits[1] + " " + splits[2] + ", " + timesplit[0] + ":" + timesplit[1] + " " + fintime + " to " + timesplitend[0] + ":" + timesplitend[1] + " " + fintimeend + 
      "</span></div><div class='field' style='margin-bottom:-5px;'> Who: <span class='who'>" + allp + "</span></div>" + "<br />" + 
      "<a class='btn-sm mybtn btn-small btn-success' style='width: 194px; padding-left: 40px; padding-right: 17px;display:inline-block;margin-left:26px;' href = 'javascript:void(0);' onclick ='joinIt(" + event.id + ", " + false + ")'>Join Group Session</a></div>",
      html: true,
      template: '<div class="popover" style="width:500px" role="tooltip"><div class="arrow arrowhide"></div><h3 class="popover-title" style="text-align:center; "></h3><div class="popover-content"></div></div>'
    });

      } else {

      };
    } else {
      if (rolable.type == "Trainer"){
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
      "<a class='btn-sm mybtn btn-small btn-danger' style='width: 30%; padding-left: 17px; padding-right: 17px;' href = 'javascript:void(0);' onclick ='deleteIt(" + event.id + ", " + false + ")'>Cancel</a></div>",
      html: true,
      template: '<div class="popover" style="width:500px" role="tooltip"><div class="arrow arrowhide"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
    });
    } else {
      $(".fc-event").popover({
      title: "Scheduled Appointment",
      width: 500,
      animation: false,
      trigger: 'manual',
      container: 'body',
      placement: 'top',
      content: "<div id='edit_appointment_description2'></div><div id='hidepop'><div class='field'> When: <span class='date'>" + splits[0] + " " + splits[1] + " " + splits[2] + " at " + timesplit[0] + ":" + timesplit[1] + " " + fintime +
      "</span></div>" + "<br />" + 
      "<a class='btn-sm mybtn btn-small btn-success' style='width: 114px; margin-right: 15px; padding-left: 20px; padding-right: 12px; display: inline-block;' href = 'javascript:void(0);' onclick ='viewIt(" + event.id + ")'>View Workout</a>" + 
      "<a class='btn-sm mybtn btn-small btn-danger' style='width: 114px; padding-left: 40px; padding-right: 17px; display: inline-block;' href = 'javascript:void(0);' onclick ='deleteItclient(" + event.id + ", " + false + ")'>Cancel</a></div>",
      html: true,
      template: '<div class="popover" style="width:500px" role="tooltip"><div class="arrow arrowhide"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
    });
    }
    };
    





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
                      $('.arrowhide').css('display', 'none');

                      if (data["id"] != null ) {$('.multisel2').multiselect('select', data["id"])};


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
  }, this.editItun = function(event_id) {
    $.ajax({
      url: "/unavailables/" + event_id + "/editordata",
      success: function(data) {
        console.log(data["apt"]);
        console.log(data);
        $("#edit_unavilable").html(data["form"]);



        if ($('#datetimepicker13').length){

                          $('body').off('click', '.multiselect')
                          $('body').on('click', '.multiselect', function(e){
                            $(this).parent().toggleClass('open');
                            e.stopPropagation();
                          });
                          


           $('#datetimepicker13').clockpicker({
           default: "now",
           twelvehour: true,
           donetext: "Done",
           afterDone: function() {
                            var timeplus = $('#datetimepicker13').val();
            
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
                                  $('#datetimepicker14').val(timeplus3);
                                              }
                                });
                                
                         


                         
                                $('#datetimepicker14').clockpicker({
                                  
                                 default: "now",
                                 twelvehour: true,
                                 donetext: "Done",

                                });

                                
                        


                          
                                $('#datetimepicker15').datepicker({
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
                      $('#hidepop2').css('display', 'none');
                      $('.arrowhide').css('display', 'none');

                      if (data["id"] != null ) {$('.multisel2').multiselect('select', data["id"])};


                      var startedit = data["start"].toString();

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


                                var endedit = data["end"].toString();
                                  var splitendedit = endedit.split(" ");
                                  var timesplitendedit = splitendedit[4].split(":");
                                  if (timesplitendedit[0] >= 13) {
                                          timesplitendedit[0] = Number(timesplitendedit[0])-12
                                          var fintimeendedit = "PM"
                                        } else {
                                         var fintimeendedit = "AM"
                                        };



                            $('#datetimepicker13').val(timesplitedit[0] + ":" + timesplitedit[1] + " " + fintimeendedit);
                            $('#datetimepicker14').val(timesplitendedit[0] + ":" + timesplitendedit[1] + " " + fintimeendedit);
                            $('#datetimepicker15').val(newmonedit + "/" + splitsedit[1] + "/" + splitsedit[3]);





                            $('body').on('submit','#edit_unavailable_' + data["apt"].id, function(event){
                                  event.preventDefault;

                                  var val8 = $('#datetimepicker15').val();
                                  var ar1 = val8.split("/");
                                  var it1 = ar1[0];
                                  var it2 = ar1[1];
                                  var it3 = ar1[2];
                                  $("select#unavailable_start_at_1i option:selected").val(it3);
                                  $("select#unavailable_end_at_1i option:selected").val(it3);
                                  $("select#unavailable_start_at_2i option:selected").val(it1);
                                  $("select#unavailable_end_at_2i option:selected").val(it1);
                                  $("select#unavailable_start_at_3i option:selected").val(it2);
                                  $("select#unavailable_end_at_3i option:selected").val(it2);


                                  var val9 = $('#datetimepicker13').val();
                                  var ar19 = val9.split(/:| /g);
                                  if (ar19[2] == "PM" && ar19[0] != 12) {
                                    ar19[0] = Number(ar19[0])+12
                                  };
                                  $("select#unavailable_start_at_4i option:selected").val(ar19[0]);
                                  $("select#unavailable_start_at_5i option:selected").val(ar19[1]);


                                  var val7 = $('#datetimepicker14').val();
                                  var ar17 = val7.split(/:| /g);
                                  if (ar17[2] == "PM" && ar17[0] != 12) {
                                    ar17[0] = Number(ar17[0])+12
                                  };
                                  $("select#unavailable_end_at_4i option:selected").val(ar17[0]);
                                  $("select#unavailable_end_at_5i option:selected").val(ar17[1]);

                                  $('#edit_unavailable_' + data["apt"].id).trigger("submit.rails");
                                  $('.fc-cell-overlay').popover('destroy');
                                  $('.fc-event').popover('destroy');

                                  $("#calendar").fullCalendar("refetchEvents");



                                  return false
                                });








}


      }
    });
  },this.viewIt = function(event_id) {
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
  },this.deleteItun = function(event_id, delete_all) {
    $('.fc-cell-overlay').popover('destroy');
    $('.fc-event').popover('destroy');
    $.ajax({
      dataType: "script",
      type: "delete",
      url: "/unavailables/" + event_id,
      success: refetch_events_and_close_dialog
    });
  },this.deleteItclient = function(event_id, delete_all) {
    $('.fc-cell-overlay').popover('destroy');
    $('.fc-event').popover('destroy');
    $.ajax({
      dataType: "script",
      type: "post",
      url: "/appointments/" + event_id + "/clientremove",
      success: refetch_events_and_close_dialog
    });
  },this.joinIt = function(event_id) {
    $('.fc-cell-overlay').popover('destroy');
    $('.fc-event').popover('destroy');
    $.ajax({
      dataType: "script",
      type: "post",
      url: "/appointments/" + event_id + "/join",
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

    $('body').on('submit','#new_request2', function(event){
      event.preventDefault;

      var val8 = $('#datetimepicker12').val();
      var ar1 = val8.split("/");
      var it1 = ar1[0];
      var it2 = ar1[1];
      var it3 = ar1[2];
      $("select#request_start_at_1i option:selected").val(it3);
      $("select#request_end_at_1i option:selected").val(it3);
      $("select#request_start_at_2i option:selected").val(it1);
      $("select#request_end_at_2i option:selected").val(it1);
      $("select#request_start_at_3i option:selected").val(it2);
      $("select#request_end_at_3i option:selected").val(it2);


      var val9 = $('#datetimepicker10').val();
      var ar19 = val9.split(/:| /g);
      if (ar19[2] == "PM" && ar19[0] != 12) {
        ar19[0] = Number(ar19[0])+12
      };
      $("select#request_start_at_4i option:selected").val(ar19[0]);
      $("select#request_start_at_5i option:selected").val(ar19[1]);


      var val7 = $('#datetimepicker11').val();
      var ar17 = val7.split(/:| /g);
      if (ar17[2] == "PM" && ar17[0] != 12) {
        ar17[0] = Number(ar17[0])+12
      };
      $("select#request_end_at_4i option:selected").val(ar17[0]);
      $("select#request_end_at_5i option:selected").val(ar17[1]);

      $('#new_request2').trigger("submit.rails");
      $('.fc-cell-overlay').popover('destroy');

      $("#calendar").fullCalendar("refetchEvents");



      return false
    });


  });


