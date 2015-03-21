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
      ).to be_an_instance_of(PowerAPI::Data::Student)
    end
  end

  describe "#clean_url" do
    it "leaves 'https://powerschool.example' alone" do
      expect(
        PowerAPI.clean_url("https://powerschool.example")
      ).to eq("https://powerschool.example")
    end

    it "removes the slash in 'https://powerschool.example/'" do
      expect(
      PowerAPI.clean_url("https://powerschool.example/")
      ).to eq("https://powerschool.example")
    end
  end

  describe "#district_lookup" do
    it "doesn't find a district" do
      stub_request(:get, /powersource.pearsonschoolsystems.com/).
        to_return(status: 404, body: "", headers: {})

      expect(
        PowerAPI.district_lookup('SMPL')
      ).to eq(false)
    end

    it "finds an HTTPS district" do
      fixture = File.read("spec/fixtures/district/https_standard.json")
      stub_request(:get, /powersource.pearsonschoolsystems.com/).
        to_return(status: 200, body: fixture, headers: {})

      expect(
        PowerAPI.district_lookup('SMPL')
      ).to eq("https://powerschool.example")
    end

    it "finds an nonstandard HTTPS district" do
      fixture = File.read("spec/fixtures/district/https_nonstandard.json")
      stub_request(:get, /powersource.pearsonschoolsystems.com/).
        to_return(status: 200, body: fixture, headers: {})

      expect(
        PowerAPI.district_lookup('SMPL')
      ).to eq("https://powerschool.example:8181")
    end

    it "finds an HTTP district" do
      fixture = File.read("spec/fixtures/district/http_standard.json")
      stub_request(:get, /powersource.pearsonschoolsystems.com/).
        to_return(status: 200, body: fixture, headers: {})

      expect(
        PowerAPI.district_lookup('SMPL')
      ).to eq("http://powerschool.example")
    end

    it "finds an nonstandard HTTP district" do
      fixture = File.read("spec/fixtures/district/http_nonstandard.json")
      stub_request(:get, /powersource.pearsonschoolsystems.com/).
        to_return(status: 200, body: fixture, headers: {})

      expect(
        PowerAPI.district_lookup('SMPL')
      ).to eq("http://powerschool.example:8080")
    end
  end
end
