class Review < ActiveRecord::Base
  
  belongs_to  :company#, :counter_cache => true
  belongs_to  :user
  has_many    :review_issues
  has_many    :issues, :through => :review_issues
  has_many    :peer_ratings

  validates_presence_of :user_id, :rating, :status, :company_id
  validate_on_create :protect_against_angry_abuse
  
  accepts_nested_attributes_for :issues
  
  validates_inclusion_of :rating, :in => (1 .. 10).to_a.map{|x| x/2.0}
  
  before_validation :set_initial_state, :on => :create
  
  define_index do
    indexes :body
  end
  
  # Define State Machine states and transitions
  include AASM
  
  #aasm_initial_state :preview
  aasm_column :status
  #aasm_state :preview
  
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published
  
  
  
  #aasm_event :preview do
  #  transitions :to => :preview, :from => :draft
  #end
  #aasm_event :save_as_draft do
  #  transitions :to => :draft, :from => :preview
  #end
  aasm_event :publish do
    transitions :to => :published, :from => :draft
  end
  def set_initial_state
    #raise "entered set_initial_state"
    status = "preview"
  end
  ##########################################################
  ######## SCORING SYSTEM
  
  # moved to lib/cm_scores.rb - Luke
  
  ######## end SCORING SYSTEM
  ##########################################################
  
  
  
  ##########################################################
  ######## FORM HANDLING
  def issues=(issue_ids)
    issue_ids.each do |issue_id|
      issues << Issue.find(issue_id)
      #review_issue = ReviewIssue.new(:issue_id => issue_id, :review => )
      #review_issue.save
    end
  end
  
  def aasm_event=(event_name)
    unless self.send("#{event_name}!")
      errors.add_to_base "#{event_name} event failed."
    end
  end
  
  ######## end FORM HANDLING
  ##########################################################
  
  
  private
  def protect_against_angry_abuse
    [self.class.find(:first, :conditions => ["user_id = ? and company_id = ? and created_at > ?", user, company, Time.now - 180.days])].compact.each do
      errors.add_to_base("You already submitted a review this company on this issue. You must wait at least 180 days between reviews.")
    end
  end
  

  
  
end
