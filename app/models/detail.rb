class Detail < ActiveRecord::Base
  belongs_to :document

  serialize :meta, HashSerializer
  store_accessor :meta, :og_title, :viewport
end
