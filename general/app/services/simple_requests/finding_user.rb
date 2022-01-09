class SimpleRequests::FindingUser
  class << self
    def call
      Application::User.find_by(Application::User.arel_table[:username].eq('martins.kruze'))
    end
  end
end
