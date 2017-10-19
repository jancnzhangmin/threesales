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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171018025419) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "seller_id"
    t.string   "username"
    t.string   "password_digest"
    t.string   "login"
    t.string   "status"
    t.string   "auth"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "buycars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "selleruser_id"
    t.float    "amount",        limit: 24
    t.integer  "status"
    t.integer  "ordernumber"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "seller_id"
    t.integer  "user_id"
    t.string   "remark"
  end

  create_table "logisticorders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "logistic_id"
    t.integer  "buycar_id"
    t.string   "ordernumber"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "logistics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "logistic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "noticeimg_file_name"
    t.string   "noticeimg_content_type"
    t.integer  "noticeimg_file_size"
    t.datetime "noticeimg_updated_at"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "buycar_id"
    t.integer  "product_id"
    t.integer  "number"
    t.float    "price",      limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "productclas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "seller_id"
    t.string   "cla"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "productcla_id"
    t.string   "name"
    t.string   "spec"
    t.string   "model"
    t.float    "price",                   limit: 24
    t.text     "content",                 limit: 65535
    t.integer  "status"
    t.float    "secondprice",             limit: 24
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "seller_id"
    t.float    "first",                   limit: 24
    t.float    "second",                  limit: 24
    t.float    "third",                   limit: 24
    t.float    "sfirst",                  limit: 24
    t.float    "ssecond",                 limit: 24
    t.float    "sthird",                  limit: 24
    t.string   "productimg_file_name"
    t.string   "productimg_content_type"
    t.integer  "productimg_file_size"
    t.datetime "productimg_updated_at"
  end

  create_table "recepitaddres", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "tel"
    t.string   "region"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "choice"
  end

  create_table "sellers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "summary",                  limit: 65535
    t.string   "tel"
    t.string   "address"
    t.integer  "status"
    t.string   "shortname"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "sellerimage_file_name"
    t.string   "sellerimage_content_type"
    t.integer  "sellerimage_file_size"
    t.datetime "sellerimage_updated_at"
  end

  create_table "sellerusers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "seller_id"
    t.integer  "user_id"
    t.integer  "up_id"
    t.string   "openid"
    t.string   "qrcode"
    t.datetime "qrcodetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "userpwds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "login"
    t.string   "password_digest"
    t.string   "vcode"
    t.datetime "vcodetime"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
