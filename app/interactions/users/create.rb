module Users
  class Create < ActiveInteraction::Base
    GENDERS = %w[male female].freeze

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
      return if email_exists?
      return unless valid_age? && valid_gender?

      create_user
    end

    private

    def email_exists?
      User.where('LOWER(email) = LOWER(?)', params[:email]).exists?
    end

    def valid_age?
      (1..90).include?(params[:age])
    end

    def valid_gender?
      GENDERS.include?(params[:gender])
    end

    def create_user
      user_full_name = params.values_at(:surname, :name, :patronymic).join(" ").strip
      user_params = params.except(:interests)

      User.transaction do
        user = User.new(user_params.merge(fullname: user_full_name))
        associate_interests(user)
        associate_skills(user)
        user.save!
      end
    end

    def associate_interests(user)
      Interest.where(name: params[:interests]).find_each do |interest|
        user.interests << interest
      end
    end

    def associate_skills(user)
      Skill.where(name: params[:skills]&.split(',')).find_each do |skill|
        user.skills << skill
      end
    end
  end
end
