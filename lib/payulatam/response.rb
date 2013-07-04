module Payulatam
  class Response
    SIGNATURE_JOIN = "~"

    attr_accessor :client
    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def test?
      params["test"] == "1"
    end

    def currency
      params["currency"]
    end

    def signature
      params["signature"]
    end

    def state_code
      (params["transactionState"] || params["state_pol"]).to_i
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
      self.state == :approved
    end

    def failure?
      [:error, :expired, :declined].include? self.state
    end

    def amount
      self.params["TX_VALUE"].to_f
    end

    def reference
      self.params["referenceCode"]
    end

    def transaccion_id
      self.params["transaccion_id"]
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
