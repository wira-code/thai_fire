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

ActiveRecord::Schema[8.1].define(version: 2026_09_11_204708) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "add_ons", force: :cascade do |t|
    t.boolean "available", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.integer "price_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["available"], name: "index_add_ons_on_available"
    t.index ["name"], name: "index_add_ons_on_name", unique: true
    t.index ["position"], name: "index_add_ons_on_position"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_line1", null: false
    t.string "address_line2", null: false
    t.boolean "as_default", default: false, null: false
    t.string "city", null: false
    t.string "country", default: "France", null: false
    t.datetime "created_at", null: false
    t.string "full_name", null: false
    t.string "label", null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.string "phone", null: false
    t.string "postal_code", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["postal_code"], name: "index_addresses_on_postal_code"
    t.index ["user_id", "as_default"], name: "index_addresses_on_user_id_and_as_default"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "cart_item_add_ons", force: :cascade do |t|
    t.bigint "add_on_id", null: false
    t.string "add_on_name"
    t.bigint "cart_item_id", null: false
    t.datetime "created_at", null: false
    t.integer "price_cents"
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.index ["add_on_id"], name: "index_cart_item_add_ons_on_add_on_id"
    t.index ["cart_item_id"], name: "index_cart_item_add_ons_on_cart_item_id"
  end

  create_table "cart_item_options", force: :cascade do |t|
    t.bigint "cart_item_id", null: false
    t.string "choice_name", null: false
    t.datetime "created_at", null: false
    t.string "option_name", null: false
    t.integer "price_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["cart_item_id"], name: "index_cart_item_options_on_cart_item_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.text "special_request"
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_categories_on_active"
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["position"], name: "index_categories_on_position"
  end

  create_table "delivery_zones", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.integer "delivery_fee_cents", default: 0, null: false
    t.integer "minimun_order_cents", default: 0, null: false
    t.string "name", null: false
    t.string "postal_code", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_delivery_zones_on_active"
    t.index ["postal_code", "active"], name: "index_delivery_zones_on_postal_code_and_active"
    t.index ["postal_code"], name: "index_delivery_zones_on_postal_code"
  end

  create_table "option_choices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "option_id", null: false
    t.integer "position", default: 0, null: false
    t.integer "price_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["option_id", "name"], name: "index_option_choices_on_option_id_and_name", unique: true
    t.index ["option_id", "position"], name: "index_option_choices_on_option_id_and_position"
    t.index ["option_id"], name: "index_option_choices_on_option_id"
  end

  create_table "options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "multiple", default: false, null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.boolean "required", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_options_on_name", unique: true
    t.index ["position"], name: "index_options_on_position"
  end

  create_table "order_item_add_ons", force: :cascade do |t|
    t.bigint "add_on_id", null: false
    t.string "add_on_name", null: false
    t.datetime "created_at", null: false
    t.bigint "order_item_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["add_on_id"], name: "index_order_item_add_ons_on_add_on_id"
    t.index ["order_item_id"], name: "index_order_item_add_ons_on_order_item_id"
  end

  create_table "order_item_options", force: :cascade do |t|
    t.string "choice_name"
    t.datetime "created_at", null: false
    t.string "option_name"
    t.bigint "order_item_id", null: false
    t.integer "price_cents"
    t.datetime "updated_at", null: false
    t.index ["order_item_id"], name: "index_order_item_options_on_order_item_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.string "product_name"
    t.integer "quantity"
    t.text "special_request"
    t.integer "total_cents"
    t.integer "unit_price_cents"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.string "customer_name"
    t.text "customer_note"
    t.text "delivery_address"
    t.integer "delivery_fee_cents", default: 0, null: false
    t.datetime "delivery_time"
    t.bigint "delivery_zone_id"
    t.string "email"
    t.string "order_number", null: false
    t.integer "order_type", default: 0, null: false
    t.integer "payment_method", default: 0
    t.integer "payment_status", default: 0, null: false
    t.string "phone_number"
    t.datetime "scheduled_at"
    t.integer "status", default: 0, null: false
    t.integer "subtotal_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["delivery_zone_id"], name: "index_orders_on_delivery_zone_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["order_type"], name: "index_orders_on_order_type"
    t.index ["payment_status"], name: "index_orders_on_payment_status"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.datetime "paid_at"
    t.integer "payment_method", null: false
    t.string "provider", null: false
    t.string "provider_payment_id"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id", unique: true
    t.index ["provider", "provider_payment_id"], name: "index_payments_on_provider_and_provider_payment_id", unique: true, where: "(provider_payment_id IS NOT NULL)"
  end

  create_table "product_add_ons", force: :cascade do |t|
    t.bigint "add_on_id", null: false
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["add_on_id"], name: "index_product_add_ons_on_add_on_id"
    t.index ["product_id", "add_on_id"], name: "index_product_add_ons_on_product_id_and_add_on_id", unique: true
    t.index ["product_id", "position"], name: "index_product_add_ons_on_product_id_and_position"
    t.index ["product_id"], name: "index_product_add_ons_on_product_id"
  end

  create_table "product_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "option_id", null: false
    t.integer "position", default: 0, null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_product_options_on_option_id"
    t.index ["product_id", "option_id"], name: "index_product_options_on_product_id_and_option_id", unique: true
    t.index ["product_id", "position"], name: "index_product_options_on_product_id_and_position"
    t.index ["product_id"], name: "index_product_options_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.boolean "available", default: true, null: false
    t.boolean "bestseller"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "featured"
    t.string "image_url"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.integer "price_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_products_on_active"
    t.index ["available"], name: "index_products_on_available"
    t.index ["category_id", "position"], name: "index_products_on_category_id_and_position"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "cart_item_add_ons", "add_ons"
  add_foreign_key "cart_item_add_ons", "cart_items"
  add_foreign_key "cart_item_options", "cart_items"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "option_choices", "options"
  add_foreign_key "order_item_add_ons", "add_ons"
  add_foreign_key "order_item_add_ons", "order_items"
  add_foreign_key "order_item_options", "order_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "delivery_zones"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_add_ons", "add_ons"
  add_foreign_key "product_add_ons", "products"
  add_foreign_key "product_options", "options"
  add_foreign_key "product_options", "products"
  add_foreign_key "products", "categories"
end
