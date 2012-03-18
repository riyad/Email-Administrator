require "spec_helper"

describe Email do
  before do
    @domain = Factory(:domain) 
    @email = Email.new(email: "user@heise.de",
    password: "foobar", password_confirmation: "foobar", domain_id: @domain.id, email_path: '/var/logs', reminder_sent: false, expires_on: Time.now + 50.days, alt_email: "moritz.bode@gmail.com")
  end
  
  subject { @email }
  
  it {@email.should be_valid }
  
  describe "new email address" do
    describe "Email cant be created" do
      describe "if password is not provided" do
       before { @email_temp = Email.new(email: "user@heise.de",
    password: "", password_confirmation: "", domain_id: @domain.id, email_path: '/var/logs')}
       it{@email_temp.should_not be_valid}
      end
    end
    
    describe "and empty email address" do
      before{@email.email = ""}
      it{@email.should_not be_valid}
    end
    
    describe "and empty email_path" do
      before{@email.email_path = nil}
      it{@email.should_not be_valid}
    end
    
    describe "and blank email_path" do
      before{@email.email_path = ""}
      it{@email.should_not be_valid}
    end
    
    describe "and empty domain_id" do
      before{@email.domain_id = nil}
      it{@email.should raise_error}
    end
    
    describe "and unvalid domain_id" do
      before{@email.domain_id = "5"}
      it{@email.should raise_error}
    end
    
    describe "and expire date and without alternative email" do
      before{
        @email.expires_on = Date.today
        @email.alt_email = ""
        }
      it{@email.should_not be_valid}
    end
  end
  
  
  describe "editing email adress" do
    describe "setting domain name, should also email adress be changed" do
      before do
        @domain = Domain.create(:name => "test.de")
        @email_address_before = @email.email
        @email.domain = @domain
        @email.save
        @email_address_after = @email.email
      end
      it {@email_address_before.should_not match @email_address_after}
    end    
  end

  describe "mass assignment of" do
    it "email should fail" do
      pending
    end
    it "forward_email should fail" do
      pending
    end
  end

  describe "validation of" do
    describe "email_path" do
      it "should fail if it is the maildir base path" do
        pending
      end
    end
  end
end
