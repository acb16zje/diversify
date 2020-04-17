class RemoveExperienceFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :experience, :integer
  end
end
