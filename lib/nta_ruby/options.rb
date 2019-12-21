module NtaRuby
  class Options
    SEARCH_CONDITION_KINDS = %w[
      number
      history
      from
      to
      req_type
      resp_type
      name
      address
      mode
      kind
      close
      divide
    ]

    attr_accessor *SEARCH_CONDITION_KINDS

    alias change history

    def initialize(type:, **option)
      @number = option[:number] if option[:number]
      @history = option[:history] === true ? 1 : 0
      @from = option[:from]&.strftime('%Y-%m-%d') if option[:from]
      @to = option[:to]&.strftime('%Y-%m-%d') if option[:to]
      @req_type = type
      @resp_type = '02'
      @name = option[:name] if option[:name]
      @address = option[:address] if option[:address]
      @mode = option[:mode] if option[:mode]
      @kind = option[:kind] if option[:kind]
      @close = option[:close] === true ? 1 : 0
      @divide = option[:divide]&.to_i || 1
    end

    def to_h
      search_hash = {
        number: number,
        from: from,
        to: to,
        type: resp_type,
        name: name,
        address: address,
        mode: mode,
        kind: kind,
        close: close,
        divide: divide
      }

      if req_type == :number
        search_hash.merge({ history: history })
      elsif req_type == :name
        search_hash.merge({ change: change })
      else
        search_hash
      end
    end
  end
end
