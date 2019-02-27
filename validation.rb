#!/usr/bin/ruby -w

module Validation
  REGEX = /^[a-zа-я0-9]+$/i.freeze

  def valid?(value, type, arg = nil)
    validate!(value, type, arg)
    true
  rescue StandardError => e
    puts e.message
    false
  end

  protected

  def valid_presence(value, *)
    raise 'Вы ничего не ввели!' if value.nil? || value == ''
  end

  def valid_regex(value, regex)
    regex = REGEX if regex.nil?
    raise "Я вас не понимаю!"  if value !~ regex
  end

  def valid_type(value, type)
    raise 'Вы ввели какую-то ерунду!' unless value.is_a?(type)
  end

  def validate!(value, type, arg)
      method = "valid_#{type}".to_sym
      send(method, value, arg)
  end
end

