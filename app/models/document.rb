class Document < ActiveRecord::Base
  belongs_to :document_type
  belongs_to :status
  has_many :ratings
  has_many :contents
  has_one  :homepage
  has_one  :detail
end
