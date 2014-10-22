class PaymentsController < ApplicationController
	rescue_from Balanced::BadRequest, with: :bad_form_info



	def verify_client_card
		buyer = Balanced::Customer.new(
		  :name => current_user.rolable.name
		).save
		current_user.rolable.update_attributes(:customer_href => buyer.href)
		card_href = params[:uri]
		card = Balanced::Card.fetch(card_href)
		if card.cvv_match != "yes"
			# failed cvv_match remove card and flash warning
			current_user.rolable.update_attributes(:card_href => "")
				respond_to do |format|
				        format.js { render :partial => 'failed_cvv_card.js.erb' }
				    end
		else
			if card.avs_postal_match != "yes"
				# failed avs_postal_match remove card and flash warning
				current_user.rolable.update_attributes(:card_href => "")
					respond_to do |format|
					        format.js { render :partial => 'failed_avs_card.js.erb' }
					    end
			else
				# passed both tests, so can associate to customer and flash positive message
				current_user.rolable.update_attributes(:card_href => card_href)
				card.associate_to_customer(buyer)
				respond_to do |format|
			        format.js { render :partial => 'add_card.js.erb' }
			    end
			end
		end
	end

	def delete_client_card

		card = Balanced::Card.fetch(current_user.rolable.card_href)
		card.unstore
		current_user.rolable.update_attributes(:card_href => "")
		respond_to do |format|
	        format.js { render :partial => 'remove_card.js.erb' }
	    end
		
	end

	def update_client_card
		
	end

	def verify_trainer_bank
		buyer = Balanced::Customer.new(
		  :name => current_user.rolable.name,
		  :ssn_last4 => params[:last4ssn],
		  :phone => params[:phonenum],
		  :dob_month => params[:dobm].to_i,
		  :dob_year => params[:doby].to_i,
		  :address => {
		    :postal_code => params[:postal_code]

		  }
		)
		if buyer.save

			if buyer.merchant_status == "underwritten"
				current_user.rolable.update_attributes(:customer_href => buyer.href)
				bank_href = params[:uri]
				current_user.rolable.update_attributes(:bank_href => bank_href)
				bank = Balanced::BankAccount.fetch(bank_href)
				bank.associate_to_customer(buyer)
				respond_to do |format|
			        format.js { render :partial => 'add_bank.js.erb' }
			    end
			else # merchant verfication fails
				respond_to do |format|
			        format.js { render :partial => 'failed_bank.js.erb' }
			    end
			end
		else #buyer.save fails

		end
	end

	def delete_trainer_bank

		bank_account = Balanced::BankAccount.fetch(current_user.rolable.bank_href)
		bank_account.unstore
		current_user.rolable.update_attributes(:bank_href => "")
		respond_to do |format|
	        format.js { render :partial => 'remove_bank.js.erb' }
	    end
		
	end

	def update_trainer_bank
		
	end


	def add_default_price

		@price = params[:default_price]
		if @price =~ /^[0-9]\d*(((,\d{3}){1})?(\.\d{0,2})?)$/

			@pricefinal = @price.gsub(/,/, '').to_f * 100
			current_user.rolable.update_attributes(:default_price => @pricefinal)
			respond_to do |format|
		        format.js { render :partial => 'add_default_price.js.erb' }
		    end
		else
			respond_to do |format|
		        format.js { render :partial => 'invalid_default_price.js.erb' }
		    end
		end
		
	end

	def form_validation

		respond_to do |format|
		        format.js { render :partial => 'invalid_form.js.erb' }
		 end

	end

	def index
		
	end

	 private
 
	    def bad_form_info
	    	current_user.rolable.update_attributes(:bank_href => "")
	      respond_to do |format|
		        format.js { render :partial => 'invalid_routing_number.js.erb' }
		    end
	    end



end