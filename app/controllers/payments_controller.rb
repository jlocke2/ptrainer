class PaymentsController < ApplicationController
	def verify_client_card
		buyer = Balanced::Customer.new(
		  :name => current_user.rolable.name
		).save
		current_user.rolable.update_attributes(:customer_href => buyer.href)
		card_href = params[:uri]
		current_user.rolable.update_attributes(:card_href => card_href)
		card = Balanced::Card.fetch(card_href)
		card.associate_to_customer(buyer)
		respond_to do |format|
	        format.js { render :partial => 'add_card.js.erb' }
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
		  :name => current_user.rolable.name
		).save
		current_user.rolable.update_attributes(:customer_href => buyer.href)
		bank_href = params[:uri]
		current_user.rolable.update_attributes(:bank_href => bank_href)
		bank = Balanced::BankAccount.fetch(bank_href)
		bank.associate_to_customer(buyer)
		respond_to do |format|
	        format.js { render :partial => 'add_bank.js.erb' }
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

end