# encoding: UTF-8
module Dibs
  module Results
    class Capture < DibsResult

      def result_text
        return if accepted?
        {
          "0"  => "Accepted",
          "1"  => "No response from acquirer.",
          "2"  => "Timeout",
          "3"  => "Credit card expired.",
          "4"  => "Rejected by acquirer.",
          "5"  => "Authorisation older than 7 days. ",
          "6"  => "Transaction status on the DIBS server does not allow capture.",
          "7"  => "Amount too high.",
          "8"  => "Error in the parameters sent to the DIBS server. An additional parameter called \"message\" is returned, with a value that may help identifying the error.",
          "9"  => "Order number (orderid) does not correspond to the authorisation order number.",
          "10" => "Re-authorisation of the transaction was rejected.",
          "11" => "Not able to communicate with the acquier.",
          "12" => "Confirm request error",
          "14" => "Capture is called for a transaction which is pending for batch - i.e. capture was already called",
          "15" => "Capture was blocked by DIBS."
        }[self.reason]
      end

    end
  end
end
