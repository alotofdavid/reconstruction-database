module ReconDatabase 
  Sequel.extension :blank
  class Solve < Sequel::Model
    include FormattingUtils
    many_to_one :average

    def effective_value
      if plus_two?
        time + 2
      else
        time
      end
    end

    def dnf?
      penalty == "dnf"
    end

    def plus_two?
      penalty == "+2"
    end

    def format
      if dnf?
        "DNF(#{format_time(effective_value)})"
      elsif plus_two?
        "#{format_time(effective_value)}+"
      else
        format_time(effective_value)
      end
    end

    class << self
      def possible_values_for(field)
        select(field).group_by(field).map{|entry| entry[field]}.to_a
      end

      def queryable_fields
        %i(solver puzzle competition)
      end

      def request(params)
        result = where(queryable_fields.each_with_object({}) do |field, new_params|
          new_params[field] = params[field] unless params[field].blank?
        end)
        time_query(result, params)
      end

      private
      
      def time_query(dataset, params)
        specifier = params["time-specifier"]
        value = params["time-value"]
        unless specifier.blank? || value.blank?
          dataset.where("time #{sign_for(specifier)} ?", value)
        else
          dataset
        end
      end

      def sign_for(comparison)
        case comparison
        when "less"
          "<"
        when "greater"
          ">"
        when "equal"
          "="
        else
          raise "bad comparison"
        end
      end
    end
  end
end