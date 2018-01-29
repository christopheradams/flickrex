ExUnit.configure(exclude: [:flickr_api])

Application.ensure_all_started(:hackney)

ExUnit.start()
