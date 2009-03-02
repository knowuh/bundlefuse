require 'test_helper'
require 'OTMLUtil'
require 'nokogiri'
require 'open-uri'

class OTMLUtilTest < Test::Unit::TestCase

wdir = File.dirname(__FILE__)

  context "the xml_merge in OTML Utils library" do 
      setup do
        @otmlUtil = OTMLUtil.new()
        @wdir = File.dirname(__FILE__)
        @xml_file_a = File.join(@wdir, "a.xml")
        @xml_file_b = File.join(@wdir, "b.xml")

        @text_xml_a = <<DONE
        <container_a>
          <one>first</one>
          <two>second</two>
          <three>third</three>
          <six>six</six>
          <seven>six plus </seven>
          <eight>7 + </eight>
        </container_a>
DONE
        @text_xml_b = <<DONE
        <container_a>
          <one>first</one>
          <three>third</three>
          <four>four</four>
          <five>five</five>
          <six></six>
          <seven>one</seven>
          <eight>1</eight>
        </container_a>
DONE
  
      end
      
      should "work for text input" do
        results = @otmlUtil.merge_xml(@text_xml_a,@text_xml_b)
        assert_not_nil results
      end
      
      should "work for file input" do
        results =  @otmlUtil.merge_xml(@xml_file_a,@xml_file_b)
        assert_not_nil results
      end
      
      should "merge simple data" do
        results = @otmlUtil.merge_xml(@text_xml_a,@text_xml_b)
        doc = Nokogiri::XML(results)
        assert_equal 8,doc.xpath("/container_a/*").size
        assert_equal "five",doc.xpath("container_a/five").text
        assert_equal "six",doc.xpath("container_a/six").text
        assert_equal "six plus one", doc.xpath("container_a/seven").text
        assert_equal "7 + 1", doc.xpath("container_a/eight").text
      end
  end
  
  context "using actual OTML files" do
    setup do
      @OTML_a = File.join(@wdir, "../fixtures/76604.xml")
      @OTML_b = File.join(@wdir, "../fixtures/79332.xml")
    end
    
  end
    
  
end