# AuditKazoo

This repo's main goal is to enable developers to run some integration tests for [kazoo](https://github.com/2600hz/kazoo) and its family applications.

If you want to write tests for the [monster-UI](https://github.com/2600hz/monster-ui), take a look at the [wallaby](https://github.com/elixir-wallaby/wallaby) documentation, it shows what you can do with the library.

This repo also provides a client consumer for Kazoo's API.

We might use Google Chrome, Mozilla Firefox, or selenium to run the browser tests. By default, we are using google chrome
which requires the [ChromeDriver](https://chromedriver.chromium.org/downloads) installation with the same version of your local browser.

Make sure sup module is running in the Kazoo API
`crossbar_maintenance:start_module(cb_sup).`
