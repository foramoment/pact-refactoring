module Users
  class Create < ActiveInteraction::Base
    EXAMPLE_PARAMS = {
      name: "Aleksey",
      surname: "Dudnikov",
      # patronymic: "Alekseevich",
      email: "xthelastsecretx@gmail.com",
      age: 33,
      nationality: "Russian",
      country: "Russia",
      gender: "male"
    }

    hash :params do
      string :name
      string :surname
      string :patronymic, default: nil
      string :email
      integer :age
      string :nationality
      string :country
      string :gender
    end

    def execute
      debugger
      return if User.where(email: params[:email].downcase).exists?
      return unless (1..90).include?(params[:age])
      return unless %w[male female].include?(params[:gender])

      user_full_name = params.values_at(:surname, :name, :patronymic).join(" ").strip

      user_params = params.except(:interests)
      user = User.create(user_params.merge(fullname: user_full_name))

      Interest.where(name: params["interests"]).each do |interest|
          user.interests = user.interest + interest
          user.save!
        end

      user_skills = []
      params["skills"].split(",").each do |skil|
          skil = Skil.find(name: skil)
          user_skills = user_skills + [skil]
        end

      user.skills = user_skills
      user.save
    end
  end
end
