class NumberRecognizer
  module FormatDsl
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def add_format(options={})
        formats << {:country=>options[:country], :mobile=>options[:mobile], :format=>options[:format]}
      end

      def formats
        @formats ||= []
      end
    end
  end
end