# AtmApp
## Api for CRUD Users and ther account balance.
This project is an api that is used to query users and update their account balance.

## Starting

For this project the following technologies were used:
 * Elixir 1.13.4 (Compiled with Erlang/OTP 22)
 * Phoenix 1.6.10
 
To learn more about how to install Elixir - Phoenix, consult the following guide: [Getting Started Elixir](https://elixir-lang.org/getting-started/introduction.html) - [Installation Phoenix](https://hexdocs.pm/phoenix/installation.html)

A postgreSQL database was used.

## How to use:

To obtain a list of users we must make a request of the GET type like this:
```http

GET /api/index HTTP/1.1
Host: localhost:4000

```
We expect an answer like this:

```json
{
 "users": [
  {
   "balance": 40.0,
   "id": 2,
   "inserted_at": "2023-02-12T17:01:06",
   "nick_name": "user_test",
   "updated_at": "2023-02-12T17:01:06"
   },
   {
   "balance": 1010000002.0,
   "id": 1,
   "inserted_at": "2023-02-12T17:00:41",
   "nick_name": "elcentaurx",
   "updated_at": "2023-02-12T23:35:44"
   }
 ]
}
```


The response could be an empty list if there are no users inside the database like this:
```json
{
 "users": []
}
```

To create a user it is necessary to send a message with the "user_atm" object, the "nick_name" parameter is necessary to create the user while "balance" will be 0 by default if omitted in the message, like this:

```http
POST /api/create HTTP/1.1
Content-Type: application/json
Host: localhost:4000
Content-Length: 65

{
 "user_atm": {
  "nick_name": "user_test",
  "balance": 40
  }
}
```

If the user was created correctly you will receive a response like this:
```json
{
 "ok": "user user_test created successfully"
}
```
If there was an error in the creation of the user you will receive an "error" response, like this:
```json
{
 "error": "[nick_name: {\"has already been taken\", [constraint: :unique, constraint_name: \"user_atm_nick_name_index\"]}]"
}
```

We can also withdraw and deposit funds from the user's account, for which we will use the endpoint:
```http
PUT /api/update HTTP/1.1
Content-Type: application/json
Host: localhost:4000
Content-Length: 66

{
 "id": 1,
 "user_atm": {
 "amount": 10.0
 },
 "type": true
}
```

We must send a json where the "id" of the user that we obtained in the list of users is specified, send a "user_atm" object with the "amount" to deposit/withdraw, the amount to deposit or withdraw will be taken without sign, for so you don't need to add it. The "type" parameter indicates the operation to perform, if true, funds will be withdrawn, otherwise funds will be deposited.

If it is possible to carry out the funds withdrawal operation, you will get a response like this:

```json
{
"ok": "you successfully withdrew $10 from your account"
}
```
Otherwise
```json
{
 "error": "insufficient balance"
}
```

if you deposit money in an account you will get a response like this:
```json
{
"ok": "you deposited $10 to your account"
}
```

We can also obtain the balance with the available funds, like this:

```http
GET /api/founds/1 HTTP/1.1
Content-Type: application/json
Host: localhost:4000
```

If we send the user id within the url correctly we will obtain the account balance like this:
```json
{
"balance": 12.0
}
```

This project is temporarily hosted on fly.io: [https://atmapi.fly.dev/](https://atmapi.fly.dev/)

To learn more about how to deploy a project on fly.io: [Getting Started Fly.io](https://fly.io/docs/elixir/getting-started/)

To see the files added in the deployment review: [Deploy](https://github.com/elcentaurx/atm/tree/deploy)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
