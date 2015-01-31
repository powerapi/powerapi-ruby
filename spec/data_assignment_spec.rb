require "spec_helper"

describe PowerAPI::Data::Assignment do
  include Savon::SpecHelper

  before(:all) {
    savon.mock!

    @session = {:locale=>nil, :server_current_time=>"2014-08-24T03:01:25.007Z", :server_info=>{:api_version=>"2.1.1", :day_light_savings=>"0", :parent_saml_end_point=>nil, :raw_offset=>"-14400000", :server_time=>"2014-08-24T20:19:32.640Z", :student_saml_end_point=>nil, :teacher_saml_end_point=>nil, :time_zone_name=>"BOT", :"@xsi:type"=>"ax287:ServerInfo"}, :service_ticket=>"AAABSAX2Ex5NZXRA4/w06RyTFVkPGkFNEiI3qRAS5pMC7TQkWqT2UQYfVv0/c0SaE70JFJa17maweiMcP1u0skwbYAVPoyNvduejg61AdiePjqJPyhJyJGyGHi3UmuWI", :student_i_ds=>"1", :user_id=>"1", :user_type=>"2", :"@xsi:type"=>"ax284:UserSessionVO"}
  }

  after(:all) {
    savon.unmock!
  }

  before(:each) {
    fixture = File.read("spec/fixtures/transcript.json")
    message = {
      userSessionVO: {
        userId: "1",
        serviceTicket: "AAABSAX2Ex5NZXRA4/w06RyTFVkPGkFNEiI3qRAS5pMC7TQkWqT2UQYfVv0/c0SaE70JFJa17maweiMcP1u0skwbYAVPoyNvduejg61AdiePjqJPyhJyJGyGHi3UmuWI",
        serverInfo: {
          apiVersion: "2.1.1"
        },
        serverCurrentTime: "2012-12-26T21:47:23.792Z",
        userType: "2"
      },
      studentIDs: "1",
      qil: {
        includes: "1"
      }
    }

    savon.expects(:get_student_data).with(message: message).returns(fixture)

    student = PowerAPI::Data::Student.new("http://powerschool.example", @session)

    @assignment = student.sections[0].assignments[0]
  }

  after(:each) {
    @assignment = nil
  }

  describe "#category" do
    it "is in the Sample category" do
      expect(
        @assignment.category
      ).to eq("Sample")
    end
  end

  describe "#description" do
    it "has one assignment" do
      expect(
        @assignment.description
      ).to eq("Sample Description")
    end
  end

  describe "#name" do
    it "has one assignment" do
      expect(
        @assignment.name
      ).to eq("Sample Assignment")
    end
  end

  describe "#percent" do
    it "has one assignment" do
      expect(
        @assignment.percent
      ).to eq(100)
    end
  end

  describe "#score" do
    it "has one assignment" do
      expect(
        @assignment.score
      ).to eq(100)
    end
  end
end
