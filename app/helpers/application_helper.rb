# Methods added to this helper will be available to all templates in the application.
require 'diff/lcs'
class String
  include Diff::LCS
end
class Array
  include Diff::LCS
end
module ApplicationHelper
end
