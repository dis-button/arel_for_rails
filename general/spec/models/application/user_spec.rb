# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::User, type: :model do
  describe 'associations' do
    it 'has_many comments' do
      is_expected.to(
        have_many(:comments).
        dependent(:destroy).
        class_name('Application::Comment').
        with_foreign_key(:commenter_id)
      )
    end

    it 'has_many articles' do
      is_expected.to(
        have_many(:articles).
        dependent(:destroy).
        class_name('Application::Article').
        with_foreign_key(:author_id)
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }

    context 'with existing record' do
      before { create(:user) }

      it { is_expected.to validate_uniqueness_of(:username) }
    end
  end
end
