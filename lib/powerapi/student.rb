module PowerAPI
  class Student
    def initialize(soap_url, soap_session, populate=true)
      @soap_url = soap_url
      @soap_session = soap_session

      if populate
        self.populate()
      end
    end

    def populate()
      transcript = self.fetch_transcript
      self.parse_transcript(transcript)
    end

    def fetch_transcript()
      student_client = Savon.client(
        endpoint: @soap_url + "/pearson-rest/services/PublicPortalServiceJSON?response=application/json",
        namespace: "http://publicportal.rest.powerschool.pearson.com/xsd",
        digest_auth: ["pearson", "m0bApP5"]
      )

      transcript_params = {
        userSessionVO: {
          userId: @soap_session[:user_id],
          serviceTicket: @soap_session[:service_ticket],
          serverInfo: {
            apiVersion: @soap_session[:server_info][:api_version]
          },
          serverCurrentTime: "2012-12-26T21:47:23.792Z", # I really don't know.
          userType: "2"
        },
        studentIDs: @soap_session[:student_i_ds],
        qil: {
          includes: "1"
        }
      }

      transcript = student_client.call(:get_student_data, message: transcript_params).to_xml

      JSON.parse(transcript)
    end

    def parse_transcript(transcript)
      @student_data = transcript["return"]["studentDataVOs"]

      @student_data["student"].delete("@type")

      reporting_terms = {}
      @student_data["reportingTerms"].each do |reporting_term|
        reporting_terms[reporting_term["id"]] = reporting_term["abbreviation"]
      end

      final_grades = {}
      @student_data["finalGrades"].each do |final_grade|
        if final_grades[final_grade["sectionid"]] == nil
          final_grades[final_grade["sectionid"]] = []
        end

        final_grades[final_grade["sectionid"]] << final_grade
      end

      teachers = {}
      @student_data["teachers"].each do |teacher|
        teachers[teacher["id"]] = teacher
      end

      assignment_categories = {}
      @student_data["assignmentCategories"].each do |assignment_category|
        assignment_categories[assignment_category["id"]] = assignment_category
      end

      assignment_scores = {}
      @student_data["assignmentScores"].each do |assignment_score|
        assignment_scores[assignment_score["assignmentId"]] = assignment_score
      end

      assignments = {}
      @student_data["assignments"].each do |assignment|
        if assignments[assignment["sectionid"]] == nil
          assignments[assignment["sectionid"]] = []
        end

        assignments[assignment["sectionid"]] << PowerAPI::Assignment.new({
          :assignment => assignment,
          :category => assignment_categories[assignment["categoryId"]],
          :score => assignment_scores[assignment["id"]],
        })
      end

      sections = []
      @student_data["sections"].each do |section|
        # PowerSchool will return sections that have not started yet.
        # These are stripped since none of the official channels display them.
        if DateTime.parse(section["enrollments"]["startDate"]).strftime("%s").to_i > DateTime.now.strftime("%s").to_i
          next
        end

        sections << PowerAPI::Section.new({
          :section => section,
          :final_grades => final_grades[section["id"]],
          :reporting_terms => reporting_terms,
          :teacher => teachers[section["teacherID"]],
          :assignments => assignments[section["id"]],
        })
      end

      @sections = sections

      return 0
    end

    def sections
      @sections
    end

    def information
      if @student_data != nil
        @student_data["student"]
      end
    end
  end
end
