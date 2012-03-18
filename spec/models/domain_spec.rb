require "spec_helper"

describe Domain do
  before do
    @domain = Domain.create(name: "foobar.de")
  end
   
  subject { @domain }
   
  it {should respond_to(:name)}
  
  it {@domain.should be_valid }

  describe "validtion of" do
    describe "name" do
      it "should fail without it" do
        domain = Domain.new(:name => "")

        domain.should_not be_valid
        domain.should have_at_least(1).error_on(:name)
      end

      it "should succeed with IP address" do
        domain = Domain.new(:name => "127.0.0.1")

        domain.should be_valid
      end

      it "should succeed with hostname" do
        domain = Domain.new(:name => "localhost")

        domain.should be_valid
      end

      it "should succeed with FQDN" do
        domain = Domain.new(:name => "mail1.example.tld")

        domain.should be_valid
      end
    end
  end
end
