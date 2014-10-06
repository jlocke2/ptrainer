# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously
 
$.rails.confirmed = (link) ->
  $('.delete-user').removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
	message = link.attr 'data-confirm'
	html = """
		<div id="confirmationDialog" class="modal modal-alert modal-danger fade" style="z-index:10500;">
					<div class="modal-dialog" style="margin: 60px auto;">
						<div class="modal-content" style=" max-width: 350px; text-align: center; margin: 0 auto;">
							<div class="modal-header" style="background: #e66454;">
								<i class="icon-ban-circle"></i>
							</div>
							<div class="modal-body">
					         <p style="text-align:center;">Are you sure?</p>
					       </div>
							<div class="modal-footer">
					         <a data-dismiss="modal" class="btn">Cancel</a>
					         <a data-dismiss="modal" class="btn btn-danger confirmers">OK</a>
					       </div>
						</div>
					</div>
				</div>
	     """
	$(html).modal()
	$('body').on 'click', 'a.confirmers', ->
	  $('.deleteMe').removeAttr('data-confirm')
	  $('.deleteMe').trigger('click')
