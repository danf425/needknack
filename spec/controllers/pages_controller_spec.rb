require 'spec_helper'

describe PagesController do

  describe "GET 'howitworks'" do
    it "returns http success" do
      get 'howitworks'
      response.should be_success
    end
  end

end
