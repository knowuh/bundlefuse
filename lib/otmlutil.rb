require 'rubygems'
# require 'libxml'
require 'xml/xslt'


class OTMLUtil
  @@DEFAULT_XSLT_FILE = File.join(File.dirname(__FILE__), 'merge.xslt')
  @@DEFAULT_OT_SCHEMA_FILE = File.join(File.dirname(__FILE__), 'schema/otrunk_all.rng')
  attr_accessor :xslt_file
  attr_accessor :ot_schema_file
  
  def initialize(_xslt_file=nil,_otrunk_schema=nil)
    _xslt_file ||= @@DEFAULT_XSLT_FILE
    _otrunk_schema  ||= @@DEFAULT_OT_SCHEMA_FILE
    @xslt_file = _xslt_file
    @ot_schema_file = _otrunk_schema
  end
  
  def merge_xml(a,b)
    xslt = XML::XSLT.new()
    unless File.exists?(b)
      file = Tempfile.new("xmldif")
      file.write(b)
      file.flush
      file.close
      b = file.path
    end
    xml_file = File.new(b)
    xslt.xml = a
    xslt.xsl = REXML::Document.new File.open(@xslt_file)
    xslt.parameters = { "with" => xml_file.path }
    return xslt.serve()
  end
  
  # def vaidate_otml(otml)
  #   document = nil
  #   if File.exists?(otml)
  #     document = LibXML::XML::Parser.file(otml).parse
  #   else
  #     document = LibXML::XML::Parser.string(otml).parse
  #   end
  #   # parse schema as xml document
  #   relaxng_document = LibXML::XML::Document.file(@ot_schema_file)
  #   relaxng_schema = LibXML::XML::RelaxNG.document(relaxng_document)
  #   document.validate_relaxng(relaxng_schema) do |error| 
  #     puts "encountered an error: #{error}"
  #   end
  # end

end

