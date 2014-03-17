$(document).on "click", ".showme", ->
	  id = this.id;
	  $('#nosee' + id).slideToggle();


$(document).on "click", ".showmen", ->
	  id = this.id;
	  $('#noseen' + id).slideToggle();



