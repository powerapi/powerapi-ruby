module PowerAPI
  module Data
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

        assignment_categories = PowerAPI::Parser.assignment_categories(@student_data["assignmentCategories"])
        assignment_scores = PowerAPI::Parser.assignment_scores(@student_data["assignmentScores"])
        final_grades = PowerAPI::Parser.final_grades(@student_data["finalGrades"])
        reporting_terms = PowerAPI::Parser.reporting_terms(@student_data["reportingTerms"])
        teachers = PowerAPI::Parser.teachers(@student_data["teachers"])

        assignments = PowerAPI::Parser.assignments(@student_data["assignments"], assignment_categories, assignment_scores)

        @sections = PowerAPI::Parser.sections(@student_data["sections"], assignments, final_grades, reporting_terms, teachers)

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
end
