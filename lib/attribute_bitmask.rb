module AttributeBitmask
  module ClassMethods
    def bitmask attribute, *fields
      fields.each_with_index do |field,bit|
        case field
        when /_$/
          bitmask_accessor attribute, field, bit
        when Symbol,String
          bitmask_accessor attribute, field, bit
        when Array
          bitmask_accessor attribute, field[0], bit
          bit_not_accessor attribute, field[1], bit
        end
      end
    end
    def bitmask_accessor attribute, field, bit
      bitmask_reader attribute, field, bit
      bitmask_writer attribute, field, bit
      bitmask_condition attribute, field, bit
    end
    def bitmask_reader attribute, field, bit
    end
    def bitmask_writer attribute, field, bit
    end
    def bitmask_condion attribute, field, bit
    end
    def bit_not_accessor attribute, field, bit
      bit_not_reader attribute, field, bit
      bit_not_writer attribute, field, bit
      bit_not_condition attribute, field, bit
    end
    def bit_not_reader attribute, field, bit
    end
    def bit_not_writer attribute, field, bit
    end
    def bit_not_condion attribute, field, bit
    end
    def bits_accessor attribute, field, bit, bits
      bits_reader attribute, field, bit, bits
      bits_writer attribute, field, bit, bits
      bits_condition attribute, field, bit, bits
    end
    def bits_reader attribute, field, bit, bits
    end
    def bits_writer attribute, field, bit, bits
    end
    def bits_condion attribute, field, bit, bits
    end
  end
end
