class ExercisePolicy < ApplicationPolicy

  def update?
    user.admin? || (user.trainer? && exercise.belongs_to?(user)) 
  end

end