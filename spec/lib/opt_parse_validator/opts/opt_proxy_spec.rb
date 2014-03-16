# encoding: utf-8

require 'spec_helper'

describe OptParseValidator::OptProxy do

  subject(:opt) { OptParseValidator::OptProxy.new(['--proxy PROXY'], attrs) }
  let(:attrs)   { { protocols: %w(http https socks socks5 socks4) } }

  describe '#validate' do
    # Handle by OptURI
  end

end
