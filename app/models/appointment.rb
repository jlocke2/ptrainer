class Appointment < ActiveRecord::Base


  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

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

  require 'balanced'
  Balanced.configure('ak-test-18Ax0g5fdxBzAfPT7ToH9DMlvOxQBEzre')

  no_card = []
  card_present = []
  appointments = Appointment.where([" ? < start_at AND start_at < ?", Time.current.advance(minutes: -960), Time.current.advance(minutes: 480) ])
      appointments.each do |appointment|

        @trainer = appointment.trainer
        unless @trainer.bank_href.blank?
        # fetch trainer from Balanced
        @merchant = Balanced::Customer.fetch(@trainer.customer_href)
        @default_price = @trainer.default_price
        @client_amount_1 = @default_price * 0.967 - 55
        @client_amount = @client_amount_1.to_i
        @our_amount = @default_price - @client_amount

        @meetups = appointment.meetups

        @attends = []
          @meetups.each do |meetup|
            @name = Client.find(meetup.client_id)
            @attends << @name
          end

      if @merchant.merchant_status == "underwritten"

      @attends.each do |attend|

        unless attend.card_href.blank?

          card_present << attend.id


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

  else # unless attend.card_href.blank?

    no_card << attend.name

  end # unless attend.card_href.blank?

  end # @attends.each

  end # if underwritten

  end # unless bank_href.blank?

  @no_count = no_card.count
  @yes_count = card_present.count



  @weekly = Weeklyinfo.find_by(trainer_id: @trainer.id)
  @prevunpaid = @weekly.unpaid
  @finalunpaid = @prevunpaid.concat(no_card)
  @weekly.update_attributes(:unpaid => @finalunpaid)
  @prevcount = @weekly.totalcount
  @finalcount = @prevcount + @no_count + @yes_count
  @weekly.update_attributes(:totalcount => @finalcount)





    no_card.clear
    card_present.clear


  end # end appointments.each

  # add else statements for each one

  # add some sort of notification for attends in no_card array

require 'mandrill'
  mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Payment Schedule is working!</p>",
           "text"=>"",
           "subject"=>"Payment Schedule",
           "from_email"=>"reminder@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"alan@provivify.com",
                  "name"=>"",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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

 end

 def self.delete_orders
   # after expiration of refund periond ~30days delete order_href from db
 end

 def self.weekly_review_for_trainer
    # do something with saved info from week of sessions paid/unpaid
    @trainer = Trainer.all

    @trainer.each do |trainer|
      @weekly = Weeklyinfo.find_by(trainer_id: trainer.id)
      @times = @weekly.totalcount
      @unpaid = @weekly.unpaid
      @default_price = trainer.default_price



      @counts = Hash.new 0

      

      if @times > 0
        @rev = @times * @default_price
        @profit = @rev.to_f * 0.967 - (55 * @times)
        @profit_final = @profit/100
        @currency = sprintf('%.2f', @profit_final)
        @opening = "Congratulations #{trainer.name} on your successful week!  Below we have included your weekly summary for your convenience.</p>"\
        "<p>You were able to book a total of #{@times} sessions this week for a profit of $#{@currency}."
        
        
          if @unpaid.count > 0
            @unpaid.each do |word|
              counts[word] += 1
            end
            @string = ""
            @counts.each do |name,time|
            @string.concat("<p> #{name} X  #{time}</p>")
            end
            @middle = "<p>Unfortunately, some of your clients haven't entered their credit card information into Personal Trainer Labs yet, so we were unable
            to charge them for you. Here is a list of those clients and their number of sessions for the week.</p>
            <h3>Clients Without Credit Card Information</h3>
            #{@string}
              <p>If you continue to encourage your clients to add their information to Personal Trainer Labs, we will be able to automate all your payments
              for you.  Keeping you from having to chase all those loose payments down yourself."
          else
            @middle = ""
          end

        @closing = "Keep up the great work!"
        @ps = "PS - If there is anything we can do to improve your experience, please feel free to email us anytime at 
            support@personaltrainerlabs.com"
      else
        @opening = "Unfortunately, you didn't book any sessions through Personal Trainer Labs this week."
        @middle = ""
        @closing = "We know it can be tough getting started with new software.
        If there is anything we can do to improve your experience or help you get started, please feel free to email us anytime at 
            support@personaltrainerlabs.com"
        @ps = ""
      end




      require 'mandrill'
  mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>#{@opening}</p>
          #{@middle}
          <p>#{@closing}</p>
          <p>Thanks and Have A Great Start To Your Week</p>
          <p>Personal Trainer Labs Team</p>
          <p>#{@ps}</p>",
           "text"=>"",
           "subject"=>"Weekly Update",
           "from_email"=>"WeeklyUpdate@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{trainer.user.email}",
                  "name"=>"",
                  "type"=>"to"}],
           "headers"=>{"Reply-To"=>""},
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








      @weekly.update_attributes(:unpaid => [])
      @weekly.update_attributes(:totalcount => 0)

    end # @trainer.each

 end # self
  

   


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



              end # if Client.email
  

        end # @attends.each


      
  end # appointments.each
end # def self.perform

     
  

    

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
