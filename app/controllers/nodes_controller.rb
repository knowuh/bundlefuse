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
  
  # merge all the terminal nodes of this node-listing
  def merge
    @node = Node.find(params[:id])
    # we should somehow signal to the user that this is going to take some time?
    debugger
    merged = @node.merge_all_leaves
    # response.headers['Content-Type'] = 'text/xml' # I've also seen this for CSV files: 'text/csv; charset=iso-8859-1; header=present'
    # response.headers['Content-Disposition'] = 'attachment; filename=merged.otml'
    send_data merged, :type => 'text/xml', :disposition => 'attachment; filename=merged.otml'
  end

end
