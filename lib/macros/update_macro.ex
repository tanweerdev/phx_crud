defmodule PhxCrud.UpdateRecord do
  defmacro __using__(options \\ []) do
    quote do
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

      def update(conn, %{"id" => id, @singular => params}) do
        with record <- @repo.get(@phx_model, id),
             true <- record != nil,
             changeset = @phx_model.changeset(record, params),
             #  true <- changeset.valid?,
             {:ok, record} <- @repo.update(changeset) do
          render(conn, @view, :show, record: record)
        else
          false ->
            conn
            |> put_status(404)
            |> render(@error_view, :error, code: 404, message: "Record not found")

          {:error, changeset} ->
            conn
            |> put_status(422)
            |> render(
              @error_view,
              :errors,
              code: 422,
              message: "Invalid Changeset",
              changeset: changeset
            )
        end
      end
    end
  end
end
