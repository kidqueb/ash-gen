defmodule AshWeb.Schema.PostResolver do
  import Ash.Helpers.PolicyHelpers
  alias Ash.Blog

  def create(%{post: post}, _info) do
    case Blog.create_post(post) do
      {:ok, post} -> {:ok, post}
      {:error, error} -> {:error, error}
    end
  end

  def find(%{id: id}, _info) do
    Blog.fetch_post(id)
  end

  def all(args, _info) do
    {:ok, Blog.list_posts(args)}
  end

  def update(%{id: id, post: post_params}, info) do
    with {:ok, current_user} <- get_current_user(info),
    {:ok, post} <- Blog.fetch_post(id),
    :ok <- Blog.permit(:update_post, current_user, post) do
      Blog.update_post(post, post_params)
    else
      {:error, error} -> {:error, error}
      _ -> {:error, "Something went wrong"}
    end
  end

  def delete(%{id: id}, info) do
    with {:ok, current_user} <- get_current_user(info),
    {:ok, post} <- Blog.fetch_post(id),
    :ok <- Blog.permit(:delete_post, current_user, post) do
      Blog.delete_post(post)
    else
      {:error, error} -> {:error, error}
      _ -> {:error, "Something went wrong"}
    end
  end
end
