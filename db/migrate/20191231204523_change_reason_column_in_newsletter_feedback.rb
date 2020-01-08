class ChangeReasonColumnInNewsletterFeedback < ActiveRecord::Migration[6.0]
  def change
    rename_column :newsletter_feedbacks, :reason, :reasons
    change_column_default :newsletter_feedbacks, :reasons, nil

    change_column :newsletter_feedbacks, :reasons, :string, array: true, default: [], using: "(string_to_array(reasons, ' '))"
  end
end
