class SimpleRequests::FindingUser
  class << self
    def call
      User.find_by(User.arel_table[:username].eq('martins.kruze'))
    end
  end
end
