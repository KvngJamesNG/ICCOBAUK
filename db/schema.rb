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

ActiveRecord::Schema[7.1].define(version: 2026_06_23_000300) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "article_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_article_categories_on_name", unique: true
  end

  create_table "article_comments", force: :cascade do |t|
    t.integer "article_id", null: false
    t.string "email", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verified_name"
    t.index ["article_id"], name: "index_article_comments_on_article_id"
  end

  create_table "article_likes", force: :cascade do |t|
    t.integer "article_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reaction", default: "up", null: false
    t.index ["article_id", "email"], name: "index_article_likes_on_article_id_and_email", unique: true
    t.index ["article_id"], name: "index_article_likes_on_article_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "summary", null: false
    t.text "body", null: false
    t.string "author_name", null: false
    t.string "category"
    t.date "published_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.integer "article_category_id"
    t.index ["article_category_id"], name: "index_articles_on_article_category_id"
    t.index ["author_id"], name: "index_articles_on_author_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authors_on_name", unique: true
  end

  create_table "click_events", force: :cascade do |t|
    t.string "path"
    t.string "target_url"
    t.string "element_text"
    t.string "ip_address"
    t.string "device_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_click_events_on_created_at"
    t.index ["path"], name: "index_click_events_on_path"
  end

  create_table "gallery_groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_gallery_groups_on_name", unique: true
  end

  create_table "gallery_images", force: :cascade do |t|
    t.string "title", null: false
    t.text "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gallery_group_id"
    t.index ["gallery_group_id"], name: "index_gallery_images_on_gallery_group_id"
  end

  create_table "info_pages", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "body", null: false
    t.boolean "published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_info_pages_on_slug", unique: true
  end

  create_table "site_settings", force: :cascade do |t|
    t.string "theme_document_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "admin_username"
    t.string "admin_password"
    t.string "home_convention_text"
    t.string "home_sponsor_text"
  end

  create_table "site_visits", force: :cascade do |t|
    t.string "path", null: false
    t.string "referrer"
    t.string "ip_address"
    t.string "user_agent"
    t.string "device_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_site_visits_on_created_at"
    t.index ["device_type"], name: "index_site_visits_on_device_type"
    t.index ["path"], name: "index_site_visits_on_path"
  end

  create_table "slider_images", force: :cascade do |t|
    t.string "title", null: false
    t.text "caption"
    t.string "link_url"
    t.integer "position", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temp_writer_accounts", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_salt", null: false
    t.string "password_digest", null: false
    t.datetime "expires_at", null: false
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "email_ciphertext"
    t.string "email_digest"
    t.index ["email_digest"], name: "index_temp_writer_accounts_on_email_digest", unique: true
    t.index ["expires_at"], name: "index_temp_writer_accounts_on_expires_at"
    t.index ["username"], name: "index_temp_writer_accounts_on_username", unique: true
  end

  create_table "verified_users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_verified_users_on_email", unique: true
  end

  create_table "writer_email_archives", force: :cascade do |t|
    t.text "email_ciphertext", null: false
    t.string "email_digest", null: false
    t.string "last_username"
    t.datetime "last_expires_at"
    t.datetime "archived_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archived_at"], name: "index_writer_email_archives_on_archived_at"
    t.index ["email_digest"], name: "index_writer_email_archives_on_email_digest", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "article_comments", "articles"
  add_foreign_key "article_likes", "articles"
  add_foreign_key "articles", "article_categories"
  add_foreign_key "articles", "authors"
  add_foreign_key "gallery_images", "gallery_groups"
end
