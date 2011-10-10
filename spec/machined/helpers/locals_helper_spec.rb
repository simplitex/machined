require "spec_helper"

describe Machined::Helpers::LocalsHelpers do
  describe "#locals=" do
    it "sets psuedo local variables" do
      with_context do |context, output|
        context.locals = { :text => "Hello World", :body => nil }
        context.text.should == "Hello World"
        context.body.should be_nil
      end
    end
    
    it "responds_to the local variable name" do
      with_context do |context, output|
        context.locals = { :text => "Hello World", :body => nil }
        context.respond_to?(:text).should be_true
        context.respond_to?(:body).should be_true
      end
    end
    
    it "still raises errors if the method doesn't exist" do
      with_context do |context, output|
        expect { context.not_a_local }.to raise_error(NoMethodError)
        context.respond_to?(:not_a_local).should be_false
      end
    end
    
    it "clears local variables when set to nil" do
      with_context do |context, output|
        context.locals = { :text => "Hello World" }
        context.locals = nil
        expect { context.text }.to raise_error(NoMethodError)
        context.respond_to?(:text).should be_false
      end
    end
  end
  
  describe "#with_locals" do
    it "temporarily changes the local variables" do
      with_context do |context, output|
        context.locals = { :text => "Hello World", :layout => "main" }
        context.with_locals(:layout => false, :body => "...") do
          context.text.should == "Hello World"
          context.body.should == "..."
          context.layout.should be_false
        end
        context.text.should == "Hello World"
        context.layout.should == "main"
        context.respond_to?(:body).should be_false
      end
    end
  end
end
