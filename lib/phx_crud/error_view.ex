defmodule PhxCrud.ErrorView do
  defmacro __using__(_options \\ []) do
    quote do
      #     options = unquote(options)

      # use AdminWeb, :view

      def render("error.json", %{code: code, message: message}) do
        %{error: %{code: code, message: message}}
      end

      def render("errors.json", %{code: code, message: message, errors: errors}) do
        %{error: %{code: code, message: message, errors: errors}}
      end

      def render("errors.json", %{code: code, message: message, changeset: changeset}) do
        %{error: %{code: code, message: message, errors: translate_errors(changeset)}}
      end

      def translate_errors(changeset) do
        Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
      end
    end
  end
end
