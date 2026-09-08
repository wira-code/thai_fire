# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ล้างข้อมูลเก่าก่อนสร้างใหม่ (ป้องกันข้อมูลซ้ำซ้อน)
puts "Clearing old data..."
CartItemOption.destroy_all
CartItemAddOn.destroy_all
CartItem.destroy_all
Cart.destroy_all

ProductOption.destroy_all
ProductAddOn.destroy_all
OptionChoice.destroy_all

# 2. ลบตารางหลักที่เป็นแม่
Option.destroy_all
AddOn.destroy_all
Product.destroy_all
Category.destroy_all

puts "Creating categories..."
# 1. สร้าง หมวดหมู่สินค้า (Categories)
starters = Category.create!(name: "Starters", description: "เมนูทานเล่น", position: 1, active: true)
main_dishes = Category.create!(name: "Main Dishes", description: "เมนูอาหารไทยและฟิวชันเลิศรส", position: 2, active: true)
street_foods = Category.create!(name: "Street Foods", description: "เมนูอาหารไทยและฟิวชันเลิศรส", position: 3, active: true)
soups = Category.create!(name: "Soups", description: "เมนูต้มและซุปรสจัดจ้าน", position: 4, active: true)
rice_sides = Category.create!(name: "Rice & Sides", description: "เมนูอาหารไทยและฟิวชันเลิศรส", position: 5, active: true)
dessert_drinks = Category.create!(name: "Dessert & Drinks", description: "เมนูอาหารไทยและฟิวชันเลิศรส", position: 6, active: true)
box_sets = Category.create!(name: "Box Sets", description: "เมนูอาหารไทยและฟิวชันเลิศรส", position: 7, active: true)

puts "Creating products..."

# 2. สร้าง รายการอาหารทั้ง 5 เมนู
main_dishes.products.create!([
  { name: "ข้าวผัด",
    description: "ข้าวผัดเรียงเมล็ดสวย ผัดด้วยไฟแรง หอมกลิ่นกระทะ พร้อมไข่และผักสด เสิร์ฟพร้อมมะนาวและน้ำปลาพริก",
    price_cents: 6000,
    active: true,
    available: true,
    position: 1,
    featured: false,
    bestseller: true,
    image_url: "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500"
  },
  { name: "ผัดไทย",
    description: "ข้าวผัดเรียงเมล็ดสวย ผัดด้วยไฟแรง หอมกลิ่นกระทะ พร้อมไข่และผักสด เสิร์ฟพร้อมมะนาวและน้ำปลาพริก",
    price_cents: 6000,
    active: true,
    available: true,
    position: 2,
    featured: false,
    bestseller: true,
    image_url: "https://images.unsplash.com/photo-1655091273851-7bdc2e578a88?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=500"
  },
  { name: "ผัดกะเพรา",
    description: "เส้นยากิโซบะเหนียวนุ่ม ผัดซอสยากิโซบะสไตล์ญี่ปุ่น เข้มข้น พร้อมเนื้อหมูและผักกะหล่ำ โรยสาหร่าย",
    price_cents: 8900,
    active: true,
    available: true,
    position: 3,
    featured: false,
    bestseller: false,
    image_url: "https://images.unsplash.com/photo-1652265540600-a319e0e4fd81?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=500"
  },
  { name: "ยากิโซบะ",
    description: "เส้นยากิโซบะเหนียวนุ่ม ผัดซอสยากิโซบะสไตล์ญี่ปุ่น เข้มข้น พร้อมเนื้อหมูและผักกะหล่ำ โรยสาหร่าย",
    price_cents: 8900,
    active: true,
    available: true,
    position: 4,
    featured: false,
    bestseller: false,
    image_url: "https://images.unsplash.com/photo-1617093727343-374698b1b08d?w=500"
  }
])

