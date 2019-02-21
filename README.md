# Nubank API (nubank_api)

**Work in progress**

It's an Elixir library that abstract the HTTP request into functions.

The goal is to facilitate the developers job to integrate with Nubank's API.

This project was inspired by the repo
[https://github.com/Astrocoders/nubank-api](https://github.com/Astrocoders/nubank-api), thanks for
[Astrocoders](https://github.com/Astrocoders) for the work in figure out Nubank's API endpoints/payloads etc.

## Installation

[Available in Hex](https://hex.pm/packages/nubank_api), the package can be installed
by adding `:nubank_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nubank_api, "~> 1.0.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/nubank_api](https://hexdocs.pm/nubank_api).

## Contribution

### Setup

To setup the project, is needed to have Elixir 1.7 or higher installed and run the the command:

```bash
$ mix deps.get
```

### QA

In order to keep the quality of the project is important to create tests, format the code
and make sure the code style is following the Elixir linter rules.

To run the tests:

```bash
$ mix test
```

To the code formater:

```bash
$ mix format
```

To run the linter:

```bash
$ mix credo --strict
```
