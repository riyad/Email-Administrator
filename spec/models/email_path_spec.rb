require 'spec_helper'

describe EmailPath do
  #let(:default_path){Factory(:email_path)}
  before(:each) do 
    @email_path  = Factory(:email_path)
  end
  describe "default path was set" do
    it "and there should be an entry in the path" do
      EmailPath.count.should be > 0
    end
    
    it "and the default path should be the first element in the table" do
      first_element = EmailPath.first
      first_element.path_type.should eql "default"
    end
  end  
end
