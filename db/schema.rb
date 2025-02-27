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

ActiveRecord::Schema[8.0].define(version: 2025_02_27_051027) do
  create_table "active_storage_attachments", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "remember_digest"
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
    t.string "phone"
    t.bigint "location_id"
    t.bigint "category_id"
    t.string "profile_picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "remember_digest"
    t.index ["category_id"], name: "index_m_users_on_category_id"
    t.index ["location_id"], name: "index_m_users_on_location_id"
  end

  create_table "m_users_t_job_offers", id: false, charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.bigint "m_user_id", null: false
    t.bigint "t_job_offer_id", null: false
    t.index ["m_user_id"], name: "index_m_users_t_job_offers_on_m_user_id"
    t.index ["t_job_offer_id"], name: "index_m_users_t_job_offers_on_t_job_offer_id"
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

  create_table "t_job_offers", charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.decimal "minsalary", precision: 10, scale: 2
    t.decimal "maxsalary", precision: 10, scale: 2
    t.bigint "location_id", null: false
    t.bigint "category_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.bigint "company_id"
    t.index ["category_id"], name: "index_t_job_offers_on_category_id"
    t.index ["company_id"], name: "fk_rails_67ffff49e5"
    t.index ["location_id"], name: "index_t_job_offers_on_location_id"
  end

  create_table "t_job_offers_skills", id: false, charset: "utf8", collation: "utf8_general_ci", force: :cascade do |t|
    t.bigint "t_job_offer_id", null: false
    t.bigint "t_skill_id", null: false
    t.index ["t_job_offer_id"], name: "index_t_job_offers_skills_on_t_job_offer_id"
    t.index ["t_skill_id"], name: "index_t_job_offers_skills_on_t_skill_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "m_companies", "t_locations", column: "location_id"
  add_foreign_key "m_companies_t_skills", "m_companies"
  add_foreign_key "m_companies_t_skills", "t_skills"
  add_foreign_key "m_users", "t_categories", column: "category_id"
  add_foreign_key "m_users", "t_locations", column: "location_id"
  add_foreign_key "m_users_t_job_offers", "m_users"
  add_foreign_key "m_users_t_job_offers", "t_job_offers"
  add_foreign_key "m_users_t_skills", "m_users", on_delete: :cascade
  add_foreign_key "m_users_t_skills", "t_skills"
  add_foreign_key "t_job_offers", "m_companies", column: "company_id"
  add_foreign_key "t_job_offers", "t_categories", column: "category_id"
  add_foreign_key "t_job_offers", "t_locations", column: "location_id"
end
