require 'test_helper'
require 'istat'

class IstatTest < ActiveSupport::TestCase
  test "parsing" do
    Istat.seed_as_province do |d|
      assert d.size = 12
    end
    Istat.seed_as_municipality do |m|
      assert m.size = 22
    end
  end
end
