module NtaRuby
  class Response
    RAW_RESPONSE_COLUMN = %w[
      sequence_number
      corporate_number
      process
      correct
      update_date
      change_date
      name
      name_image_id
      kind
      prefecture_name
      city_name
      street_number
      address_image_id
      prefecture_code
      city_code
      post_code
      address_outside
      address_outside_image_id
      close_date
      close_cause
      successor_corporate_number
      change_cause
      assignment_date
      latest
      en_name
      en_prefecture_name
      en_city_name
      en_address_outside
      furigana
      hihyoji
    ].freeze

    HEADER_COLUMN = %w[
      last_update_date
      count
      divide_number
      divide_size
    ].freeze

    TIME_COLUMN = %w[
      update_date
      change_date
      close_date
      assignment_date
      last_update_date
    ].freeze

    INTEGER_COLUMN = %w[
      sequence_number
      corporate_number
      count
      divide_number
      divide_size
    ].freeze

    attr_accessor *RAW_RESPONSE_COLUMN
    attr_accessor *HEADER_COLUMN

    class << self
      def parse(raw_resp)
        parsed_csv = CSV.parse(raw_resp.body)
        csv_header = parsed_csv.shift

        result = parsed_csv.map { |column| new(column, csv_header) }
        divide_size = csv_header[3].to_i

        [result, divide_size]
      end
    end

    def initialize(column, csv_header)
      RAW_RESPONSE_COLUMN.each_with_index do |attr, idx|
        target_val = column[idx]
        target_val = target_val.to_i if INTEGER_COLUMN.include?(attr) && target_val
        target_val = Time.parse(target_val) if TIME_COLUMN.include?(attr) && target_val
        send("#{attr}=", target_val)
      end
      HEADER_COLUMN.each_with_index do |attr, idx|
        target_val = csv_header[idx]
        target_val = target_val.to_i if INTEGER_COLUMN.include?(attr) && target_val
        target_val = Time.parse(target_val) if TIME_COLUMN.include?(attr) && target_val
        send("#{attr}=",target_val)
      end
    end
  end
end
