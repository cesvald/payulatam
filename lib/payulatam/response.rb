module Payulatam
  class Response
    SIGNATURE_JOIN = "~"

    attr_accessor :client
    attr_accessor :params

    def initialize(client, params = {})
      self.client = client
      self.params = params
    end

    def test?
      self.params["test"] == "1"
    end

    def currency
      self.params["currency"]
    end

    def signature
      self.params["signature"] || self.params["sign"]
    end

    def state_code
      (self.params["transactionState"] || self.params["state_pol"]).to_i
    end

    def state
      case state_code
      when 2    then :new
      when 101  then :fx_converted
      when 102  then :verified
      when 103  then :submitted
      when 4    then :approved
      when 6    then :declined
      when 104  then :error
      when 7    then :pending
      when 5    then :expired
      end
    end

    def success?
      self.valid? && self.state == :approved
    end

    def failure?
      self.valid? && [:error, :expired, :declined].include?(self.state)
    end

    def amount
      (self.params["TX_VALUE"] || self.params["value"]).to_f
    end

    def reference
      self.params["referenceCode"] || self.params["reference_sale"]
    end

    def transaction_id
      (self.params["transactionId"] || self.params["transaction_id"])
    end

    def valid?
      self.signature == Digest::MD5.hexdigest([
        self.client.key,
        self.client.merchant_id,
        self.reference,
        ("%.1f" % self.amount),
        self.currency,
        self.state_code
      ].join(SIGNATURE_JOIN))
    end
  end
end
