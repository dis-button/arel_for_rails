# frozen_string_literal: true

class SimpleRequests::FindingUser
  class << self
    def call(username)
      Application::User.find_by(Application::User.arel_table[:username].eq(username))
    end
  end
end
