defmodule BasicWeb.ModalComponent do
  use BasicWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="phx-modal-content">
        <%= live_patch raw("&times;"), to: @return_to, class: "phx-modal-close" %>
        <%
        opts = case Keyword.fetch!(@opts, :action) do
          :new -> @opts |> Keyword.replace!(:return_to, Keyword.fetch!(@opts, :return_to) |> String.replace(~r/\?.*/, ""))
          _    -> @opts
        end
        %>
        <%= live_component @socket, @component, opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
