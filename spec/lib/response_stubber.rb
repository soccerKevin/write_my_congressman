require 'webmock/rspec'

module ResponseStubber
  def stub_json_response(response)
    stub_request(:get, /www.test.com/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return body: response, headers: { content_type: 'application/json'
      }
  end

  def stubbed_response
    @stubbed_response ||= {}
  end

  def json_response
    JSON.parse stubbed_response
  end
end
