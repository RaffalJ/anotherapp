module BaseMonad
  include Dry::Monads
  include Dry::Monads::Do.for(:call)
end
