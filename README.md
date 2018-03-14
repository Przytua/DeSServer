# DeS Server

This is a Demon's Souls game server written in [Swift/Vapor](https://vapor.codes). Server code is based on [ymgve's `desse`](https://github.com/ymgve/desse) - first working server after official servers shutdown.

#### Working features

* Login
* World tendency
* Messages
* Players wandering ghosts
* Bloodstains

#### Todo's

* Coop/PVP matchmaking
* Players management (banning, etc.)

## Deployment

This server is prepared for deployment on [Heroku](https://www.heroku.com), or [Dokku](https://github.com/dokku/dokku) with a [dokku-postgres](https://github.com/dokku/dokku-postgres) plugin

## Credits

* [ymgve](https://github.com/ymgve) - for reverse engineering DeS's online code, and creating first working server
