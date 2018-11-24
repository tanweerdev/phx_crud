defmodule PhxCrud.Utils.Map do
  def sanitize_map(records) when is_list(records) do
    Enum.reduce(records, [], fn rec, acc ->
      acc ++ [sanitize_map(rec)]
    end)
  end

  def sanitize_map(record) do
    schema_keys = [:__struct__, :__meta__]

    Enum.reduce(Map.drop(record, schema_keys), %{}, fn {k, v}, acc ->
      cond do
        Ecto.assoc_loaded?(v) && is_list(v) && List.first(v) && is_map(List.first(v)) &&
            Enum.all?(schema_keys, &Map.has_key?(List.first(v), &1)) ->
          values =
            Enum.reduce(v, [], fn rec, acc ->
              acc ++ [sanitize_map(rec)]
            end)

          Map.put(acc, k, values)

        Ecto.assoc_loaded?(v) ->
          Map.put(
            acc,
            k,
            if(
              is_map(v) && Enum.all?(schema_keys, &Map.has_key?(v, &1)),
              do: sanitize_map(v),
              else: v
            )
          )

        true ->
          acc
      end
    end)
  end
end
