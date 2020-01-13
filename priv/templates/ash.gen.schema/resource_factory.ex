defmodule <%= inspect ctx.base %>.<%= inspect schema.alias %>Factory do
  alias <%= inspect schema.module %>

  defmacro __using__(_opts) do
    quote do
      def <%= schema.singular %>_factory do
        %<%= inspect schema.alias %>{<%= for {k, _v} <- schema.attrs do %>
          <%= k %>: <%= inspect schema.params.create[k] %>,<% end %>
        }
      end
    end
  end
end
