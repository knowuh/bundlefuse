require 'test_helper'

class XMLTest < Test::Unit::TestCase

  context "same string diff set" do 
      setup do
        @xml_a = <<DONE
          <one>first</one>
          <two>second</two>
          <three>third</three>
DONE

        @xml_b = <<DONE
          <one>first</one>
          <two>second</two>
          <three>third</three>
DONE
      @delta_b = @xml_b.diff(@xml_a)
      @delta_a = @xml_a.diff(@xml_b)
      puts @delta_a.inspect
      end
      
      should "yield no differences" do
        assert_equal 1,@delta_b.size
        assert_equal 1,@delta_a.size
      end
      
  end
  context "simple diff set" do 
      setup do
        @xml_a = <<DONE
          <one>first</one>
          <two>second</two>
          <three>third</three>
DONE

        @xml_b = <<DONE
          <one>first</one>
          <two>second</two>
          <four>forth</four>
DONE

        @xml_union =<<DONE
          <one>first</one>
          <two>second</two>
          <three>third</third>
          <four>forth</four>
DONE
        @xml_intersection =<<DONE
          <one>first</one>
          <two>second</two>
DONE
        @delta_a = @xml_a.diff(@xml_b)
        @delta_b = @xml_b.diff(@xml_a)
      end
      
      should "should yield differences" do
        assert_not_nil @delta_b
        assert_not_nil @delta_a
        assert @delta_b.size > 1
        assert @delta_a.size > 1
      end
      
      should "yield semetric differences" do
        assert_equal @delta_a.size, @delta_b.size
      end
      
      should "patch to the same value" do
        assert_equal @xml_a.patch(@delta_a),@xml_b
        assert_equal @xml_b.patch(@delta_b),@xml_a
      end
      
      should "be able to select patches" do
        # actually this probably should not work puts @delta_a.reject { |change| change[0].action != '+' }
      end
      
  end
  
  
end
