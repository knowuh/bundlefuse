class Node < ActiveRecord::Base
  # see http://ar.rubyonrails.org/classes/ActiveRecord/Acts/Tree/ClassMethods.html
  acts_as_tree :order => "bundle_id"
  validates_uniqueness_of :bundle_id, :on => :create, :message => "bundle_id must be unique"
  validates_presence_of :bundle_id, :on => :create, :message => "bundle_id can't be blank"
  after_create :build_family
  
  def Node::forbundle(bundle)
    #TODO could we speed this up by not querying for the remote object more than once?
    find_or_create_by_bundle_id(bundle.id)
  end
  
  def build_family
    bundle=Bundle.find(bundle_id)
    the_bundle=bundle # recursive!  possibly evil!
  end
  
  def bundle=(bundle)
    self.bundle_id=bundle.id
    self.start=bundle.sail_session_start_time
    self.end=bundle.sail_session_end_times
    self.uuid=bundle.sail_session_uuid
    self.content_id=bundle.bundle_content_id
    self.workgroup=bundle.workgroup
    self.findParent
    self.save
  end
  def workgroup=(workgroup)
    self.group_id=workgroup.id
    self.group_name=workgroup.name
  end
  
  def findParent
    parent_bundles=Bundle.find(:all, :params => { :sail_session_uuid => the_bundle.previous_bundle_session_id })
    candidate = []
    parent_bundles.each do | parent_bundle |
      n = Node.forbundle(parent_bundle)
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
  


  def bundle
    if bundle_id
      return Bundle.find(bundle_id)
    end
    return nil
  end
  
  def workgroup
    if group_id
      return Workgroup.find(group_id)
    end
    return nil
  end

  def choose_parent(candidate_nodes)
    self.num_parents = candidate_nodes.size
    start_time = self.start.to_i
    smallest_dtime = Time.now.to_i * 2 # outragously not-small
    best_candidate = nil
    candidate_nodes.each do | other_node |
      dtime = start_time - other_node.bundle.sail_session_end_time.to_i
      if dtime < 1 
        puts "negative time distance from parent... Lost data"
        self.lost_data = self.lost_data + 1
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
