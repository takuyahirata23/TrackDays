# Trackdays

This is a web page for `Trackdays`, an app for administrators to manage data such, and a GraphQL server for `Trackdays` mobile application.

To install Elixir and Erlang:
I recommend [`asdf`](https://asdf-vm.com/)

To start your Phoenix server:

- Create up `.envrc` with:
  | name | value |
  |-----------------|--------------------------------|
  |TOKEN_SECRET_KEY | random string for token secret |
  |DOMAIN_URL | your ip address |

- Run `docker compose -d` to create a container for PostgreSQL (only first time to run the app)
- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser or [`GraphiQL Workspace`](http://localhost:4000/graphiql)

To run GraphQL queries and mutations:

- Authenticate using REST API to fetch a token (all routes are in `router.ex`)
- Use the token in the header

To visit the admin pages:

- Flip `is_admin` flag on a user (There is no endpoints and functionality to do that meaning you need to do this manualy. I use `tablePlus`)
