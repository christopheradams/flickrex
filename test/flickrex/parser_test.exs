defmodule Flickrex.ParserTest do
  use ExUnit.Case

  import Flickrex.Parser

  @fail_response_json File.read!("test/fixtures/fail.json")
  @null_response_json File.read!("test/fixtures/null.json")
  @user_response_json File.read!("test/fixtures/user.json")
  @photo_response_json File.read!("test/fixtures/photo.json")
  @photos_response_json File.read!("test/fixtures/photos.json")
  @method_response_json File.read!("test/fixtures/method.json")

  test "syntax error" do
    assert_raise Poison.SyntaxError, fn ->
      parse("{")
    end
  end

  test "clause error" do
    assert_raise FunctionClauseError, fn ->
      parse("{}")
    end
  end

  test "fail" do
    response = parse(@fail_response_json)
    assert response == {:error, "Method \"flickr.fakeMethod\" not found"}
  end

  test "null" do
    response = parse(@null_response_json)
    assert response == %{}
  end

  test "user" do
    response = parse(@user_response_json)
    user = %{"user" => %{"id" => "35034362831@N01", "username" => %{"_content" => "Joi"},
                         "nsid" => "35034362831@N01"}}
    assert response == user
  end

  test "photo" do
    response = parse(@photo_response_json)
    assert response["photo"]["id"] == "477842380"
    assert response["photo"]["title"] == %{"_content" => "Joi with backyard bamboo"}
    assert List.first(response["photo"]["tags"]["tag"])["_content"] == "joiito"
  end

  test "photos" do
    response = parse(@photos_response_json)
    assert response["photos"]["perpage"] == 2
    assert length(response["photos"]["photo"]) == 2
  end

  test "method" do
    response = parse(@method_response_json)
    assert Map.keys(response) == ["arguments", "errors", "method"]
    assert response["arguments"]["argument"] |> List.first |> Map.has_key?("name")
  end
end
