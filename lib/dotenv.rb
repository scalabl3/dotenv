require 'dotenv/parser'
require 'dotenv/environment'

module Dotenv
  def self.load(*filenames)
    with(*filenames) { |f| Environment.new(f).apply if File.exists?(f) }
  end

  # same as `load`, but raises Errno::ENOENT if any files don't exist
  def self.load!(*filenames)
    with(*filenames) { |f| Environment.new(f).apply }
  end

  # same as `load`, but also execute shell export statements 
  def self.load_and_set(*filenames)
    with(*filenames) { |f| Environment.new(f).apply_and_set if File.exists?(f)}
  end

	# same as 'load!', but also execute shell export statements
  def self.load_and_set!(*filenames)
    with(*filenames) { |f| Environment.new(f).apply_and_set}
  end

  # same as `load`, but will override existing values in `ENV`
  def self.overload(*filenames)
    with(*filenames) { |f| Environment.new(f).apply! if File.exists?(f) }
  end

protected

  def self.with(*filenames, &block)
    filenames << '.env' if filenames.empty?

    filenames.inject({}) do |hash, filename|
      filename = File.expand_path filename
      hash.merge(block.call(filename) || {})
    end
  end
end
