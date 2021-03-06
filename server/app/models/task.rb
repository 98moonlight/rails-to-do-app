# frozen_string_literal: true

# Validates that the doneAt field is valid
class DoneAtDateTime < ActiveModel::Validator
  def validate(record)
    if record.is_done && !record.done_at
      record.errors.add :is_done, 'Need a datetime to track when it has been completed'
    elsif !record.is_done && record.done_at
      record.errors.add :is_done, 'Need to remove datetime when it is not complete'
    end
  end
end

# Validates that the task is tagged with the user's tags
class UsedPersonalTags < ActiveModel::Validator
  def validate(record)
    return unless record.tags.size.positive? && !record.tags.reject { |t| t.user.id == record.user.id }.empty?

    record.errors.add :tags, 'One or more of the given tags do not belong to the user'
  end
end

# Model for task
class Task < ApplicationRecord
  include ActiveModel::Validations

  validates :name, presence: true

  validates_with DoneAtDateTime

  belongs_to :user

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :tags
  # rubocop:enable Rails/HasAndBelongsToMany
  validates_with UsedPersonalTags
end
