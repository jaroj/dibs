# encoding: UTF-8
module Dibs
  module Results
    class Authorize < DibsResult

      def result_text
        return if accepted?
        {
          "0"  => "Rejected by acquirer.",
          "1"  => "Communication problems.",
          "2"  => "Error in the parameters sent to the DIBS server. An additional parameter called \"message\" is returned, with a value that may help identifying the error.",
          "3"  => "Error at the acquirer.",
          "4"  => "Credit card expired.",
          "5"  => "Your shop does not support this credit card type, the credit card type could not be identified, or the credit card number was not modulus correct.",
          "6"  => "Instant capture failed.",
          "7"  => "The order number (orderid) is not unique.",
          "8"  => "There number of amount parameters does not correspond to the number given in the split parameter.",
          "9"  => "Control numbers (cvc) are missing.",
          "10" => "The credit card does not comply with the credit card type.",
          "11" => "Declined by DIBS Defender.",
          "20" => "Cancelled by user at 3D Secure authentication step"
        }[self.reason]
      end

    end
  end
end
