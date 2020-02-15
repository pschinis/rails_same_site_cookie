RSpec.describe RailsSameSiteCookie::Configuration do
  let(:config) { described_class.new }

  describe "user_agent_regex" do
    subject { config.user_agent_regex }

    context "if set /dsasdd/ (regexp)" do
      before { config.user_agent_regex = /dsasdd/ }
      example { is_expected.to eq(/dsasdd/) }
    end
  end

  describe "default_value" do
    subject { config.default_value }

    context "if not set" do
      it { is_expected.to eq('None') }
    end

    context "if set 'Lax' (accurate value)" do
      before { config.default_value = 'Lax' }
      example { is_expected.to eq('Lax') }
    end

    context "if set 'strict' (downcase)" do
      before { config.default_value = 'strict' }
      it { is_expected.to eq('Strict') }
    end

    context "if set 'xxxx' (invalid)" do
      it { expect { config.default_value = 'xxxx' }.to raise_error(ArgumentError) }
    end
  end
end
