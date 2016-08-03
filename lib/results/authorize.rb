# encoding: UTF-8
module Dibs
  module Results
    class Authorize < DibsResult

      def result_text(locale = :da)
        return if accepted?
        text = {
          "0"  => { en: "Rejected by acquirer.",
                    da: "Afvist af kreditkort-udbyder" },
          "1"  => { en: "Communication problems.",
                    da: "Kommunikationsproblemer" },
          "2"  => { en: "Error in the parameters sent to the DIBS server. An additional parameter called \"message\" is returned, with a value that may help identifying the error.",
                    da: "Der er fejl i de parametre, som er sendt til DIBS serveren. Et ekstra parameter kaldet \"message\" er sendt retur, med en værdi som kan hjælpe med at identificere fejlen" },
          "3"  => { en: "Error at the acquirer.",
                    da: "Fejl hos kreditkortudbydere" },
          "4"  => { en: "Credit card expired.",
                    da: "Kreditkort er udløbet" },
          "5"  => { en: "Your shop does not support this credit card type, the credit card type could not be identified, or the credit card number was not modulus correct.",
                    da: "Fejl på grund af at dit køb ikke er supporteret af denne kreditkort-type, eller fordi kreditkortet skal identificeres eller fordi kreditkortnummeret var ikke korrekt" },
          "6"  => { en: "Instant capture failed.",
                    da: "Instant capture failed." },
          "7"  => { en: "The order number (orderid) is not unique.",
                    da: "Ordrenummeret er ikke unikt." },
          "8"  => { en: "There number of amount parameters does not correspond to the number given in the split parameter.",
                    da: "There number of amount parameters does not correspond to the number given in the split parameter." },
          "9"  => { en: "Control numbers (cvc) are missing.",
                    da: "Kontrolnumre (cvc) mangler at blive udfyldt" },
          "10" => { en: "The credit card does not comply with the credit card type.",
                    da: "The credit card does not comply with the credit card type." },
          "11" => { en: "Declined by DIBS Defender.",
                    da: "Afvist af DIBS Defender" },
          "20" => { en: "Cancelled by user at 3D Secure authentication step",
                    da: "Annulleret af bruger ved 3D Secure authentication step" },
        }[self.reason]
        (text || {})[locale]
      end

    end
  end
end

