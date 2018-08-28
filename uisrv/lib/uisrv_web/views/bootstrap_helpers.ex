defmodule UisrvWeb.BootstrapHelpers do
  use UisrvWeb, :view
  import Phoenix.Controller, only: [get_flash: 1]

  def show_flash(conn) do
    get_flash(conn) |> flash_msg
  end

  def show_flash_dismiss(conn) do
    get_flash(conn) |> flash_msg_dismiss
  end

  defp flash_msg_dismiss(%{"info" => msg}) do
    ~E"""
    <div class='alert alert-info alert-dismissible fade show' role='alert'>
    <%= msg %>
    <button type='button' class='close' data-dismiss='alert' aria-label='Close'>
      <span aria-hidden='true'>&times;</span>
    </button>
    </div>
    """
  end

  defp flash_msg_dismiss(%{"error" => msg}) do
    ~E"""
    <div class='alert alert-danger alert-dismissible fade show' role='alert'>
    <%= msg %>
    <button type='button' class='close' data-dismiss='alert' aria-label='Close'>
      <span aria-hidden='true'>&times;</span>
    </button>
    </div>
    """
  end

  defp flash_msg_dismiss(_) do
    nil
  end

  defp flash_msg(%{"info" => msg}) do
    ~E"<div class='alert alert-info' role='alert'  ><%= msg %></div>"
  end

  defp flash_msg(%{"error" => msg}) do
    ~E"<div class='alert alert-danger' role='alert'><%= msg %></div>"
  end

  defp flash_msg(_) do
    nil
  end
end
