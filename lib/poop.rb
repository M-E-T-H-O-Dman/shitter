class Poop
	include DataMapper::Resource

	 
	  property :id,     Serial
	  property :user_id, String 
	  property :poop,  String
end	