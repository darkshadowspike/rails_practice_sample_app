class User < ApplicationRecord
	before_save {self.email = self.email.downcase}
	validates(:name, :email, presence: true , length: {maximum: 50})
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates(:email, length: {maximum: 244} , format: {with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false})
    validates(:password, length:{ minimum: 6}, presence: true)
    has_secure_password 

    def User.digest(string)
    	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost

    	
    	BCrypt::Password.create(string, cost: cost)
    end
end
