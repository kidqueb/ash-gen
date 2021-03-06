defmodule <%= inspect gql.schema_alias %>Resolver do
  import <%= inspect context.base_module %>.Helpers.PolicyHelpers
  alias <%= inspect context.module %>

  def create(%{<%= schema.singular %>: <%= schema.singular %>}, _info) do
    case <%= inspect context.alias %>.create_<%= schema.singular %>(<%= schema.singular %>) do
      {:ok, <%= schema.singular %>} -> {:ok, <%= schema.singular %>}
      {:error, error} -> {:error, error}
    end
  end

  def find(%{id: id}, _info) do
    <%= inspect context.alias %>.fetch_<%= schema.singular %>(id)
  end

  def all(args, _info) do
    {:ok, <%= inspect context.alias %>.list_<%= schema.plural %>(args)}
  end

  def update(%{id: id, <%= schema.singular %>: <%= schema.singular %>_params}, info) do
    with {:ok, current_user} <- get_current_user(info),
    :ok <- <%= inspect context.alias %>.permit(:update_<%= schema.singular %>, current_user, dirty_id(id)),
    {:ok, <%= schema.singular %>} <- <%= inspect context.alias %>.fetch_<%= schema.singular %>(id) do
      <%= inspect context.alias %>.update_<%= schema.singular %>(<%= schema.singular %>, <%= schema.singular %>_params)
    else
      {:error, error} -> {:error, error}
      _ -> {:error, :internal_server_error}
    end
  end

  def delete(%{id: id}, info) do
    with {:ok, current_user} <- get_current_user(info),
    :ok <- <%= inspect context.alias %>.permit(:delete_<%= schema.singular %>, current_user, dirty_id(id)),
    {:ok, <%= schema.singular %>} <- <%= inspect context.alias %>.fetch_<%= schema.singular %>(id) do
      <%= inspect context.alias %>.delete_<%= schema.singular %>(<%= schema.singular %>)
    else
      {:error, error} -> {:error, error}
      _ -> {:error, :internal_server_error}
    end
  end
end
