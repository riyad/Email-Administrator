require 'spec_helper'

describe EmailsController do
  
  before :each do
    @admin_domain = Factory(:admin_domain)
    @admin = Factory(:admin)
    sign_in :email, @admin
    @domain = Factory(:domain) 
    @email = Factory(:email)
  end
  
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "Email can be updated" do
    describe "if password is not provided" do
      before do
        @email.password = ""
        @email.password_confirmation = ""
      end
      it{ @email.should be_valid }
    end
  end
  
  describe "Email can be updated" do
    before do 
      @send_email = @email.send_reset_password_instructions
      @token = @email.reset_password_token
    end
    it "and token is in email" do
      @send_email.body.include?(@token).should be_true
    end
    it "and token is in db" do
      @email.reset_password_token.should_not be_nil
    end
  end
  
  describe "Email to reset the password " do
    it "should be sent if email expires" do
      
    end
    
    it "should be resend if token expired" do
      
    end 
  end
  
  describe "Email should contain" do
    it "equal token as in datase" do
      
    end
  end
  
  describe "Email expires soon" do
    before do
      @email_expires_in_two_days = Factory(:email_expires_in_two_days)
      @email_expires_reminder_send = Factory(:email_expires_reminder_send)
      @email_expired = Factory(:email_expired)
      @emails_are_expiring_soon = Email.get_emails_expires_soon
    end
    
    it "and should contains email which expires soon" do
      @emails_are_expiring_soon[0].email.should == @email_expires_in_two_days.email
      @emails_are_expiring_soon.count.should be == 1
    end
    
    it "and should not contains email for which a reminder was already sent" do
      @emails_are_expiring_soon.count.should == 1
      @emails_are_expiring_soon[0].email.should_not == @email_expires_reminder_send.email
    end
    
    # Normally reminder email should be sent, but include in the test case
    it "and emails are marked as reminded" do
      @emails_are_expiring_soon.should_not be_empty
      @emails_are_expiring_soon.each do |email|
        email.reminder_sent = true
      end
      
      @emails_are_expiring_soon.all(&:reminder_sent).should be_true
    end

    it "and deactivate email when it is expired" do
      expired_emails = Email.to_be_expired
      expired_emails.should_not be_empty
       
      expired_emails.each do |e|
        e.active = false
      end

      expired_emails.all(&:active).should be_true
    end
  end
end
