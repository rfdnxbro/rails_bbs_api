# frozen_string_literal: true

#
# activerecordのsuper class
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
