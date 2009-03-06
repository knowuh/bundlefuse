class Node < ActiveRecord::Base
  # see http://ar.rubyonrails.org/classes/ActiveRecord/Acts/Tree/ClassMethods.html
  acts_as_tree :order => "bundle_id"
  validates_uniqueness_of :bundle_id, :on => :create, :message => "bundle_id must be unique"
  validates_presence_of :bundle_id, :on => :create, :message => "bundle_id can't be blank"
  # after_create :build_family
  
  def Node::for_bundle(bundle)
    #TODO could we speed this up by not querying for the remote object more than once?
    node = find_or_create_by_bundle_id(bundle.id)
    node.bundle=bundle
    node
  end
  
  def Node::for_workgroup(_workgroup)
    last_node = nil
    # puts _workgroup.to_xml
    _workgroup.bundles.each do |b|
      last_node = Node.find_by_bundle_id(b.id)
      unless last_node
        last_node = Node::for_bundle(b)
        puts "added node for bundle: #{b.id} workgroup: #{_workgroup} node_id: #{last_node.id}"
      else
        puts "found node for bundle: #{b.id} workgroup: #{_workgroup} node_id: #{last_node.id}"
      end
    end
    # return the root 
    return last_node.root
  end
  
  def bundle=(bundle)
    self.bundle_id ||= bundle.id
    self.start ||=  bundle.sail_session_start_time
    self.end ||= bundle.sail_session_end_time
    self.uuid ||= bundle.sail_session_uuid
    self.workgroup ||= bundle.workgroup
    unless (self.parent)
      self.findParent
    end
    self.save
    @bundle = bundle
  end
  
  def bundle
    unless @bundle
        @bundle = Bundle.find(bundle_id)
    end
    return @bundle
  end
  
  def workgroup
    unless @workgroup
      @workgroup =  Workgroup.find(group_id)
    end
    return @workgroup
  end
  
  def workgroup=(workgroup)
    self.group_id=workgroup.id
    self.group_name=workgroup.name
    @workgroup = workgroup
  end
  
  def findParent
    parent_bundles=Bundle.find(:all, :params => { :sail_session_uuid => self.bundle.previous_bundle_session_id })
    candidates = []
    parent_bundles.each do | parent_bundle |
      n = Node.for_bundle(parent_bundle)
      n.save
      candidates << n
    end
    choose_parent(candidates)
  end
      
  def descendants
    descendants = []
    children.each.map do | child |
      descendants << child
      descendants = descendants + child.descendants
    end
    descendants
  end
  

  
  def leaf?
    return children.empty?
  end
  def leaves
    (descendants << self).select { |c| c.leaf? }
  end
  
  def linear?
    return children.size == 1
  end
  def linears
    (descendants << self).select { |c| c.linear? }
  end
  
  def duration
    return self.end.to_i - self.start.to_i
  end


  def choose_parent(candidate_nodes)
    start_time = self.start.to_i
    smallest_dtime = Time.now.to_i * 2 # outragously not-small
    best_candidate = nil
    candidate_nodes.each do | other_node |
      dtime = start_time - other_node.bundle.sail_session_end_time.to_i
      if dtime < 1 
        puts "negative time distance from parent... Lost data"
        # self.lost_data = self.lost_data + 1
      end
      if dtime < smallest_dtime
        best_candidate=other_node
        smallest_dtime=dtime
      end
    end
    self.parent=best_candidate || candidate_nodes[0]
  end
  
  # def lost_data
  #     descendents_loss = 0
  #     self.children.each do |child|
  #       descendents_loss += child.lost_data
  #     end
  #   return @lost_data + descendents_loss
  # end
  
  def tree_duration
    d = duration
    self.root.decendants.each do |child|
      d += child.duration
    end
    return duration
  end
  
  
end
