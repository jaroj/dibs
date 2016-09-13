# encoding: UTF-8
module Dibs
  module Results
    class Capture < DibsResult

      def result_text(locale = :da)
        return if accepted?
        text = {
          "0"  => { en: "Accepted",
                    da: "Accepteret" },
          "1"  => { en: "No response from acquirer.",
                    da: "Ingen respons fra kreditkortudbyder" },
          "2"  => { en: "Timeout",
                    da: "Timeout" },
          "3"  => { en: "Credit card expired.",
                    da: "Kreditkort er udløbet" },
          "4"  => { en: "Rejected by acquirer.",
                    da: "Afvist af kreditkortudbyder" },
          "5"  => { en: "Authorisation older than 7 days. ",
                    da: "Autorisation ældre end 7 dage." },
          "6"  => { en: "Transaction status on the DIBS server does not allow capture.",
                    da: "Transaction status on the DIBS server does not allow capture." },
          "7"  => { en: "Amount too high.",
                    da: "Beløb er for højt" },
          "8"  => { en: "Error in the parameters sent to the DIBS server. An additional parameter called \"message\" is returned, with a value that may help identifying the error.",
                    da: "Der er fejl i de parametre, som er sendt til DIBS serveren. Et ekstra parameter kaldet \"message\" er sendt retur, med en værdi som kan hjælpe med at identificere fejlen" },
          "9"  => { en: "Order number (orderid) does not correspond to the authorisation order number.",
                    da: "Order number (orderid) does not correspond to the authorisation order number." },
          "10" => { en: "Re-authorisation of the transaction was rejected.",
                    da: "Gen-autorisation af denne transaktion blev afvist" },
          "11" => { en: "Not able to communicate with the acquier.",
                    da: "Ikke muligt at kommunikere med kreditkortudbyder" },
          "12" => { en: "Confirm request error",
                    da: "Confirm request error" },
          "14" => { en: "Capture is called for a transaction which is pending for batch - i.e. capture was already called",
                    da: "Capture is called for a transaction which is pending for batch - i.e. capture was already called" },
          "15" => { en: "Capture was blocked by DIBS.",
                    da: "Capture was blocked by DIBS." },
        }[self.reason]
        (text || {})[locale]
      end

    end
  end
end
