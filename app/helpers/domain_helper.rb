module DomainHelper
  def emails_badge(domain)
    image_tag("domain-emails.png")+content_tag(:span, domain.emails.count, :class => "label")
  end
end
