class AppointmentPolicy < ApplicationPolicy

  def update?
    user.admin? || (user.trainer? && appointment.belongs_to?(user)) 
  end

end