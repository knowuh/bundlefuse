class NodesController < ApplicationController

  # caches_action :show
  caches_action :timeline
  caches_action :index
  
  public
  def show
    @node = Node.find(params[:id])
    @group = Workgroup.find(@node.group_id)
    @bundle = Bundle.find(@node.bundle_id)
    @activity = @bundle.udl_activity
    @svg_url = url_for :controller => 'workgroups', :action => 'svg', :id => @group.id 
    @timeline_url = url_for :action => 'timeline', :id => @node.id
  end
  
  def index
    offset = params['offset'] || 0
    @nodes = Node.find(:all, :offset => offset, :limit => 200)
  end
  
  def timeline
    @node = Node.find(params[:id])
    @nodes = @node.root.descendants
    @nodes << @node.root
    @group = @node.workgroup
    @bundle = Bundle.find(@node.bundle_id)
    @activity = @bundle.udl_activity
    render  :template => "nodes/timeline.xml.erb", :layout => false
    
  end
  

end
