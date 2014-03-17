class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :clients, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :workouts, dependent: :destroy

  after_create :create_a_customer
  before_destroy :destroy_a_customer
 
         def create_a_customer
         	Stripe.api_key = 'Bf2TeaTMeuPDTWrmecc88biKWbejiayf'
         	token = self.stripe_card_token
         	
         	customer = Stripe::Customer.create(
  				:card => token,
  				:plan => self.plan,
  				:email => self.email
			)
           

			card = customer.cards.first
			update_attributes(:stripe_card_token => card.id)
			update_attributes(:stripe_customer_token => customer.id)
         end

         def destroy_a_customer
         	Stripe.api_key = 'Bf2TeaTMeuPDTWrmecc88biKWbejiayf'
         	cust = self.stripe_customer_token
         	cu = Stripe::Customer.retrieve(cust)
			cu.delete
         end

end