soups.products.create!([
  { name: "ต้มยำกุ้ง",
    description: "ต้มยำกุ้งแม่น้ำน้ำข้น รสชาติเข้มข้นจัดจ้าน หอมกลิ่นสมุนไพร ตะไคร้ ใบมะกรูด และข่า",
    price_cents: 15000,
    active: true,
    available: true,
    position: 1,
    featured: false,
    bestseller: true,
    image_url: "https://images.unsplash.com/photo-1548943487-a2e4e43b4853?w=500"
  },
  { name: "ต้มข่าไก่",
    description: "ต้มข่าไก่เนื้อนุ่มในน้ำกะทิหอมมัน รสกลมกล่อมเปรี้ยวนำเค็มตาม กลมกล่อมด้วยสมุนไพรไทย",
    price_cents: 12000,
    active: true,
    available: true,
    position: 2,
    featured: false,
    bestseller: false,
    image_url: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=500"
  }
])

street_foods.products.create!([
  { name: "หมูสะเต๊ะ",
    description: "หมูสะเต๊ะเนื้อนุ่มหมักเครื่องเทศ ย่างเตาถ่านหอมๆ เสิร์ฟคู่กับน้ำจิ้มถั่วรสเข้มข้นและอาจาด (10 ไม้)",
    price_cents: 9000,
    active: true,
    available: true,
    position: 1,
    featured: true,
    bestseller: false,
    image_url: "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=500"
  },
  { name: "หมูปิ้งนมสด",
    description: "หมูปิ้งหมักนมสดนุ่มลิ้น ย่างสุกกำลังดี หอมหวานกลมกล่อม เสิร์ฟร้อนๆ (ชุด 5 ไม้ พร้อมข้าวเหนียว)",
    price_cents: 5500,
    active: true,
    available: true,
    position: 2,
    featured: true,
    bestseller: false,
    image_url: "https://images.unsplash.com/photo-1625477811233-044633d10dd1?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=500"
  }
  ])

starters.products.create!([
  { name: "ปอเปี๋ยะทอด",
    description: "หมูปิ้งหมักนมสดนุ่มลิ้น ย่างสุกกำลังดี หอมหวานกลมกล่อม เสิร์ฟร้อนๆ (ชุด 5 ไม้ พร้อมข้าวเหนียว)",
    price_cents: 2500,
    active: true,
    available: true,
    position: 1,
    featured: false,
    bestseller: false,
    image_url: "https://images.unsplash.com/photo-1695712641569-05eee7b37b6d?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=500"
  }
])
rice_sides.products.create!([
  { name: "Jasmin Rice",
    description: "หมูปิ้งหมักนมสดนุ่มลิ้น ย่างสุกกำลังดี หอมหวานกลมกล่อม เสิร์ฟร้อนๆ (ชุด 5 ไม้ พร้อมข้าวเหนียว)",
    price_cents: 2500, # 55.00 บาท
    active: true,
    available: true,
    position: 1,
    featured: false,
    bestseller: false,
    image_url: "https://plus.unsplash.com/premium_photo-1701011134262-bbf05336ca42?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=500"
  }
  ])

dessert_drinks.products.create!([
  { name: "Thai Tea",
    description: "หมูปิ้งหมักนมสดนุ่มลิ้น ย่างสุกกำลังดี หอมหวานกลมกล่อม เสิร์ฟร้อนๆ (ชุด 5 ไม้ พร้อมข้าวเหนียว)",
    price_cents: 5500, # 55.00 บาท
    active: true,
    available: true,
    position: 1,
    featured: false,
    bestseller: false,
    image_url: "https://images.unsplash.com/photo-1644031995386-fe9665dc5b57?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=500"
  }
  ])

box_sets.products.create!([
  { name: "Thai Box",
    description: "หมูปิ้งหมักนมสดนุ่มลิ้น ย่างสุกกำลังดี หอมหวานกลมกล่อม เสิร์ฟร้อนๆ (ชุด 5 ไม้ พร้อมข้าวเหนียว)",
    price_cents: 6000, # 55.00 บาท
    active: true,
    available: true,
    position: 1,
    featured: false,
    bestseller: false,
    image_url: "https://plus.unsplash.com/premium_photo-1732139050014-15f78e3c7f70?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=500"
  }
  ])

# --- สร้าง Options หลัก ---
meat_option = Option.create!(
  name: "เลือกเนื้อสัตว์",
  required: true,      # บังคับเลือก
  multiple: false,     # เลือกได้แค่อย่างเดียว (Radio button)
  position: 1
)

spicy_option = Option.create!(
  name: "ระดับความเผ็ด",
  required: true,
  multiple: false,
  position: 2
)

