module EmailHelper
  def active_class(email)
    email.active? ? "active" : "inactive"
  end

  def admin_badge(email)
    image_tag("email-is-admin.png") if email.admin?
  end

  def form_date_for_expires_on(expires_on)
    image_tag("email-expires-on.png") + l(expires_on) if expires_on
  end
  
  def last_activity_for(email)
    content_tag :span, time_ago_in_words(email.last_activity_on)+" ago", :title => l(email.last_activity_on), :rel => "tooltip" if email.last_activity_on
  end    

  def forwards_badge(email)
    image_tag("email-forwards.png")+content_tag(:span, email.forwards.count, :class => "label label-info") unless email.forwards.empty?
  end

  def maildir_for(email)
    email.email_path || File.join(APP_CONFIG["email_default_save_path"], email.email || "")
  end

  def prefix_for(email)
    email.split("@").first
  end
  
  def receive_badge(email)
    image_tag("email-can-receive.png") if email.can_receive?
  end
  
  def send_badge(email)
    image_tag("email-can-send.png") if email.can_send?
  end
end
