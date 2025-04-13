defmodule MarkmurphydevWeb.HelloHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use MarkmurphydevWeb, :html

  embed_templates "hello_html/*"
end
