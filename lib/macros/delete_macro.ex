defmodule PhxCrud.DeleteRecord do
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

      def delete(conn, %{"id" => id}) do
        case @phx_crud_repo.get(@phx_crud_model, id) do
          nil ->
            conn
            |> put_status(404)
            |> render(@phx_crud_error_view, :error, code: 404, message: "Record not found")

          record ->
            case @phx_crud_repo.delete(record) do
              {:ok, struct} ->
                conn
                |> render(@phx_crud_view, :show, record: struct)

              {:error, changeset} ->
                conn
                |> put_status(422)
                |> render(
                  @phx_crud_error_view,
                  :errors,
                  code: 422,
                  message: "Error deleting this record",
                  changeset: changeset
                )
            end
        end
      end
    end
  end
end
