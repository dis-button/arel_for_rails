# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimpleRequests::FindingUser do
  describe '.call' do
    subject { described_class.call(username) }

    let(:username) { 'martins.kruze' }
    let!(:incorrect_user) { FactoryBot.create(:user) }

    context 'when user, with the username exists' do
      let!(:correct_user) { FactoryBot.create(:user, username: username) }

      it { is_expected.to eq(correct_user) }
    end

    context 'when user with the username does not exist' do
      it { is_expected.to eq(nil) }
    end
  end
end
