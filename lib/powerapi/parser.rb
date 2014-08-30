module PowerAPI
  class Parser
    def self.assignments(raw_assignments, assignment_categories, assignment_scores)
      assignments = {}

      raw_assignments.each do |assignment|
        if assignments[assignment["sectionid"]] == nil
          assignments[assignment["sectionid"]] = []
        end

        assignments[assignment["sectionid"]] << PowerAPI::Assignment.new({
          :assignment => assignment,
          :category => assignment_categories[assignment["categoryId"]],
          :score => assignment_scores[assignment["id"]],
        })
      end

      assignments
    end

    def self.assignment_categories(raw_assignment_categories)
      assignment_categories = {}

      raw_assignment_categories.each do |assignment_category|
        assignment_categories[assignment_category["id"]] = assignment_category
      end

      assignment_categories
    end

    def self.assignment_scores(raw_assignment_scores)
      assignment_scores = {}

      raw_assignment_scores.each do |assignment_score|
        assignment_scores[assignment_score["assignmentId"]] = assignment_score
      end

      assignment_scores
    end

    def self.final_grades(raw_final_grades)
      final_grades = {}

      raw_final_grades.each do |final_grade|
        if final_grades[final_grade["sectionid"]] == nil
          final_grades[final_grade["sectionid"]] = []
        end

        final_grades[final_grade["sectionid"]] << final_grade
      end

      final_grades
    end

    def self.reporting_terms(raw_reporting_terms)
      reporting_terms = {}

      raw_reporting_terms.each do |reporting_term|
        reporting_terms[reporting_term["id"]] = reporting_term["abbreviation"]
      end

      reporting_terms
    end

    def self.sections(raw_sections, assignments, final_grades, reporting_terms, teachers)
      sections = []

      raw_sections.each do |section|
        # PowerSchool will return sections that have not started yet.
        # These are stripped since none of the official channels display them.
        if DateTime.parse(section["enrollments"]["startDate"]).strftime("%s").to_i > DateTime.now.strftime("%s").to_i
          next
        end

        sections << PowerAPI::Section.new({
          :assignments => assignments[section["id"]],
          :final_grades => final_grades[section["id"]],
          :reporting_terms => reporting_terms,
          :section => section,
          :teacher => teachers[section["teacherID"]]
        })
      end

      sections
    end

    def self.teachers(raw_teachers)
      teachers = {}

      raw_teachers.each do |teacher|
        teachers[teacher["id"]] = teacher
      end

      teachers
    end
  end
end
