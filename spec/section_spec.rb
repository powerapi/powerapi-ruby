require "spec_helper"

describe PowerAPI::Section do
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

    student = PowerAPI::Student.new("http://powerschool.example", @session)

    @section0 = student.sections[0]
    @section1 = student.sections[1]
  }

  after(:each) {
    @section0 = nil
  }

  describe "#assignments" do
    it "has one assignment" do
      expect(
        @section0.assignments.count
      ).to be(1)
    end

    it "has a PowerAPI::Assignment instance at index 0" do
      expect(
        @section0.assignments[0]
      ).to be_an_instance_of(PowerAPI::Assignment)
    end
  end

  describe "#final_grades" do
    it "has one final grade at index 0" do
      expect(
        @section0.final_grades.length
      ).to be(1)
    end

    it "returns nil for final grades at index 1" do
      expect(
        @section1.final_grades
      ).to be_nil
    end

    it "has a Q1 key at index 0" do
      expect(
        @section0.final_grades
      ).to include("Q1")
    end

    it "has a Q1 score of 100% at index 0" do
      expect(
        @section0.final_grades["Q1"]
      ).to be(100)
    end
  end

  describe "#name" do
    it "is called Sample Section at index 0" do
      expect(
        @section0.name
      ).to eq("Sample Section")
    end
  end

  describe "#room_name" do
    it "is in room HS101 at index 0" do
      expect(
        @section0.room_name
      ).to eq("HS101")
    end
  end

  describe "#teacher" do
    it "has the first name Mary at index 0" do
      expect(
        @section0.teacher[:first_name]
      ).to eq("Mary")
    end

    it "has the last name Mary at index 0" do
      expect(
        @section0.teacher[:last_name]
      ).to eq("Sue")
    end

    it "has the email msue@example.edu at index 0" do
      expect(
        @section0.teacher[:email]
      ).to eq("msue@example.edu")
    end

    it "has the school phone +00000000000 at index 0" do
      expect(
        @section0.teacher[:school_phone]
      ).to eq("+00000000000")
    end
  end
end
