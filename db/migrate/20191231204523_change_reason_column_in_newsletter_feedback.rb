# frozen_string_literal: true

class ChangeReasonColumnInNewsletterFeedback < ActiveRecord::Migration[6.0]
  def change
    rename_column :newsletter_feedbacks, :reason, :reasons
    # rubocop:disable Rails/ReversibleMigration
    # rubocop:disable Rails/BulkChangeTable
    change_column_default :newsletter_feedbacks, :reasons, nil
    # rubocop:enable Rails/BulkChangeTable
    # rubocop:enable Rails/ReversibleMigration

    change_column :newsletter_feedbacks, :reasons, :string, array: true, default: [], using: "(string_to_array(reasons, ' '))"
  end
end
