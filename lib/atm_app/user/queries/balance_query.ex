defmodule AtmApp.User.Queries.BalanceQuery do
  import Ecto.Query, warn: false
  alias AtmApp.User.UserAtm

  def get_balance(id) do
    from gb in UserAtm,
    where: gb.id == ^id,
    select: gb.balance
  end

end
