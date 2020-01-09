# frozen_string_literal: true

# Validator for inclusion of array values
class ArrayInclusionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if !value.nil? && value.all? { |val| options[:in].include?(val) }

    record.errors[attribute] <<
      (options[:message] || 'is not included in the list')
  end
end
