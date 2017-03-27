class Message < ActiveRecord::Base
  include ActiveModel::Validations
  has_and_belongs_to_many :legislators
  validates_presence_of :subject, :body, :name, :email, :address_line, :city, :state, :zip

  class << self
    def form_topics
      Legislators::Email.user_options
    end
  end

  def send_email
    @emails = legislators.map do |l|
      email = Legislators::EmailForm.new self, l
      email.fillout_and_send
      email
    end
  end

  def sent?
    captchas.empty? && @emails.select{ |e| e.sent? }.any?
  end

  def captchas
    return [] unless @emails
    @emails.map{ |e| e.captcha }.compact
  end

  def first_name
    parsed_name&.first
  end

  def last_name
    parsed_name&.last
  end

  def address
    @address ||= Address.new line: address_line, city: city, state: state, zip: zip
  end

private

  def parsed_name
    @parsed_name = HumanNameParser.parse name
  end
end
