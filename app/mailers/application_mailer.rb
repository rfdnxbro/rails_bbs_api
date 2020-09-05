# frozen_string_literal: true

#
# mailerのsuper class
#
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
