# encoding: UTF-8
module Dibs
  module Results
    class Delticket < DibsResult

      def result_text(locale = :da)
        return if accepted?
        return self.message if @result_parsed.has_key?(:message)
        status
      end

    end
  end
end

