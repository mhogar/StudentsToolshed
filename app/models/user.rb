class User < ApplicationRecord
  before_create :create_interfaces

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :task_tracker_interface

  private
    def create_interfaces
      self.task_tracker_interface = TaskTrackerInterface.create
    end
end
