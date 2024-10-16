defmodule SpliceTrackerWeb.FiberLive do
  use SpliceTrackerWeb, :live_view
  alias SpliceTracker.Repo
  alias SpliceTracker.Customers
  import Ecto.Query

  def mount(params, _session, socket) do
    changeset = SpliceTracker.Fibers.changeset(%SpliceTracker.Fibers{})
    socket = assign(socket,
      changeset: changeset,
      form: to_form(changeset),
      boxid: Map.get(params, "boxid"),
      customers: [],
      connection_value: nil
      )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <p><%= @boxid %> </p>
      <.simple_form
        for={@form}
        id="fiber-box"
        phx-submit="save"

      >
      <.input field={@form[:boxid]} type="text" value={@boxid} />
      <.input field={@form[:color]} type="select" options={["blue","red"]}label="Color" />
      <.input
        field={@form[:connection]}
        type="text"
        label="Connection"
        phx-debounce="300"
        value={@connection_value}
        phx-change="customer_search"
        />
    <div>
    <ul>
      <%= for customer <- @customers do %>
        <li phx-click="select_customer"
        <li :if={@clear} phx-click="select_customer" phx-value-address={customer.customer_address}>
            <%= customer.customer_address %>
        </li>
      <% end %>
    </ul>

    </div>
      <:actions>
        <.button phx-disable-with="Saving...">Save</.button>
      </:actions>
    </.simple_form>

    """
  end

  def handle_event("save", %{"fibers" => fiber_params}, socket) do
    IO.inspect(fiber_params)
    # Create a changeset from the params
    changeset = SpliceTracker.Fibers.changeset(%SpliceTracker.Fibers{}, fiber_params)

    # if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, _fiber} ->
          {:noreply,
            socket
            |> put_flash(:info, "Fiber inserted successfully")}

        {:error, changeset} ->
          put_flash(socket, :error, changeset)
          {:noreply, assign(socket, changeset: changeset)}
      end
    # else
    #   # If changeset is invalid, re-render form with error messages
    #   {:noreply, assign(socket, changeset: changeset)}
    # end
  end

  def handle_event("customer_search",%{"fibers" => %{"connection" => address}}, socket) do

    case address do
      "" ->
        {:noreply, assign(socket, customers: [])}
      _ ->
        customers = search_customers(address)
        {:noreply, assign(socket, customers: customers, clear: true)}
    end

  end

  def handle_event("select_customer", %{"address" => address}, socket) do

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_change(:connection, address)
    {:noreply, assign(socket, changeset: changeset, connection_value: address, clear: false)}
  end

  defp search_customers(query) do
    customers = from(c in Customers, where: like(c.customer_address,^"%#{query}%"))
    Repo.all(customers, limit: 10)
  end
end
