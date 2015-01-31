module PowerAPI
  module Data
    class Section
      def initialize(details)
        @details = details

        # Occasionally, a section won't have any final_grades objects
        if @details[:final_grades] != nil
          @final_grades = {}

          @details[:final_grades].each do |final_grade|
            @final_grades[
              @details[:reporting_terms][final_grade["reportingTermId"]]
            ] = final_grade["percent"]
          end
        else
          @final_grades = nil
        end
      end

      def assignments
        @details[:assignments]
      end

      def expression
        @details[:section]["expression"]
      end

      def final_grades
        @final_grades
      end

      def name
        @details[:section]["schoolCourseTitle"]
      end

      def room_name
        @details[:section]["roomName"]
      end

      def teacher
        {
          :first_name => @details[:teacher]["firstName"],
          :last_name => @details[:teacher]["lastName"],
          :email => @details[:teacher]["email"],
          :school_phone => @details[:teacher]["schoolPhone"]
        }
      end
    end
  end
end
