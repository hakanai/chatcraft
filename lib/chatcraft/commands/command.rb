module Chatcraft; module Commands

  # Holds a parsed command.
  class Command
    # The un-parsed message.
    attr_reader :message

    def initialize(message)
      @message = message
    end

    # Gets an array of parts of the message. This omits the whitespace separators, removes pairs of double-quotes
    # and unescapes escape sequences.
    def parts
      tokens.map { |t| t.clean_text }
    end

    # Gets a single part of the command by its index. The part will have any double-quotes removed
    # and escape sequences unescaped.
    def [](index)
      parts[index]
    end

    # Gets the rest of the message from the given index. Retains the exact formatting thereof.
    def rest(from_index)
      token = tokens[from_index]
      token ? message[token.first..message.size] : nil
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

        @tokens = raw_tokens.reject { |p| p.raw_text.blank? }
      end

      @tokens
    end

    # Encapsulates one part of the command
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
    end
  end

end; end