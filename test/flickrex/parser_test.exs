defmodule Flickrex.ParserTest do
  use ExUnit.Case

  import Flickrex.Parser

  setup_all do
    context = [fail: File.read!("test/fixtures/fail.json"),
               null: File.read!("test/fixtures/null.json"),
               user: File.read!("test/fixtures/user.json"),
               photo: File.read!("test/fixtures/photo.json"),
               photos: File.read!("test/fixtures/photos.json"),
               method: File.read!("test/fixtures/method.json")]
    {:ok, context}
  end

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

  test "fail", context do
    response = parse(context[:fail])
    assert response == {:error, "Method \"flickr.fakeMethod\" not found"}
  end

  test "null", context do
    response = parse(context[:null])
    assert response == {:ok, %{}}
  end

  test "user", context do
    response = parse(context[:user])
    user = %{"user" => %{"id" => "35034362831@N01", "username" => %{"_content" => "Joi"},
                         "nsid" => "35034362831@N01"}}
    assert response == {:ok, user}
  end

  test "photo", context do
    {:ok, response} = parse(context[:photo])
    assert response["photo"]["id"] == "477842380"
    assert response["photo"]["title"] == %{"_content" => "Joi with backyard bamboo"}
    assert List.first(response["photo"]["tags"]["tag"])["_content"] == "joiito"
  end

  test "photos", context do
    {:ok, response} = parse(context[:photos])
    assert response["photos"]["perpage"] == 2
    assert length(response["photos"]["photo"]) == 2
  end

  test "method", context do
    {:ok, response} = parse(context[:method])
    assert Map.keys(response) == ["arguments", "errors", "method"]
    assert response["arguments"]["argument"] |> List.first |> Map.has_key?("name")
  end
end
