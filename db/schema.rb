# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_17_053951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "appeal_type", ["invitation", "application"]
  create_enum "energies", ["S", "N"]
  create_enum "minds", ["I", "E"]
  create_enum "natures", ["T", "F"]
  create_enum "plan_name", ["free", "pro", "ultimate"]
  create_enum "status_name", ["open", "active", "completed"]
  create_enum "tactics", ["J", "P"]

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "appeals", force: :cascade do |t|
    t.enum "type", default: "invitation", null: false, as: "appeal_type"
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_appeals_on_project_id"
    t.index ["user_id", "project_id"], name: "index_appeals_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_appeals_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "collaborations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_collaborations_on_team_id"
    t.index ["user_id", "team_id"], name: "index_collaborations_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_collaborations_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "identities", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
    t.index ["provider", "user_id"], name: "index_identities_on_provider_and_user_id", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "status", null: false
    t.bigint "project_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "landing_feedbacks", force: :cascade do |t|
    t.string "smiley", default: "", null: false
    t.string "channel", default: "", null: false
    t.boolean "interest", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "licenses", force: :cascade do |t|
    t.enum "plan", default: "free", null: false, as: "plan_name"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_licenses_on_user_id", unique: true
  end

  create_table "newsletter_feedbacks", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "reasons", default: [], null: false, array: true
    t.bigint "newsletter_subscription_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["newsletter_subscription_id"], name: "index_newsletter_feedbacks_on_newsletter_subscription_id"
  end

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "subscribed", default: true, null: false
    t.index ["email"], name: "index_newsletter_subscriptions_on_email", unique: true
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "key", default: ""
    t.boolean "read", default: false, null: false
    t.bigint "user_id", null: false
    t.string "notifier_type", null: false
    t.bigint "notifier_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["notifier_type", "notifier_id"], name: "index_notifications_on_notifier_type_and_notifier_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "personalities", force: :cascade do |t|
    t.enum "mind", as: "minds"
    t.enum "energy", as: "energies"
    t.enum "nature", as: "natures"
    t.enum "tactic", as: "tactics"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mind", "energy", "nature", "tactic"], name: "index_personalities_on_mind_and_energy_and_nature_and_tactic", unique: true
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "group_size", default: 0, null: false
    t.text "preferred_tasks", default: "", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_preferences_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", limit: 100, default: "", null: false
    t.text "description", default: "", null: false
    t.boolean "visibility", default: true, null: false
    t.enum "status", default: "active", null: false, as: "status_name"
    t.bigint "category_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_projects_on_category_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating", null: false
    t.bigint "project_id"
    t.bigint "reviewer_id"
    t.bigint "reviewee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_reviews_on_project_id"
    t.index ["reviewee_id"], name: "index_reviews_on_reviewee_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "skill_levels", force: :cascade do |t|
    t.integer "experience", default: 0, null: false
    t.integer "level", default: 0, null: false
    t.bigint "user_id"
    t.bigint "skill_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id"], name: "index_skill_levels_on_skill_id"
    t.index ["user_id"], name: "index_skill_levels_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_skills_on_category_id"
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  create_table "task_skills", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id", "task_id"], name: "index_task_skills_on_skill_id_and_task_id", unique: true
    t.index ["skill_id"], name: "index_task_skills_on_skill_id"
    t.index ["task_id"], name: "index_task_skills_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.bigint "skills_id"
    t.bigint "user_id"
    t.bigint "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["skills_id"], name: "index_tasks_on_skills_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "team_skills", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id", "team_id"], name: "index_team_skills_on_skill_id_and_team_id", unique: true
    t.index ["skill_id"], name: "index_team_skills_on_skill_id"
    t.index ["team_id"], name: "index_team_skills_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "team_size", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "project_id"], name: "index_teams_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_teams_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 254, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.date "birthdate"
    t.string "name", limit: 255, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "password_automatically_set", default: false, null: false
    t.bigint "personality_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["personality_id"], name: "index_users_on_personality_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appeals", "projects"
  add_foreign_key "appeals", "users"
  add_foreign_key "collaborations", "teams"
  add_foreign_key "collaborations", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users"
  add_foreign_key "licenses", "users"
  add_foreign_key "newsletter_feedbacks", "newsletter_subscriptions"
  add_foreign_key "notifications", "users"
  add_foreign_key "preferences", "users"
  add_foreign_key "projects", "categories"
  add_foreign_key "projects", "users"
  add_foreign_key "reviews", "projects"
  add_foreign_key "reviews", "users", column: "reviewee_id"
  add_foreign_key "reviews", "users", column: "reviewer_id"
  add_foreign_key "skill_levels", "skills"
  add_foreign_key "skill_levels", "users"
  add_foreign_key "skills", "categories"
  add_foreign_key "task_skills", "skills"
  add_foreign_key "task_skills", "tasks"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "skills", column: "skills_id"
  add_foreign_key "tasks", "users"
  add_foreign_key "team_skills", "skills"
  add_foreign_key "team_skills", "teams"
  add_foreign_key "teams", "projects"
  add_foreign_key "users", "personalities"
end
