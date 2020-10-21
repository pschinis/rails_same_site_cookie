require "byebug"
RSpec.describe RailsSameSiteCookie::Middleware do
  let(:app) { MockRackApp.new }
  subject { described_class.new(app) }

  context "when configured with a regex" do
    let(:valid_url) { 'https://www.lol.com' }
    let(:request) { Rack::MockRequest.new(subject) }
    let(:headers) { {'HTTP_USER_AGENT' => 'StrongrFastrApp', 'HTTP_REFERER' => valid_url} }

    context "when user agent is given" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.user_agent_regex = /StrongrFastrApp/
          config.resolve_prog_bool = lambda{|env| env['HTTP_REFERER'] == "https://www.lol.com"}
        end
      end

      it "adds SameSite=None to cookies for requests whose UA matches regex" do
        response = request.post("/some/path", headers)
        expect(response['Set-Cookie']).to match(/;\s*samesite=none/i)
      end

      it "doesn't add SameSite=None if request is missing regex" do
        response = request.post("/some/path")
        expect(response['Set-Cookie']).not_to match(/;\s*samesite=none/i)
      end
    end

    context "when prog bool is given" do
      it "adds SameSite=None to cookies for requests whose prog bool is true" do
        RailsSameSiteCookie.configure do |config|
          config.resolve_prog_bool = lambda{|env| env['HTTP_REFERER'] == valid_url}
        end

        response = request.post("/some/path", headers)
        expect(response['Set-Cookie']).to match(/;\s*samesite=none/i)
      end

      it "doesn't add SameSite=None for requests whose prog bool is false" do
        RailsSameSiteCookie.configure do |config|
          config.resolve_prog_bool = lambda{|env| env['HTTP_REFERER'] == "https://www.nicht-lustig.com"}
        end

        response = request.post("/some/path")
        expect(response['Set-Cookie']).not_to match(/;\s*samesite=none/i)
      end
    end
  end

  context "when configured without a regex" do
    let(:request) { Rack::MockRequest.new(subject) }
    before(:each) do
      RailsSameSiteCookie.configure do |config|
        config.user_agent_regex = nil
        config.resolve_prog_bool = lambda{|env| true }
      end
    end

    it "adds SameSite=None to cookies for all requests" do
      response = request.post("/some/path", 'HTTP_USER_AGENT' => '')
      expect(response['Set-Cookie']).to match(/;\s*samesite=none/i)
    end

  end

end


