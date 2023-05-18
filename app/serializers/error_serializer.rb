class ErrorSerializer
  def self.serialize(error)
    {
      errors: [
        {
          detail: error
        }
      ]
    }
  end
end

# def initialize(error)
#   @error = error
# end

# def serialize
#   {
#     errors: [
#       {
#         status: "404",
#         title: error.message
#       }
#     ]
#   }
# end