defmodule PhxCrud.CreateRecord do
  # pass options like this
  # use PhxCrud.CreateRecord, repo: MyApp.Repo
  defmacro __using__(options \\ []) do
    quote location: :keep do
      @options unquote(options)
      @phx_model @options[:model] || @model
      @repo @options[:repo] || Application.get_env(:phx_crud, :repo)
      @error_view @options[:error_view] || Application.get_env(:phx_crud, :error_view)
      @view @options[:view] || Application.get_env(:phx_crud, :view)

      if !@repo do
        raise "Please specify phx_crud Repo in config or while calling this macro"
      end

      if !@error_view do
        raise "Please specify phx_crud error_view in config or while calling this macro"
      end

      if !@view do
        raise "Please specify phx_crud view in config or while calling this macro"
      end

      def create(conn, %{@singular => params}) do
        changeset = @phx_model.changeset(struct(@phx_model), params)

        with {:ok, record} <- @repo.insert(changeset) do
          conn
          |> put_status(:created)
          |> render(@view, :show, record: record)
        else
          {:error, changeset} ->
            conn
            |> put_status(422)
            |> render(
              @error_view,
              :errors,
              code: 422,
              message: "Invalid changeset",
              changeset: changeset
            )
        end
      end

      defoverridable create: 2
    end
  end
end
