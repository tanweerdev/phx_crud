defmodule PhxCrud.View do
  defmacro __using__(options \\ []) do
    quote do
      @options unquote(options)
      @view_wrapper @options[:view_wrapper] || :record
      def render("show.json", %{record: record}) do
        %{
          @view_wrapper => Utils.Map.sanitize_map(record)
        }
      end
    end
  end
end
