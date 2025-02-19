defmodule Basic.DeliveriesTest do
  use Basic.DataCase

  alias Basic.Deliveries

  describe "deliveries" do
    alias Basic.Deliveries.Delivery

    @valid_attrs %{address_id: 42, order_id: 42, phase: "some phase"}
    @update_attrs %{address_id: 43, order_id: 43, phase: "some updated phase"}
    @invalid_attrs %{address_id: nil, order_id: nil, phase: nil}

    def delivery_fixture(attrs \\ %{}) do
      {:ok, delivery} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Deliveries.create_delivery()

      delivery
    end

    test "list_deliveries/0 returns all deliveries" do
      delivery = delivery_fixture()
      assert Deliveries.list_deliveries() == [delivery]
    end

    test "get_delivery!/1 returns the delivery with given id" do
      delivery = delivery_fixture()
      assert Deliveries.get_delivery!(delivery.id) == delivery
    end

    test "create_delivery/1 with valid data creates a delivery" do
      assert {:ok, %Delivery{} = delivery} = Deliveries.create_delivery(@valid_attrs)
      assert delivery.address_id == 42
      assert delivery.order_id == 42
      assert delivery.phase == "some phase"
    end

    test "create_delivery/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deliveries.create_delivery(@invalid_attrs)
    end

    test "update_delivery/2 with valid data updates the delivery" do
      delivery = delivery_fixture()
      assert {:ok, %Delivery{} = delivery} = Deliveries.update_delivery(delivery, @update_attrs)
      assert delivery.address_id == 43
      assert delivery.order_id == 43
      assert delivery.phase == "some updated phase"
    end

    test "update_delivery/2 with invalid data returns error changeset" do
      delivery = delivery_fixture()
      assert {:error, %Ecto.Changeset{}} = Deliveries.update_delivery(delivery, @invalid_attrs)
      assert delivery == Deliveries.get_delivery!(delivery.id)
    end

    test "delete_delivery/1 deletes the delivery" do
      delivery = delivery_fixture()
      assert {:ok, %Delivery{}} = Deliveries.delete_delivery(delivery)
      assert_raise Ecto.NoResultsError, fn -> Deliveries.get_delivery!(delivery.id) end
    end

    test "change_delivery/1 returns a delivery changeset" do
      delivery = delivery_fixture()
      assert %Ecto.Changeset{} = Deliveries.change_delivery(delivery)
    end
  end
end
