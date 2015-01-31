require "spec_helper"

describe PowerAPI::Data::Student do
  include Savon::SpecHelper

  before(:all) {
    savon.mock!

    @session = {:locale=>nil, :server_current_time=>"2014-08-24T03:01:25.007Z", :server_info=>{:api_version=>"2.1.1", :day_light_savings=>"0", :parent_saml_end_point=>nil, :raw_offset=>"-14400000", :server_time=>"2014-08-24T20:19:32.640Z", :student_saml_end_point=>nil, :teacher_saml_end_point=>nil, :time_zone_name=>"BOT", :"@xsi:type"=>"ax287:ServerInfo"}, :service_ticket=>"AAABSAX2Ex5NZXRA4/w06RyTFVkPGkFNEiI3qRAS5pMC7TQkWqT2UQYfVv0/c0SaE70JFJa17maweiMcP1u0skwbYAVPoyNvduejg61AdiePjqJPyhJyJGyGHi3UmuWI", :student_i_ds=>"1", :user_id=>"1", :user_type=>"2", :"@xsi:type"=>"ax284:UserSessionVO"}
  }

  after(:all) {
    savon.unmock!
  }

  describe "#initialize" do
    before(:each) {
      @student = PowerAPI::Data::Student.new("http://powerschool.example", @session, false)
    }

    after(:each) {
      @student = nil
    }

    it "returns nil for sections" do
      expect(
        @student.sections
      ).to be_nil
    end

    it "returns nil for information" do
      expect(
        @student.information
      ).to be_nil
    end
  end

  describe "#fetch_transcript" do
    it "returns something that looks like a transcript" do
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

      student = PowerAPI::Data::Student.new("http://powerschool.example", @session, false)

      transcript = student.fetch_transcript["return"]["studentDataVOs"]

      expect(transcript).to include(
        "assignmentCategories", "assignments", "assignmentScores",
        "finalGrades", "reportingTerms", "schools",
        "sections", "student", "teachers"
      )
    end
  end

  describe "#parse_transcript" do
    before(:each) {
      fixture = File.read("spec/fixtures/transcript.json")
      fixture = JSON.parse(fixture)

      @student = PowerAPI::Data::Student.new("http://powerschool.example", @session, false)

      @student.parse_transcript(fixture)
    }

    after(:each) {
      @student = nil
    }

    it "has two sections" do
      expect(
        @student.sections.length
      ).to be(2)
    end

    it "returns the student's information" do
      information = {
        "currentGPA"=>"4.0",
        "currentMealBalance"=>0,
        "currentTerm"=>"S1",
        "dcid"=>1,
        "dob"=>"1970-01-01T00:00:00.000Z",
        "ethnicity"=>"US",
        "firstName"=>"John",
        "gender"=>"M",
        "gradeLevel"=>12,
        "id"=>1,
        "lastName"=>"Doe",
        "middleName"=>{"@nil"=>"true"},
        "photoDate"=>{"@nil"=>"true"},
        "startingMealBalance"=>0
      }
      expect(
        @student.information
      ).to eq(information)
    end
  end
end
