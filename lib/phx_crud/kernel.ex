defmodule PhxCrud.Kernel do
  @moduledoc false

  defmacro __using__(options) do
    quote do
      @options unquote(options)

      me = to_string(__MODULE__)

      re = ~r(Controller$|Model$|View$|Agent$|Helper$|Service$|Enum$|Docs$)

      @module Regex.replace(re, me, "")

      @model String.to_atom(@module)

      @singular @options[:singular] ||
                  @module |> String.split(".") |> List.last() |> Macro.underscore()
    end
  end
end
