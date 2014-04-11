module Dotenv
  class Environment < Hash

    def initialize(filename)
      @filename = filename
      load
    end

    def load
      update Parser.call(read)
    end

    def read
      File.read(@filename)
    end

    def apply
      each { |k,v| ENV[k] ||= v }
    end

    def apply_and_set
      each { |k,v| ENV[k] ||= v; exec "export #{k}=#{v}" }
    end

    def apply!
      each { |k,v| ENV[k] = v }
    end

    def apply_and_set!
      each { |k,v| ENV[k] = v; exec "export #{k}=#{v}" }
    end
  end
end
