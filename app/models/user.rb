class User < ApplicationRecord
	attr_accessor :remember_token

    before_save {self.email = self.email.downcase}
	validates(:name, :email, presence: true , length: {maximum: 50})
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates(:email, length: {maximum: 244} , format: {with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false})
    validates(:password, length:{ minimum: 6}, presence: true)
    has_secure_password 
    
    # Returns the hash digest of the given string.
    def self.digest(string)
    	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost

    	
    	BCrypt::Password.create(string, cost: cost)
    end
     
     # Returns a random token.
    def self.new_token
     SecureRandom.urlsafe_base64
    end

     
  # Remembers a user in the database for use in persistent sessions.  
    def remember 
     self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
    end

  # Forgets a user.

    def forget 
     update_attribute(:remember_digest, nil)
    end  

  # Returns true if the given token matches the digest.
    def authenticated?(remember_token)
      if remember_digest.nil?
        false
      else
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
      end
    end
     

end
