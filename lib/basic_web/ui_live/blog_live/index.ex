defmodule BasicWeb.BlogUiLive.Index do
  use BasicWeb, :live_view

  alias Basic.Blogs
  alias Basic.Blogs.Blog
  alias Basic.Accounts

  @impl true
  def mount(params, session, socket) do
    current_user_id = case session["user_token"] do
      nil -> ""
      token -> Accounts.get_user_by_session_token(token).id
    end
    {:ok,
      socket
      |> assign(:blogs, list_blogs)
      |> assign(:params, params)
      |> assign(:current_user_id, current_user_id)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"post_id" => post_id}) do
    socket
    |> assign(:page_title, "Edit Blog")
    |> assign(:blog, Blogs.get_blog_by_post_id!(post_id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Blog")
    |> assign(:blog, %Blog{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Blogs")
    |> assign(:blog, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    blog = Blogs.get_blog!(id)
    {:ok, _} = Blogs.delete_blog(blog)

    {:noreply, assign(socket, :blogs, list_blogs())}
  end

  defp list_blogs do
    Blogs.list_blogs()
  end
end
