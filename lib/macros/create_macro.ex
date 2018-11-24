defmodule PhxCrud.CreateRecord do
  # pass options like this
  # use PhxCrud.CreateRecord, repo: MyApp.Repo
  defmacro __using__(options \\ []) do
    quote location: :keep do
      @options unquote(options)
      @phx_crud_model @options[:model] || @model
      @phx_crud_repo @options[:repo] || Application.get_env(:phx_crud, :repo)
      @phx_crud_error_view @options[:error_view] || Application.get_env(:phx_crud, :error_view)
      @phx_crud_view @options[:view] || @view

      if !@phx_crud_repo do
        raise "Please specify phx_crud Repo in config or while calling this macro"
      end

      if !@phx_crud_error_view do
        raise "Please specify phx_crud error_view in config or while calling this macro"
      end

      if !@phx_crud_view do
        raise "Please specify phx_crud view in config or while calling this macro"
      end

      def create(conn, %{@singular => params}) do
        changeset = @phx_crud_model.changeset(struct(@phx_crud_model), params)

        with {:ok, record} <- @phx_crud_repo.insert(changeset) do
          conn
          |> put_status(:created)
          |> render(@phx_crud_view, :show, record: record)
        else
          {:error, changeset} ->
            conn
            |> put_status(422)
            |> render(
              @phx_crud_error_view,
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
