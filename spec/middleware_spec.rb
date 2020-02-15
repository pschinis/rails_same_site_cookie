RSpec.describe RailsSameSiteCookie::Middleware do
  let(:middleware) { described_class.new(app) }
  let(:request) { Rack::MockRequest.new(middleware) }
  before(:each) do
    RailsSameSiteCookie.configuration = RailsSameSiteCookie::Configuration.new
  end

  describe "config.user_agent_regex" do
    subject { request.post("/some/path", 'HTTP_USER_AGENT' => user_agent)['Set-Cookie'] }

    let(:app) { MockRackApp.new }

    context "if set regex" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.user_agent_regex = /StrongrFastrApp/
        end
      end

      context "UA matches regex" do
        let(:user_agent) { 'StrongrFastrApp' }

        it "adds SameSite=None to cookies" do
          expect( subject ).to match(/;\s*samesite=none/i)
        end
      end

      context "UA unmatches regex" do
        let(:user_agent) { 'OtherApp' }

        it "doesn't add SameSite=None" do
          expect( subject ).not_to match(/;\s*samesite=none/i)
        end
      end
    end

    context "if not set" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.user_agent_regex = nil
        end
      end
      let(:user_agent) { '' }

      it "adds SameSite=None to cookies" do
        expect( subject ).to match(/;\s*samesite=none/i)
      end
    end
  end

  describe "config.default_value" do
    subject { request.post("/some/path")['Set-Cookie'] }

    let(:app) { MockRackApp.new }

    context "if not set (initial='None')" do
      it "adds SameSite=None to cookies" do
        expect( subject ).to match(/;\s*samesite=none/i)
      end
    end

    context "if set 'Lax'" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.default_value = 'Lax'
        end
      end

      it "adds SameSite=Lax to cookies" do
        expect( subject ).to match(/;\s*samesite=lax/i)
      end
    end

    context "if set 'Strict'" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.default_value = 'Strict'
        end
      end

      it "adds SameSite=Strict to cookies" do
        response = request.post("/some/path")
        expect(response['Set-Cookie']).to match(/;\s*samesite=strict/i)
      end
    end
  end

  describe "config.default_override" do
    subject { request.post("/some/path")['Set-Cookie'] }

    let(:app) { MockRackApp.new.tap {|a| a.cookie = "cookie1=thisvalue1; SameSite=None" } }
    before(:each) do
      RailsSameSiteCookie.configure do |config|
        config.default_value = 'Lax'
      end
    end

    context "if not set (initial='false')" do
      it "not change SameSite attribute to cookies" do
        expect( subject ).to match(/;\s*samesite=none/i)
      end
    end

    context "if set true" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.default_override = true
        end
      end

      it "change SameSite attribute to cookies" do
        expect( subject ).to match(/;\s*samesite=lax/i)
      end
    end
  end

  describe "config.individual_settings" do
    subject { request.post("/some/path")['Set-Cookie'].split("\n") }

    let(:app) { MockRackApp.new.tap {|a| a.cookie = "cookie1=value1\ncookie2=value2; SameSite=Lax" } }
    before(:each) do
      RailsSameSiteCookie.configure do |config|
        config.default_value = 'None'
        config.default_override = false
      end
    end

    context "if not set" do
      it "change SameSite attribute to cookie1 only" do
        expect( subject[0].match(/;\s*samesite=none/i) ).to be_truthy
        expect( subject[1].match(/;\s*samesite=lax/i) ).to be_truthy
      end
    end

    context "if set cookie1 and cookie2 by array" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.individual_settings = ['cookie1', 'cookie2']
        end
      end

      it "change SameSite attribute to cookie1 only" do
        expect( subject[0].match(/;\s*samesite=none/i) ).to be_truthy
        expect( subject[1].match(/;\s*samesite=lax/i) ).to be_truthy
      end
    end

    context "if set cookie1 and cookie2 by hash" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.individual_settings = {cookie1: {}, cookie2: {}}
        end
      end

      it "change SameSite attribute to cookie1 only" do
        expect( subject[0].match(/;\s*samesite=none/i) ).to be_truthy
        expect( subject[1].match(/;\s*samesite=lax/i) ).to be_truthy
      end
    end

    context "if set cookie1 and cookie2 by hash with override option (true)" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.individual_settings = {cookie1: {override: true}, cookie2: {override: true}}
        end
      end

      it "change SameSite attribute ('None') to all cookies" do
        expect( subject[0].match(/;\s*samesite=none/i) ).to be_truthy
        expect( subject[1].match(/;\s*samesite=none/i) ).to be_truthy
      end
    end

    context "if set cookie1 and cookie2 by hash with value option ('Strict')" do
      before(:each) do
        RailsSameSiteCookie.configure do |config|
          config.individual_settings = {cookie1: {value: :strict}, cookie2: {value: :strict}}
        end
      end

      it "change SameSite attribute ('Strict') to cookie1 only" do
        expect( subject[0].match(/;\s*samesite=strict/i) ).to be_truthy
        expect( subject[1].match(/;\s*samesite=lax/i) ).to be_truthy
      end
    end
  end

end
