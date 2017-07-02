defmodule BorrowBee.Factory do
  use ExMachina.Ecto, repo: BorrowBee.Repo

  alias BorrowBee.{User, LoginToken}

  def user_factory do
    %User{
      email: sequence(:email, &"user_#{&1}@example.com"),
      name: sequence(:name, &"user_#{&1}"),
      photo_url: nil,
      location: nil,
      is_admin: false
    }
  end

  def login_token_factory do
    %LoginToken{
      token: sequence(:token, &"asdf_#{&1}"),
      user: build(:user)
    }
  end
end
