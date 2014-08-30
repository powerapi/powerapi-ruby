require "spec_helper"

describe PowerAPI::Parser do
  before(:all) {
    fixture = JSON.parse(File.read("spec/fixtures/transcript.json"))

    @student_data = fixture["return"]["studentDataVOs"]

    @assignment_categories = {
      1=>{
        "@type"=>"ax290:AsmtCatVO",
        "abbreviation"=>"S",
        "description"=>"Testing assignments",
        "id"=>1,
        "name"=>"Sample"
      }
    }

    @assignment_scores = {
      1=>{
        "@type"=>"ax290:AssignmentScoreVO",
        "assignmentId"=>1,
        "collected"=>false,
        "comment"=>{"@nil"=>"true"},
        "exempt"=>false,
        "id"=>1,
        "late"=>false,
        "letterGrade"=>100,
        "missing"=>false,
        "percent"=>100,
        "score"=>100,
        "scoretype"=>0
      }
    }

    @final_grades = {1=>[{"@type"=>"ax290:FinalGradeVO", "commentValue"=>{"@nil"=>"true"}, "dateStored"=>{"@nil"=>"true"}, "grade"=>100, "id"=>1, "percent"=>100, "reportingTermId"=>1, "sectionid"=>1, "storeType"=>2}]}

    @reporting_terms = {1=>"Q1"}

    @teachers = {1=>{"@type"=>"ax290:TeacherVO", "email"=>"msue@example.edu", "firstName"=>"Mary", "id"=>1, "lastName"=>"Sue", "schoolPhone"=>"+00000000000"}}

  }

  describe "#assignments" do
    before(:each) {
      @assignments = PowerAPI::Parser.assignments(@student_data["assignments"], @assignment_categories, @assignment_scores)
    }

    it "has one assignment" do
      expect(
        @assignments.count
      ).to be(1)
    end

    it "has Sample as the category at index 0" do
      expect(
        @assignments[1][0].category
      ).to eq("Sample")
    end

    it "has Sample as the description at index 0" do
      expect(
        @assignments[1][0].description
      ).to eq("Sample Description")
    end

    it "has Sample as the name at index 0" do
      expect(
        @assignments[1][0].name
      ).to eq("Sample Assignment")
    end

    it "has Sample as the percent at index 0" do
      expect(
        @assignments[1][0].percent
      ).to eq(100)
    end

    it "has Sample as the score at index 0" do
      expect(
        @assignments[1][0].score
      ).to eq(100)
    end
  end

  describe "#assignment_categories" do
    it "properly parses the assignment categories" do
      expect(
        PowerAPI::Parser.assignment_categories(@student_data["assignmentCategories"])
      ).to eq(@assignment_categories)
    end
  end

  describe "#assignment_scores" do
    it "properly parses the assignment scores" do
      expect(
        PowerAPI::Parser.assignment_scores(@student_data["assignmentScores"])
      ).to eq(@assignment_scores)
    end
  end

  describe "#final_grades" do
    it "properly parses the final grades" do
      expect(
        PowerAPI::Parser.final_grades(@student_data["finalGrades"])
      ).to eq(@final_grades)
    end
  end

  describe "#reporting_terms" do
    it "properly parses the reporting terms" do
      expect(
        PowerAPI::Parser.reporting_terms(@student_data["reportingTerms"])
      ).to eq(@reporting_terms)
    end
  end

  describe "#sections" do
    before(:each) {
      assignments = PowerAPI::Parser.assignments(@student_data["assignments"], @assignment_categories, @assignment_scores)
      @sections = PowerAPI::Parser.sections(@student_data["sections"], assignments, @final_grades, @reporting_terms, @teachers)
    }

    it "contains two items" do
      expect(
        @sections.length
      ).to eq(2)
    end

    it "contains a section at index 0" do
      expect(
        @sections[0]
      ).to be_a(PowerAPI::Section)
    end

    it "contains a section at index 1" do
      expect(
        @sections[0]
      ).to be_a(PowerAPI::Section)
    end
  end

  describe "#teachers" do
    it "properly parses the teachers" do
      expect(
        PowerAPI::Parser.teachers(@student_data["teachers"])
      ).to eq(@teachers)
    end
  end
end
