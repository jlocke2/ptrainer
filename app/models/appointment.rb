class Appointment < ActiveRecord::Base


  include ActionView::Helpers::DateHelper

		belongs_to :trainer


    has_many :meetups, dependent: :destroy
    has_many :clients, through: :meetups

    has_one :workout, dependent: :destroy

        validates :start_at, presence: true
        validates :end_at, presence: true
        validates :trainer_id, presence: true

  validates :start_at, :end_at, :overlap => {:scope => "trainer_id", :exclude_edges => ["start_at", "end_at"]}

validate :check_times2



 def self.orders_create_and_payout

  appointments = Appointment.where([" ? < start_at AND start_at < ?", Time.current.advance(minutes: -960), Time.current.advance(minutes: 480) ])
      appointments.each do |appointment|

        @trainer = appointment.trainer
        if @trainer.bank_href != ""
        # fetch trainer from Balanced
        @merchant = Balanced::Customer.fetch(@trainer.customer_href)
        @default_price = @trainer.default_price
        @client_amount = @default_price * 0.967 - 55
        @our_amount = @default_price - @client_amount

        @meetups = appointment.meetups

        @attends = []
          @meetups.each do |meetup|
            @name = Client.find(meetup.client_id)
            @attends << @name
          end

      if @merchant.merchant_status == "underwritten"

      @attends.each do |attend|

        if attend.card_href != ""

         

         # create and save order
        order = @merchant.create_order
        order.description = 'Item description'
        order.save


          # save order_href associate to meetup in case of refund order.href should work

          #debit buyer/client and add to order
         card = Balanced::Card.fetch(attend.card_href)
         debit = order.debit_from(
          :source => card,
          :appears_on_statement_as => 'Personal_Training',
          :amount => @default_price # in cents
        )


           
           # credit the merchat/trainer from order
          bank_account = Balanced::BankAccount.fetch(@trainer.bank_href)
          order.credit_to(
            :destination => bank_account,
            :amount => @client_amount # in cents
          )

           
           # credit rest to marketplace/my bank account
          marketplace_bank_account = Balanced::Marketplace.mine.owner_customer.bank_accounts.first
          order.credit_to(
              :destination => marketplace_bank_account,
              :amount => @our_amount # in cents
          )

  end # if attend != ""

  end # @attends.each

  end # if underwritten

  end # if bank_href != ""

  end # end appointments.each

  # add else statements for each one

 end

 def self.delete_orders
   # after expiration of refund periond ~30days delete order_href from db
 end
  

   


   def self.perform

    require 'mandrill'
    appointments = Appointment.where([" ? < start_at AND start_at < ?", Time.current.advance(minutes: 270), Time.current.advance(minutes: 1710) ])
      appointments.each do |appointment|

         @meetups = appointment.meetups
         @attends = []
          @meetups.each do |meetup|
            @name = Client.find(meetup.client_id).id
            @attends << @name
          end

      @attends.each do |attend|

        if Client.find(attend).user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{Client.find(attend).name}!  Hope you are having a great day!</p>
  <p>Just wanted to remind you of our upcoming appointment on #{appointment.start_at.strftime("%A %D")} at #{appointment.start_at.strftime("%I:%M%P")}</p>
  <p>Look forward to seeing you then!</p>
  <p>Thanks</p>
  <p>#{Client.find(attend).trainer.name}</p>
  <p>#{Client.find(attend).trainer.user.email}</p>",
           "text"=>"",
           "subject"=>"Upcoming Workout Reminder",
           "from_email"=>"reminder@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{Client.find(attend).user.email}",
                  "name"=>"#{Client.find(attend).email}",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>"#{Client.find(attend).user.email}"},
           "important"=>false,
           "track_opens"=>nil,
           "track_clicks"=>nil,
           "auto_text"=>nil,
           "auto_html"=>nil,
           "inline_css"=>nil,
           "url_strip_qs"=>nil,
           "preserve_recipients"=>nil,
           "view_content_link"=>nil,
           "bcc_address"=>"",
           "tracking_domain"=>nil,
           "signing_domain"=>nil,
           "return_path_domain"=>nil,}
           
          async = false
          ip_pool = "Main Pool"
          send_at = ""
          result = mandrill.messages.send message, async, ip_pool, send_at
              # [{"email"=>"recipient.email@example.com",
              #     "status"=>"sent",
              #     "reject_reason"=>"hard-bounce",
              #     "_id"=>"abc123abc123abc123abc123abc123"}]

end
  

        end


      
  end
end

     
  

    

  scope :between, lambda {|start_time, end_time|
    {:conditions => ["? < start_at < ?", Appointment.format_date(start_time), Appointment.format_date(end_time)] }
  }

  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :name => self.name,
      :description => self.description || "",
      :start => start_at.rfc822,
      :end => end_at.rfc822,
      :recurring => false,
      :url => Rails.application.routes.url_helpers.appointment_path(id),
      #:color => "red"
    }

  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end



  private

      def check_times2
        if self[:end_at] < self[:start_at]
          errors[:end_date] << "Error message"
          return false
        end

      end


end
