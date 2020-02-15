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
    subject { config.instance_variable_get(:@default_value) }

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

  describe "default_override" do
    subject { config.instance_variable_get(:@default_override) }

    context "if not set" do
      it { is_expected.to be(false) }
    end

    context "if set true" do
      before { config.default_override = true }
      it { is_expected.to be(true) }
    end

    context "if set 'xxxx' (not boolean)" do
      it { expect { config.default_override = 'xxxx' }.to raise_error(ArgumentError) }
    end

    context "if set nil" do
      it { expect { config.default_override = nil }.to raise_error(ArgumentError) }
    end
  end

  describe "individual_settings" do
    subject { config.instance_variable_get(:@individual_settings) }

    context "if not set" do
      it { is_expected.to eq({}) }
    end

    context "if set array of strings" do
      before { config.individual_settings = cookie_names }
      let(:cookie_names) { %w{name1 name2 name3} }

      it("is expected to have all keys same as set array.") do
        expect(subject.keys).to eq(cookie_names)
      end

      it("is expected to have all values be {}.") do
        expect(subject.values).to all( be {} )
      end
    end

    context "if set array of symbols" do
      before { config.individual_settings = cookie_names }
      let(:cookie_names) { %i{name1 name2 name3} }

      it("is expected to have all keys converted to string.") do
        expect(subject.keys).to eq(cookie_names.map(&:to_s))
      end
    end

    context "if set valid hash" do
      before { config.individual_settings = individual_settings }
      let(:individual_settings) do
        {
          name1: {value: 'None', override: true},
          name2: {value: 'none', override: false},
          name3: {value: :none, override: true},
        }
      end

      it("is expected to have all keys converted to string.") do
        expect(subject.keys).to match_array(individual_settings.keys.map(&:to_s))
      end

      it("is expected to have all value attributes converted to constant value.") do
        expect(subject.values.map {|attrs| attrs[:value] }).to all(eq('None'))
      end

      it("is expected to have all override attributes be boolean.") do
        expect(subject.values.map {|attrs| attrs[:override] }).to all(be(true).or be(false))
      end
    end

    context "if set hash with blank values" do
      before { config.individual_settings = individual_settings }
      let(:individual_settings) do
        {
          name1: {},
          name2: {},
        }
      end

      it("is expected to have all values be {}.") do
        expect(subject.values).to all( be {} )
      end
    end

    context "if set hash with invalid value attribute" do
      let(:individual_settings) do
        {name1: {value: 'xxxx', override: true}}
      end

      it { expect { config.individual_settings = individual_settings }.to raise_error(ArgumentError) }
    end

    context "if set hash with invalid override attribute" do
      let(:individual_settings) do
        {name1: {value: 'None', override: 'xxxx'}}
      end

      it { expect { config.individual_settings = individual_settings }.to raise_error(ArgumentError) }
    end
  end

end
