module PowerAPI
  module Data
    class Assignment
      def initialize(details)
        @details = details
      end

      def category
        @details[:category]["name"]
      end

      def description
        @details[:assignment]["description"]
      end

      def name
        @details[:assignment]["name"]
      end

      def percent
        @details[:score]["percent"]
      end

      def score
        @details[:score]["score"]
      end
    end
  end
end
