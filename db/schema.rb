# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140814190717) do

  create_table "bookings", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.integer  "space_id",           :null => false
    t.date     "start_date",         :null => false
    t.date     "end_date",           :null => false
    t.integer  "approval_status",    :null => false
    t.float    "service_fee",        :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.float    "total"
    t.float    "booking_rate_daily"
  end

  add_index "bookings", ["space_id"], :name => "index_bookings_on_space_id"
  add_index "bookings", ["user_id"], :name => "index_bookings_on_user_id"

  create_table "mailboxer_conversation_opt_outs", :force => true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  create_table "mailboxer_conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "mailboxer_notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.boolean  "global",               :default => false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], :name => "index_mailboxer_notifications_on_conversation_id"

  create_table "mailboxer_receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "mailboxer_receipts", ["notification_id"], :name => "index_mailboxer_receipts_on_notification_id"

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "new"
    t.integer  "booking_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "express_token"
    t.string   "express_payer_id"
  end

  create_table "space_photos", :force => true do |t|
    t.integer  "space_id"
    t.string   "url",                            :null => false
    t.string   "flickr_title",                   :null => false
    t.string   "flickr_owner_name",              :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "flickr_id",         :limit => 8, :null => false
  end

  add_index "space_photos", ["flickr_id"], :name => "index_space_photos_on_flickr_id"
  add_index "space_photos", ["space_id"], :name => "index_space_photos_on_space_id"

  create_table "spaces", :force => true do |t|
    t.integer  "owner_id",             :null => false
    t.string   "title",                :null => false
    t.integer  "booking_rate_daily"
    t.integer  "booking_rate_weekly"
    t.integer  "booking_rate_monthly"
    t.text     "description",          :null => false
    t.string   "address",              :null => false
    t.string   "city",                 :null => false
    t.string   "country",              :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "photo_url"
    t.integer  "space_photo_id"
    t.integer  "languages"
  end

  add_index "spaces", ["booking_rate_daily"], :name => "index_spaces_on_booking_rate_daily"
  add_index "spaces", ["booking_rate_monthly"], :name => "index_spaces_on_booking_rate_monthly"
  add_index "spaces", ["booking_rate_weekly"], :name => "index_spaces_on_booking_rate_weekly"
  add_index "spaces", ["latitude"], :name => "index_spaces_on_latitude"
  add_index "spaces", ["longitude"], :name => "index_spaces_on_longitude"
  add_index "spaces", ["owner_id"], :name => "index_spaces_on_owner_id"

  create_table "user_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "url",                            :null => false
    t.string   "flickr_title",                   :null => false
    t.string   "flickr_owner_name",              :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "flickr_id",         :limit => 8, :null => false
  end

  add_index "user_photos", ["flickr_id"], :name => "index_user_photos_on_flickr_id"
  add_index "user_photos", ["user_id"], :name => "index_user_photos_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",               :null => false
    t.string   "password_digest",     :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "first_name",          :null => false
    t.string   "last_name",           :null => false
    t.string   "session_token"
    t.string   "photo_url"
    t.integer  "user_photo_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", name: "mb_opt_outs_on_conversations_id", column: "conversation_id"

  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", name: "notifications_on_conversation_id", column: "conversation_id"

  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", name: "receipts_on_notification_id", column: "notification_id"

end
