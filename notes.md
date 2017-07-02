Leaderboard app
===
* SPA routing
  * hashToPage: other direction is pattern match on Page, i.e. compiler helps you. This is just pattern matching on string i.e. easy to forget?
  * **240** lines of wiring in Main.elm (hierarchical init, model, view, update, subscriptions)
  * Login module handles authentication, but every other module needs it. *Shared state should go at lowest possible ancestor* (Main.elm). This feels a bit unnatural to me (Main.Model contains loggedIn, token fields)
  * Login module needs the Navigation module to navigate to another page on login. Perhaps message to parent to keep this component dumb?
  * Sending some JSON over HTTP takes quite a few lines of code (mostly encoding/decoding Elm-JSON)
