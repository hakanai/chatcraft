module Chatcraft

  # Holds a parsed message.
  class Message
    # The un-parsed message.
    attr_reader :message

    # Initialises from the provided message.
    def initialize(message)
      # Parsing is all done lazily, though perhaps not as lazily as possible.
      @message = message
    end

    # Gets an array of parts of the message. This omits the whitespace separators, removes pairs of double-quotes
    # and unescapes escape sequences.
    def parts
      tokens.map { |t| t.clean_text }
    end

    # Gets a single part of the message by its index. The part will have any double-quotes removed
    # and escape sequences unescaped.
    def [](index)
      parts[index]
    end

    # Gets the rest of the message from the given index. Retains the exact formatting thereof.
    def rest(from_index)
      token = tokens[from_index]
      token ? message[token.first..message.size] : nil
    end

    # Tries to match a message against a pattern. The pattern can contain string fragments, in which case
    # we will attempt to match them against parts. If it contains symbols, the symbols are returned in the hash
    # which is returned on a successful match. If the message doesn't match, we return nil.
    def match(pattern)
      result = {}
      # There might be a more Rubyish way to do this one.
      pattern.each_with_index do |pattern_part, index|
        if pattern_part.is_a?(String)
          if self[index] != pattern_part
            result = nil
            break
          end
        elsif pattern_part.is_a?(Symbol)
          result[pattern_part] = self[index]
        else
          raise "Unsupported pattern part #{pattern_part} of type #{pattern_part.class}"
        end
      end
      result
    end

    def to_s
      message
    end
private

    # Gets an array of parts of the message. This omits the whitespace separators, removes pairs of double-quotes
    # and unescapes escape sequences.
    def tokens
      if !@tokens
        token_regexp = /\s+                 |  # whitespace
                        \"(?:[^\"]|\\.)*\"  |  # quoted token
                        (?:[^\\\s\"]|\\.)+     # unquoted token
                        /x

        off = 0
        raw_tokens = @message.scan(token_regexp).map do |tok|
          start = off
          off += tok.size
          clean_text = tok.gsub(/^\"(.*)\"$/, '\\1').gsub(/\\(.)/, '\\1')
          Token.new(start, off - 1, tok, clean_text)
        end

        @tokens = raw_tokens.reject { |p| p.separator? }
      end

      @tokens
    end

    # Encapsulates one part of the message
    class Token
      attr_reader :first
      attr_reader :last
      attr_reader :raw_text
      attr_reader :clean_text

      def initialize(first, last, raw_text, clean_text)
        @first = first
        @last = last
        @raw_text = raw_text
        @clean_text = clean_text
      end

      def separator?
        raw_text.blank?
      end
    end
  end

end