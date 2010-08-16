module AttributeBitmask
  def self.included(base)  
    base.send :extend, ClassMethods 
  end 

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
      mask = 2 ** bit
      self.module_eval <<-READER, __FILE__, __LINE__ + 1
        def #{field}
          #{mask} & #{attribute} == #{mask}
        end
      READER
    end
    def bitmask_writer attribute, field, bit
      mask = 2 ** bit
      self.module_eval <<-WRITER, __FILE__, __LINE__ + 1
        def #{field}= v; 
          case v 
          when true,'true','1',1 
            self.#{attribute} |= #{mask} 
          else 
            self.#{attribute} &= ~#{mask}
          end
        end
      WRITER
    end
    def bitmask_condition attribute, field, bit
      mask = 2 ** bit
      self.module_eval <<-READER, __FILE__, __LINE__ + 1
        def #{field}?
          #{mask} & #{attribute} == #{mask}
        end
      READER
    end

    def bit_not_accessor attribute, field, bit
      bit_not_reader attribute, field, bit
      bit_not_writer attribute, field, bit
      bit_not_condition attribute, field, bit
    end
    def bit_not_reader attribute, field, bit
      mask = 2 ** bit
      self.module_eval <<-READER, __FILE__, __LINE__ + 1
        def #{field}
          #{mask} & #{attribute} == 0
        end
      READER
    end
    def bit_not_writer attribute, field, bit
      mask = 2 ** bit
      self.module_eval <<-WRITER, __FILE__, __LINE__ + 1
        def #{field}= v; 
          case v 
          when true,'true','1',1 
            self.#{attribute} &= ~#{mask}
          else 
            self.#{attribute} |= #{mask} 
          end
        end
      WRITER
    end
    def bit_not_condition attribute, field, bit
      mask = 2 ** bit
      self.module_eval <<-READER, __FILE__, __LINE__ + 1
        def #{field}?
          #{mask} & #{attribute} == 0
        end
      READER
    end

    def bits_accessor attribute, field, bit, bits
      bits_reader attribute, field, bit, bits
      bits_writer attribute, field, bit, bits
      bits_condition attribute, field, bit, bits
    end
    def bits_reader attribute, field, bit, bits
      mask = ( 2 ** bits - 1 ) << bit
      self.module_eval <<-READER, __FILE__, __LINE__ + 1
        def #{field}
          #{mask} & #{attribute} >> #{bit}
        end
      READER
    end
    def bits_writer attribute, field, bit, bits
      mask = ( 2 ** bits - 1 ) << bit
      filter = ( 2 ** bits - 1 ) 
      self.module_eval <<-WRITER, __FILE__, __LINE__ + 1
        def #{field}= v; 
          v = v.to_i
          if v > #{filter}
            v = #{filter}
          elsif v < 0
            v = 0
          end
          v = v << #{bit}
          self.#{attribute} = #{attribute} & ~#{mask} | v
        end
      WRITER
    end
    def bits_condition attribute, field, bit, bits
      mask = ( 2 ** bits - 1 ) << bit
      self.module_eval <<-READER, __FILE__, __LINE__ + 1
        def #{field}?
          #{mask} & #{attribute} >> #{bit}
        end
      READER
    end

  end

end
ActiveRecord::Base.send :include, AttributeBitmask
