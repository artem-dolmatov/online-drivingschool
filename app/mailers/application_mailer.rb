class ApplicationMailer < ActionMailer::Base
  default from: 'info@project_name.ru'
  layout 'mailer/mailer'
end
