10.times do
    # Generate random user data
    name = Faker::Name.name
    email = Faker::Internet.email
    password = 'password'
    about = Faker::Lorem.sentence(word_count: 30) # Random text (adjust based on Faker localization)
    phone = Faker::PhoneNumber.phone_number
    location_id = rand(1..4) # Random location_id between 1 and 4
    category_id = rand(1..4) # Random category_id between 1 and 4
  
    # Create the user
    user = MUser.create!(
      name: name,
      email: email,
      password: password,
      about: about,
      phone: phone,
      location_id: location_id,
      category_id: category_id # Add random category_id
    )
  
    # Add up to 4 random skills (from the TSkill table)
    skill_ids = TSkill.pluck(:id).sample(4) # Choose up to 4 random skill IDs
    user.t_skills << TSkill.where(id: skill_ids) # Assign skills to the user
  end
  