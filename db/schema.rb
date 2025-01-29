# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_29_172809) do
  create_table "m_companies", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "phone"
    t.string "password_digest"
    t.bigint "location_id"
    t.text "info"
    t.string "address"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_m_companies_on_location_id"
  end

  create_table "m_companies_t_skills", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.bigint "m_company_id"
    t.bigint "t_skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_company_id"], name: "index_m_companies_t_skills_on_m_company_id"
    t.index ["t_skill_id"], name: "index_m_companies_t_skills_on_t_skill_id"
  end

  create_table "m_users", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest"
    t.text "about"
    t.text "skills"
    t.string "phone"
    t.bigint "location_id"
    t.bigint "category_id"
    t.string "profile_picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_m_users_on_category_id"
    t.index ["location_id"], name: "index_m_users_on_location_id"
  end

  create_table "m_users_t_skills", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.bigint "m_user_id"
    t.bigint "t_skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_user_id"], name: "index_m_users_t_skills_on_m_user_id"
    t.index ["t_skill_id"], name: "index_m_users_t_skills_on_t_skill_id"
  end

  create_table "t_categories", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_locations", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_skills", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "m_companies", "t_locations", column: "location_id"
  add_foreign_key "m_companies_t_skills", "m_companies"
  add_foreign_key "m_companies_t_skills", "t_skills"
  add_foreign_key "m_users", "t_categories", column: "category_id"
  add_foreign_key "m_users", "t_locations", column: "location_id"
  add_foreign_key "m_users_t_skills", "m_users"
  add_foreign_key "m_users_t_skills", "t_skills"
end
