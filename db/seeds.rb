10.times do
    # Generate random user data
    name = Faker::Name.name
    email = Faker::Internet.email
    password = 'password'
    password_confirmation = 'password'
    about = Faker::Lorem.sentence(word_count: 30) # Random text (adjust based on Faker localization)
    phone = Faker::PhoneNumber.phone_number
    location_id = rand(1..2) # Random location_id between 1 and 4
    category_id = rand(1..3) # Random category_id between 1 and 4
  
    # Create the user
    user = MUser.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      about: about,
      phone: phone,
      location_id: location_id,
      category_id: category_id # Add random category_id
    )
  
    # Add up to 4 random skills (from the TSkill table)
    skill_ids = TSkill.pluck(:id).sample(4) # Choose up to 4 random skill IDs
    user.t_skills << TSkill.where(id: skill_ids) # Assign skills to the user
  end
  10.times do
    # Ensure there are valid category and location IDs
    location_id = rand(1..2) # Random location_id between 1 and 4
    category_id = rand(1..3) # Random category_id between 1 and 4
  
  
    # Generate random job offer data
    
    minsalary = rand(10000..20000)  # Random minimum salary
    maxsalary = rand(30000..50000) # Ensure max is greater than min
    description = Faker::Lorem.paragraph(sentence_count: 5) # Random job description
  
    # Create the job offer
    joboffer=TJobOffer.create!(
      
      minsalary: minsalary,
      maxsalary: maxsalary,
      location_id: location_id,
      category_id: category_id,
      description: description
    )

        # Add up to 4 random skills (from the TSkill table)
        skill_ids = TSkill.pluck(:id).sample(4) # Choose up to 4 random skill IDs
        joboffer.t_skills << TSkill.where(id: skill_ids) # Assign skills to the joboffers
  end
  