defmodule <%= inspect context.web_module %>.<%= inspect schema.alias %>ResolverTest do
  use <%= inspect context.web_module %>.ConnCase
  import <%= inspect context.base_module %>.<%= inspect schema.alias %>Factory

  describe "<%= schema.singular %> resolver" do
    test "lists all <%= schema.plural %>", %{conn: conn} do
      <%= schema.plural %> = insert_list(3, :<%= schema.singular %>)

      query = """
        {
          <%= schema.plural %> {
            id
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["<%= schema.plural %>"] == to_id_array(<%= schema.plural %>)
    end

    test "finds a <%= schema.singular %> by id", %{conn: conn} do
      <%= schema.singular %> = insert(:<%= schema.singular %>)

      query = """
        {
          <%= schema.singular %>(id: #{<%= schema.singular %>.id}) {
            id<%= for {k, _v} <- schema.attrs do %>
            <%= k %><% end %>
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["<%= schema.singular %>"] == %{
        "id" => to_string(<%= schema.singular %>.id),<%= for {k, _v} <- schema.attrs do %>
        "<%= k %>" => <%= schema.singular %>.<%= k %>,<% end %>
      }
    end

    test "errors when attempting to find a nonexistent <%= schema.singular %>", %{conn: conn} do
      query = """
        {
          <%= schema.singular %>(id: -1) {
            id
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{"<%= schema.singular %>" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "<%= inspect schema.alias %> not found",
          "path" => ["<%= schema.singular %>"]
        }]
      }
    end

    test "creates a new <%= schema.singular %>", %{conn: conn} do
      <%= schema.singular %>_params = params_for(:<%= schema.singular %>, %{<%= for {k, _v} <- schema.attrs do %>
        <%= k %>: <%= inspect schema.params.create[k] %>,<% end %>
      })

      query = """
        mutation {
          create<%= inspect schema.alias %>(<%= for {k, _v} <- schema.attrs do %>
            <%= k %>: #{inspect <%= schema.singular %>_params.<%= k %>},<% end %>
          ) {<%= for {k, _v} <- schema.attrs do %>
            <%= k %><% end %>
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["create<%= inspect schema.alias %>"] == %{<%= for {k, _v} <- schema.attrs do %>
        "<%= k %>" => <%= schema.singular %>_params.<%= k %>,<% end %>
      }
    end

    test "updates a <%= schema.singular %>", %{conn: conn} do
      <%= schema.singular %> = insert(:<%= schema.singular %>)

      query = """
        mutation Update<%= inspect schema.alias %>($id: ID!, $<%= schema.singular %>: Update<%= inspect schema.alias %>Params!) {
          update<%= inspect schema.alias %>(id:$id, <%= schema.singular %>:$<%= schema.singular %>) {
            id<%= for {k, _v} <- schema.attrs do %>
            <%= k %><% end %>
          }
        }
      """

      variables = %{
        id: <%= schema.singular %>.id,
        <%= schema.singular %>: %{<%= for {k, _v} <- schema.attrs do %>
          <%= k %>: <%= inspect schema.params.update[k] %>,<% end %>
        }
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response["data"]["update<%= inspect schema.alias %>"] == %{
        "id" => to_string(<%= schema.singular %>.id),<%= for {k, _v} <- schema.attrs do %>
        "<%= k %>" => variables.<%= schema.singular %>.<%= k %>,<% end %>
      }
    end

    test "errors updating a nonexistent <%= schema.singular %>", %{conn: conn} do
      query = """
        mutation Update<%= inspect schema.alias %>($id: ID!, $<%= schema.singular %>: Update<%= inspect schema.alias %>Params!) {
          update<%= inspect schema.alias %>(id:$id, <%= schema.singular %>:$<%= schema.singular %>) {
            id
          }
        }
      """

      variables = %{
        id: "-1",
        post: %{}
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response == %{
        "data" => %{"update<%= inspect schema.alias %>" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "<%= inspect schema.alias %> not found",
          "path" => ["update<%= inspect schema.alias %>"]
        }]
      }
    end

    test "deletes a <%= schema.singular %>", %{conn: conn} do
      <%= schema.singular %> = insert(:<%= schema.singular %>)

      query = """
        mutation {
          delete<%= inspect schema.alias %>(id: #{<%= schema.singular %>.id}) {
            id
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["delete<%= inspect schema.alias %>"] == %{
        "id" => to_string(<%= schema.singular %>.id)
      }
    end

    test "errors deleting a nonexistent <%= schema.singular %>", %{conn: conn} do
      query = """
        mutation {
          delete<%= inspect schema.alias %>(id: -1) {
            id
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{"delete<%= inspect schema.alias %>" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "<%= inspect schema.alias %> not found",
          "path" => ["delete<%= inspect schema.alias %>"]
        }]
      }
    end
  end
end
