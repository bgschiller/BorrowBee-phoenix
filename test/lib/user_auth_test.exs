defmodule BorrowBee.UserAuthTest do
  use BorrowBee.ModelCase

  import BorrowBee.Factory
  import BorrowBee.UserAuth
  alias BorrowBee.LoginToken


  test "create token inserts to db", %{} do
    user = insert(:user)

    {:ok, token} = create_token(user)
    assert Repo.get_by!(LoginToken, user_id: user.id, token: token)
  end

  test "get_or_create_user finds existing user", %{} do
    user = insert(:user)

    {:ok, user_back} = get_or_create_user(%{"email" => user.email})
    assert user.id == user_back.id
  end

  test "get_or_create_user creates user that doesn't exist", %{} do
    user = build(:user)

    {:ok, user_back} = get_or_create_user(%{"email" => user.email})
    assert user_back.id
    assert user.email == user_back.email
  end

  test "send_login_token will send an email", %{} do
    user = insert(:user)
    cb = fn(u, t) ->
      send self(), {:called_back, u, t}
      {:ok}
    end

    {:ok, _user, _token} = send_login_token(%{"email" => user.email}, cb)
    assert_received {:called_back, _u, _t}

  end
end
