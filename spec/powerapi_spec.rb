require "spec_helper"

describe PowerAPI do
  include Savon::SpecHelper

  before(:all) {
    savon.mock!
  }

  after(:all) {
    savon.unmock!
  }

  describe "#authenticate" do
    it "throws an error due to invalid credentials" do
      fixture = File.read("spec/fixtures/authentication/failure.xml")
      message = { username: "fail", password: "fail", userType: 2}

      savon.expects(:login).with(message: message).returns(fixture)

      expect {
        PowerAPI.authenticate("http://powerschool.example", "fail", "fail")
      }.to raise_error(PowerAPI::Exception)
    end

    it "returns a student object due to valid credentials" do
      fixture = File.read("spec/fixtures/authentication/success.xml")
      message = { username: "student", password: "123456", userType: 2}

      savon.expects(:login).with(message: message).returns(fixture)

      expect(
        PowerAPI.authenticate("http://powerschool.example", "student", "123456", false)
      ).to be_an_instance_of(PowerAPI::Student)
    end
  end
end
