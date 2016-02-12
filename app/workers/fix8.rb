def removefromapt_email(thisappointment, thisclient, thistrainer)
      require 'mandrill'

        if thisclient.user.email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

        mandrill = Mandrill::API.new 'gdATMo6lVK4YKoTdolhuBQ'
          message = {"html"=>" <p>Hey #{thisclient.name}!</p>
  <p>#{thistrainer.name} has removed you from the appointment on #{thisappointment.start_at.strftime("%A %D")} at #{thisappointment.start_at.strftime("%I:%M%P")}</p>
  <p>Please, contact #{thistrainer.name} at #{thistrainer.user.email}, if you believe this is a mistake.</p>
  <p>Thanks</p>
  <p>Personal Trainer Labs Team</p>",
           "text"=>"",
           "subject"=>"Removed From Session",
           "from_email"=>"notification@personaltrainerlabs.com",
           "from_name"=>"",
           "to"=>
              [{"email"=>"#{thisclient.user.email}",
                  "name"=>"#{thisclient.name}",
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