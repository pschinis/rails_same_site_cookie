RSpec.describe RailsSameSiteCookie::Middleware do
  let(:app) { MockRackApp.new }
  subject { described_class.new(app) }

  context "when configured with a regex" do
    let(:request) { Rack::MockRequest.new(subject) }
    before(:each) do
      RailsSameSiteCookie.configure do |config|
        config.user_agent_regex = /StrongrFastrApp/
      end
    end

    it "adds SameSite=None to cookies for requests whose UA matches regex" do
      response = request.post("/some/path", 'HTTP_USER_AGENT' => 'StrongrFastrApp')
      expect(response['Set-Cookie']).to match(/;\s*samesite=none/i)
    end

    it "doesn't add SameSite=None if request is missing regex" do
      response = request.post("/some/path")
      expect(response['Set-Cookie']).not_to match(/;\s*samesite=none/i)
    end
  end

  context "when configured without a regex" do
    let(:request) { Rack::MockRequest.new(subject) }
    before(:each) do
      RailsSameSiteCookie.configure do |config|
        config.user_agent_regex = nil
      end
    end

    it "adds SameSite=None to cookies for all requests" do
      response = request.post("/some/path", 'HTTP_USER_AGENT' => '')
      expect(response['Set-Cookie']).to match(/;\s*samesite=none/i)
    end
  end

  context "when configured to generate legacy cookie" do
    let(:request) { Rack::MockRequest.new(subject) }
    before(:each) do
      RailsSameSiteCookie.configure do |config|
        config.generate_legacy_cookie = true
      end
    end

    context "when configured without same site support user agent" do
      let(:response) { request.post("/some/path", 'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Safari/605.1.15') }
      it "adds legacy cookies for all requests" do
        expect(response['Set-Cookie']).to match(/;\s*thiscookie-legacy=/i)
      end

      it "does not add SameSite=None to cookies for all requests" do
        expect(response['Set-Cookie']).to_not match(/;\s*samesite=none/i)
      end
    end

    context "when configured with same site support user agent" do
      it "adds legacy cookies for all requests" do
        response = request.post("/some/path", 'HTTP_USER_AGENT' => '')
        expect(response['Set-Cookie']).to match(/\s*thiscookie-legacy=/i)
      end

      it "adds SameSite=None to cookies for all requests" do
        response = request.post("/some/path", 'HTTP_USER_AGENT' => '')
        expect(response['Set-Cookie']).to match(/;\s*samesite=none/i)
      end
    end
  end

end