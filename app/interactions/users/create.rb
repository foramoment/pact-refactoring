module Users
  class Create < ActiveInteraction::Base
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
      return if User.where('LOWER(email) = LOWER(?)', params[:email]).exists?
      return unless (1..90).include?(params[:age])
      return unless %w[male female].include?(params[:gender])

      user_full_name = params.values_at(:surname, :name, :patronymic).join(" ").strip

      user_params = params.except(:interests)
      User.transaction do
        user = User.new(user_params.merge(fullname: user_full_name))

        Interest.where(name: params[:interests]).find_each do |interest|
          user.interests << interest
        end

        Skill.where(name: params[:skills]&.split(',')).find_each do |skill|
          user.skills << skill
        end
        user.save!
      end
    end
  end
end
