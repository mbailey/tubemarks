class UserMailer < ActionMailer::Base


  def reset_password(base_url, user, sent_at = Time.now)
    subject    'Reset Your Tubemarks Password'
    recipients user.email
    from       'admin@tubemarks.com'
    sent_on    sent_at

    body       :greeting => "Hi #{user.login},",
               :link => base_url+'/'+user.forgotten_password_link
  end

end
