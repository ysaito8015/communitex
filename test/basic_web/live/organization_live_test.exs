defmodule BasicWeb.OrganizationLiveTest do
  use BasicWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Basic.Organizations

  @create_attrs %{address1: "some address1", address2: "some address2", city: "some city", deleted_at: ~N[2010-04-17 14:00:00], name: "some name", postal: "some postal", prefecture: "some prefecture", tel: "some tel"}
  @update_attrs %{address1: "some updated address1", address2: "some updated address2", city: "some updated city", deleted_at: ~N[2011-05-18 15:01:01], name: "some updated name", postal: "some updated postal", prefecture: "some updated prefecture", tel: "some updated tel"}
  @invalid_attrs %{address1: nil, address2: nil, city: nil, deleted_at: nil, name: nil, postal: nil, prefecture: nil, tel: nil}

  defp fixture(:organization) do
    {:ok, organization} = Organizations.create_organization(@create_attrs)
    organization
  end

  defp create_organization(_) do
    organization = fixture(:organization)
    %{organization: organization}
  end

  describe "Index" do
    setup [:create_organization]

    test "lists all organizations", %{conn: conn, organization: organization} do
      {:ok, _index_live, html} = live(conn, Routes.organization_index_path(conn, :index))

      assert html =~ "Listing Organizations"
      assert html =~ organization.address1
    end

    test "saves new organization", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.organization_index_path(conn, :index))

      assert index_live |> element("a", "New Organization") |> render_click() =~
               "New Organization"

      assert_patch(index_live, Routes.organization_index_path(conn, :new))

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organization-form", organization: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.organization_index_path(conn, :index))

      assert html =~ "Organization created successfully"
      assert html =~ "some address1"
    end

    test "updates organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, Routes.organization_index_path(conn, :index))

      assert index_live |> element("#organization-#{organization.id} a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(index_live, Routes.organization_index_path(conn, :edit, organization))

      assert index_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#organization-form", organization: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.organization_index_path(conn, :index))

      assert html =~ "Organization updated successfully"
      assert html =~ "some updated address1"
    end

    test "deletes organization in listing", %{conn: conn, organization: organization} do
      {:ok, index_live, _html} = live(conn, Routes.organization_index_path(conn, :index))

      assert index_live |> element("#organization-#{organization.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#organization-#{organization.id}")
    end
  end

  describe "Show" do
    setup [:create_organization]

    test "displays organization", %{conn: conn, organization: organization} do
      {:ok, _show_live, html} = live(conn, Routes.organization_show_path(conn, :show, organization))

      assert html =~ "Show Organization"
      assert html =~ organization.address1
    end

    test "updates organization within modal", %{conn: conn, organization: organization} do
      {:ok, show_live, _html} = live(conn, Routes.organization_show_path(conn, :show, organization))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Organization"

      assert_patch(show_live, Routes.organization_show_path(conn, :edit, organization))

      assert show_live
             |> form("#organization-form", organization: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#organization-form", organization: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.organization_show_path(conn, :show, organization))

      assert html =~ "Organization updated successfully"
      assert html =~ "some updated address1"
    end
  end
end
