require 'spec_helper'

describe Api::V1::MessagesController do

  describe "GET 'send'" do
    it "returns http success" do
      get 'send'
      response.should be_success
    end
  end

  describe "GET 'read'" do
    it "returns http success" do
      get 'read'
      response.should be_success
    end
  end

  describe "GET 'delete_session'" do
    it "returns http success" do
      get 'delete_session'
      response.should be_success
    end
  end

  describe "GET 'deletemessage'" do
    it "returns http success" do
      get 'deletemessage'
      response.should be_success
    end
  end

end
