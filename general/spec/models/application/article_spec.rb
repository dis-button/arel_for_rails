# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Article, type: :model do
  describe 'associations' do
    it 'has_many comments' do
      is_expected.to(
        have_many(:comments).
        dependent(:destroy).
        class_name('Application::Comment')
      )
    end

    it 'belong to author' do
      is_expected.to(
        belong_to(:author).
        class_name('Application::User')
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:subject) }
  end
end
