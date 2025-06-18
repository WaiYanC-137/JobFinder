require 'faker'

# Clear existing data (optional, uncomment if needed)
# MUsersTJobOffer.delete_all
# TJobOffer.delete_all
# TSkill.delete_all
# TLocation.delete_all
# TCategory.delete_all
# MUser.delete_all
# MCompany.delete_all

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

# Fetch all records after creation
skills = TSkill.all
locations = TLocation.all
categories = TCategory.all

puts "Creating 5 random users..."
while MUser.count < 5
  password = 'password'
  begin
    MUser.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      password: password,
      password_confirmation: password,
      phone: Faker::PhoneNumber.cell_phone,
      category: categories.sample,
      location: locations.sample
    )
  rescue ActiveRecord::RecordInvalid => e
    puts "Error creating user: #{e.message}"
  end
end

puts "Assigning 2 to 4 random skills to each user..."
MUser.all.each do |user|
  random_skills = skills.sample(rand(2..4))
  user.t_skills << random_skills.reject { |s| user.t_skills.include?(s) }
end

puts "Creating 5 random companies..."
while MCompany.count < 5
  location = locations.sample
  begin
    MCompany.create!(
      name: Faker::Company.name,
      email: Faker::Internet.unique.email,
      password: 'password',
      password_confirmation: 'password',
      phone: Faker::PhoneNumber.cell_phone,
      location: location,
      info: '私たちはテクノロジーソリューションとソフトウェア開発サービスの分野でリーディングカンパニーです。',
      address: Faker::Address.full_address
    )
  rescue ActiveRecord::RecordInvalid => e
    puts "Error creating company: #{e.message}"
  end
end

puts "Creating job offers for each company..."
MCompany.all.each do |company|
  rand(2..4).times do
    job_skills = skills.sample(rand(2..4))
    job_location = locations.sample
    job_category = categories.sample

    begin
      company.t_job_offers.create!(
        title: Faker::Job.title,
        description: Faker::Lorem.paragraph(sentence_count: 5),
        location: job_location,
        category: job_category,
        t_skills: job_skills,
        minsalary: rand(5000000..7000000).to_s,
        maxsalary: rand(8000000..10000000).to_s
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Error creating job offer for #{company.name}: #{e.message}"
    end
  end
end

puts "Making users apply to random job offers..."
job_offers = TJobOffer.all
MUser.all.each do |user|
  offers_to_apply = job_offers.sample(rand(2..4))
  user.t_job_offers << offers_to_apply.reject { |offer| user.t_job_offers.include?(offer) }
end

puts "Seeding completed successfully!"
