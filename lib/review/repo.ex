defmodule Review.Repo do
  use Ecto.Repo, otp_app: :review
  import Ecto.Query

  alias Review.{Commit, Comment, Author}

  def find_or_insert_author_by_username(username) do
    Author
    |> where(username: ^username)
    |> one_or_insert(%Author{email: "todo@example.com", username: username, name: "Todo"})
  end

  def find_or_insert_author_by_email(email) do
    Author
    |> where(email: ^email)
    |> one_or_insert(%Author{email: email})
  end

  def commits_data(limit) do
    commits
    |> Ecto.Query.limit(^limit)
    |> all
    |> Review.CommitSerializer.serialize
  end

  def comments_data(limit) do
    comments
    |> Ecto.Query.limit(^limit)
    |> all
    |> Review.CommentSerializer.serialize
  end

  def commits do
    from _ in Commit,
      order_by: [ desc: :id ],
      preload:  [ :author, :reviewed_by_author, :review_started_by_author ]
  end

  def comments do
    from _ in Comment,
      order_by: [ desc: :id ],
      preload:  [ [ commit: :author ], :author, :resolved_by_author ]
  end

  defp one_or_insert(query, data) do
    query
    |> one
    |> one_or_insert_result(data)
  end

  defp one_or_insert_result(nil, data) do
    {:ok, record} = data |> insert
    record
  end
  defp one_or_insert_result(record, _data), do: record
end
