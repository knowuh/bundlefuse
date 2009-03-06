class WorkgroupsController < ApplicationController

  before_filter :find, :except => ['index']
  caches_action :svg
  
  protected  
  def dot
    @nodes = @root_node.descendants
    @nodes << @root_node
    render_to_string :template => "workgroups/dot.dot.erb", :layout => false
  end

  def find
    @workgroup = Workgroup.find(params['id'])
    @root_node = Node.for_workgroup(Workgroup.find(params['id']))
  end
  
  public
  
  def show
    redirect_to :controller => "nodes", :action => "show", :id => @root_node
  end
  
  # show only the 
  def index
    offset = params['offset'] || 0
    @workgroups = Workgroup.find(:all, :limit => 100, :offset => offset)
    @attributes = [:id,:name]
  end

  def dotgraph
    @dot = dot
  end
  
  def svg
    @dot = dot
    file = Tempfile.new("dotfile")
    file.write(@dot)
    file.close
    svg = %x( dot -Tsvg #{file.path})
    send_data svg, :type => 'image/svg+xml', :disposition => 'inline'
  end

end
