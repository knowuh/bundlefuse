# Methods added to this helper will be available to all templates in the application.
require 'diff/lcs'
require 'cgi'

class String
  include Diff::LCS
end
class Array
  include Diff::LCS
end

def escape_uri(value)
  URI.escape(value, /[#{URI::REGEXP::PATTERN::RESERVED}\s]/)
end

def make_sds_url(sds_url, options)
  jnlp_url = sds_url
  if options[:sailotrunk_otmlurl]
    jnlp_url = jnlp_url << "?sailotrunk.otmlurl=#{escape_uri(options[:sailotrunk_otmlurl])}"
  end
  if options[:jnlp_filename]
    jnlp_url = jnlp_url << "&jnlp_filename=#{escape_uri(options[:jnlp_filename])}"
  end
  if options[:jnlp_properties]
    jnlp_url = jnlp_url << "&jnlp_properties=#{escape_uri(options[:jnlp_properties])}"
  end
  return jnlp_url
end

module ApplicationHelper
end
