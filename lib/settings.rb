#!/usr/bin/env ruby
require 'yaml'
require 'facets/hash/deep_rekey'

module Settings
  extend self

  @_settings = {}
  attr_reader :_settings

  def load!(filename, options = {})
    newsets = YAML::load_file(filename).deep_rekey
    newsets = newsets[options[:env].to_sym] if \
                                               options[:env] && \
                                               newsets[options[:env].to_sym]
    deep_merge!(@_settings, newsets)
  end

  def deep_merge!(target, data)
    merger = proc{|key, v1, v2|
      Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    target.merge! data, &merger
  end

  def method_missing(name, *args, &block)
    @_settings[name.to_sym] ||
    fail(NoMethodError, "unknown configuration root #{name}", caller)
  end

end
