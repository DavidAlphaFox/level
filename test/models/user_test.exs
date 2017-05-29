defmodule Bridge.UserTest do
  use Bridge.ModelCase

  alias Bridge.User

  @valid_signup_params %{
    email: "derrick@bridge.chat",
    username: "derrick",
    time_zone: "America/Chicago",
    password: "$ecret$"
  }

  describe "signup_changeset/2" do
    test "validates with valid data" do
      changeset = User.signup_changeset(%User{}, @valid_signup_params)
      assert changeset.valid?
    end

    test "sets the default time zone if one is not provided" do
      {_value, params} = Map.pop(@valid_signup_params, :time_zone)
      changeset = User.signup_changeset(%User{}, params)
      %{time_zone: time_zone} = changeset.changes

      assert changeset.valid?
      assert time_zone == "UTC"
    end

    test "sets the default time zone if provided value is blank" do
      params = Map.put(@valid_signup_params, :time_zone, "")
      changeset = User.signup_changeset(%User{}, params)
      %{time_zone: time_zone} = changeset.changes

      assert changeset.valid?
      assert time_zone == "UTC"
    end

    test "hashes the password" do
      changeset = User.signup_changeset(%User{}, @valid_signup_params)
      %{password: password, password_hash: password_hash} = changeset.changes

      assert password_hash
      assert Comeonin.Bcrypt.checkpw(password, password_hash)
    end

    test "sets the initial state" do
      changeset = User.signup_changeset(%User{}, @valid_signup_params)
      %{state: state} = changeset.changes

      assert state == 0
    end

    test "sets the initial role" do
      changeset = User.signup_changeset(%User{}, @valid_signup_params)
      %{role: role} = changeset.changes

      assert role == 0
    end
  end
end
