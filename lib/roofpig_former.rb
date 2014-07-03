module RCDB
  class RoofpigFormer
    class << self
      def roofpig_form(solve)
        roofpig_config_from_params(
          "alg" => escape_chars(remove_comments(solve.canonical_solution)),
        )
      end

      private

      def roofpig_config_from_params(params)
        url_params = params
          .reject { |k, v| v.blank? }
          .map { |k, v| "#{k}=#{v}"}.join("|")
        url_params
      end

      def remove_comments(alg)
        alg.gsub(%r(//.*?$), "")
      end

      def escape_chars(alg)
        alg.gsub("\n"," ").gsub(/[udlrfb]/) { |c| "#{c.upcase}w" }
      end

    end
  end
end