# --- สร้าง Option Choices (ตัวเลือกย่อยของ Option นั้นๆ) ---
meat_option.option_choices.create!([
  { name: "ไก่ (Chicken)", price_cents: 0, position: 1 },
  { name: "หมู (Pork)", price_cents: 0, position: 2 },
  { name: "เนื้อวัว (Beef)", price_cents: 200, position: 3 },     # +2.00 €
  { name: "กุ้ง (Shrimp)", price_cents: 300, position: 4 }       # +3.00 €
])

spicy_option.option_choices.create!([
  { name: "เผ็ดน้อย (Mild)", price_cents: 0, position: 1 },
  { name: "เผ็ดปานกลาง (Medium)", price_cents: 0, position: 2 },
  { name: "เผ็ดมาก (Very Spicy)", price_cents: 0, position: 3 }
])

# --- สร้าง Add-ons รวมของร้าน ---
rice1 = AddOn.create!(
  name: "Jasmine Rice",
  description: "ไข่ดาวกรอบไข่แดงยางมะตอย",
  price_cents: 250,    # +1.50 €
  available: true
)
rice2 = AddOn.create!(
  name: "Rice Stick",
  description: "ไข่ดาวกรอบไข่แดงยางมะตอย",
  price_cents: 250,    # +1.50 €
  available: true
)

egg1 = AddOn.create!(
  name: "Fried Egg(ไข่ดาว)",
  description: "ไข่ดาวกรอบไข่แดงยางมะตอย",
  price_cents: 200,    # +2.00 €
  available: true
)
egg2 = AddOn.create!(
  name: "Omlette(ไข่เจียว)",
  description: "ไข่ดาวกรอบไข่แดงยางมะตอย",
  price_cents: 200,    # +2.00 €
  available: true
)

sauce1 = AddOn.create!(
  name: "Jim Jaew sauce",
  description: "น้ำจิ้มแจ่ว",
  price_cents: 150,    # +1.50 €
  available: true
)

sauce2 = AddOn.create!(
  name: "Sweety sauce",
  description: "น้ำจิ้มแจ่ว",
  price_cents: 150,    # +1.50 €
  available: true
)

out_of_stock_addon = AddOn.create!(
  name: "Nems Légumes (เปี๊ยะทอดเจ)",
  description: "ปอเปี๊ยะทอดไส้ผัก 2 ชิ้น",
  price_cents: 300,    # +3.00 €
  available: false     # สินค้าหมด (แสดง Indisponible หน้าเว็บ)
)

# --- 3.1 ผูก Product กับ Options (ProductOptions) ---
# ข้าวผัด: ต้องเลือกเนื้อสัตว์ และ ระดับความเผ็ด
khao_pad = Product.find_by!(name: "ข้าวผัด")
ProductOption.create!([
  { product: khao_pad, option: meat_option, position: 1 },
  { product: khao_pad, option: spicy_option, position: 2 }
])

pad_kaprao = Product.find_by!(name: "ผัดกะเพรา")
ProductOption.create!([
  { product: pad_kaprao, option: meat_option, position: 1 },
  { product: pad_kaprao, option: spicy_option, position: 2 }
])


# ต้มยำกุ้ง: เลือกเฉพาะระดับความเผ็ด
tom_yum = Product.find_by!(name: "ต้มยำกุ้ง")
ProductOption.create!([
  { product: tom_yum, option: spicy_option, position: 1 }
])

# --- 3.2 ผูก Product กับ Add-ons (ProductAddOns) ---
# ข้าวผัด: ให้เลือกเพิ่มไข่ดาว, เพิ่มเนื้อ, ไก่กรอบ หรือเปี๊ยะทอดเจได้
ProductAddOn.create!([
  { product: khao_pad, add_on: egg1, position: 1 },
  { product: khao_pad, add_on: egg2, position: 2 },
  { product: khao_pad, add_on: sauce1, position: 3 },
  { product: khao_pad, add_on: sauce2, position: 4 },
  { product: khao_pad, add_on: out_of_stock_addon, position: 5 }
])

puts "Successfully created #{Category.count} category #{Product.count} products #{ProductOption.count} productoption #{ProductAddOn.count} productaddon #{Option.count} option #{OptionChoice.count} optionchoice!"
