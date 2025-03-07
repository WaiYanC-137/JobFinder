require 'faker'

# Clear existing data (optional, uncomment if needed)
# MUsersTJobOffer.delete_all
# TJobOffer.delete_all
# MUser.delete_all
# MCompany.delete_all
# TSkill.delete_all
# TLocation.delete_all
# TCategory.delete_all

puts "Creating 5 random users..."
5.times do
  MUser.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password123',
    phone: Faker::PhoneNumber.cell_phone,
    about: "私の目標はﾌﾟﾛｸﾞﾗﾏｰになることです。大学でJava、Android,Tomcat Server、MySql、UML、C、C ++、OOP、JavaScript、HTML、XMLを勉強しました。2016年2月に卒業しました。大学から勉強した言語を使っていろいろなﾌﾟﾛｼﾞｪｸﾄを開発しています。" # Fixed Japanese description for all users
  )
end

puts "Creating 5 random companies..."
5.times do
  company = MCompany.create!(
    name: Faker::Company.name,
    email: Faker::Internet.unique.email,
    password: 'password123',
    phone: Faker::PhoneNumber.cell_phone,
    info: "ウェアラブルコンピューティングのデバイスおよびシステム開発、GUIデザイン、ソフトウェアフュージョン、センサネットワークシステム開発、AR／画像処理システム開発などを手がけている、ウェアラブルデバイスのトップカンパニーです。",
    address: "78st30st, ChanAyeTharZan Township, Mandalay"
  )
  # Assign a random location from TLocation to the company
  company.update!(location: TLocation.sample)
end

puts "Creating 7 random skills..."
7.times do
  TSkill.create!(title: Faker::Job.key_skill)
end

puts "Creating 7 random locations..."
7.times do
  TLocation.create!(city: Faker::Address.city)
end

puts "Creating 7 random categories..."
7.times do
  TCategory.create!(title: Faker::Job.field)
end

# Fetch all records
users = MUser.all
companies = MCompany.all
skills = TSkill.all
locations = TLocation.all
categories = TCategory.all

puts "Creating 10 random job offers..."
50.times do
  TJobOffer.create!(
    title: categories.sample.title, # Use category as title
    minsalary: [100000, 200000, 300000, 400000].sample,
    maxsalary: [300000, 400000, 500000, 600000].sample,
    location: locations.sample,
    category: categories.sample,
    description: Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false),
    company: companies.sample
  )
end

# Fetch job offers after creation
job_offers = TJobOffer.all

puts "Assigning 3-7 random skills to each job offer..."
job_offers.each do |job_offer|
  job_offer.t_skills = skills.sample(rand(3..7)) # Randomly select between 3 to 7 skills
  job_offer.save!
end

puts "Assigning a random category and location to each user..."
users.each do |user|
  user.update!(
    category: categories.sample, 
    location: locations.sample
  )
end

puts "Each user is applying to 7-11 random jobs..."
users.each do |user|
  applied_jobs = job_offers.sample(rand(7..11)) # Select random jobs between 7 to 11 jobs
  applied_jobs.each do |job|
    MUsersTJobOffer.create!(m_user: user, t_job_offer: job)
  end
end

puts "Seeding completed successfully!"
