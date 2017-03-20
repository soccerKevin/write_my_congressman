module MessageHelper
  def defaults
    @defaults = {
      name: current_user&.name,
      email: current_user&.email,
      address_line: current_user&.address&.line,
      city: current_user&.address&.city,
      state: current_user&.address&.state,
      zip: current_user&.address&.zip,
      subject: nil,
      body: nil
    }
  end
end
