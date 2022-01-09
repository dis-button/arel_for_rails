# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Comment, type: :model do
  describe 'associations' do
    it 'belong to commenter' do
      is_expected.to(
        belong_to(:commenter).
        class_name('Application::User')
      )
    end

    it 'belong to commenter' do
      is_expected.to(
        belong_to(:article).
        class_name('Application::Article')
      )
    end

    it 'belong to parent' do
      is_expected.to(
        belong_to(:parent).
        class_name('Application::Comment').
        optional
      )
    end

    it 'has_many children comments' do
      is_expected.to(
        have_many(:children).
        dependent(:destroy).
        with_foreign_key(:parent_id).
        class_name('Application::Comment')
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end
end
