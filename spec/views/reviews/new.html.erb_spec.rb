require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reviews/new.html.erb" do
  include ReviewsHelper
  
  before(:each) do
    assigns[:review] = stub_model(Review,
      :new_record? => true,
      :body => "value for body",
      :status => "value for status"
    )
  end

  it "should render new form" do
    render "/reviews/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", reviews_path) do
      with_tag("textarea#review_body[name=?]", "review[body]")
      with_tag("input#review_status[name=?]", "review[status]")
    end
  end
end


