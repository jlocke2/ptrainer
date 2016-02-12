def changedtime_email(thisappointment, clientlist, thistrainer)
      require 'mandrill'

      clientlist.each do |clientid|
        if clientid != ""

        client = Client.find(clientid)

        if client.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{client.name}!</p>
  <p>#{thistrainer.name} has changed the appointment time on #{thisappointment.start_at.strftime("%A %D")} to #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Trainer Changed Time Of Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{client.user.email}",
                  "name"=>"#{client.name}",
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
              # [{"email"=>"recipient.email@example.com",
              #     "status"=>"sent",
              #     "reject_reason"=>"hard-bounce",
              #     "_id"=>"abc123abc123abc123abc123abc123"}]

          end
        end
      end
    end