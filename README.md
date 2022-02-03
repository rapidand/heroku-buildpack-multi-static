# Heroku Multi static.json buildpack

_tl;dr_ -- The idea here is that you have a single git repository, but multiple Heroku apps. In other words, you want to share a single git repository to power multiple Heroku apps. So, for each app you need this buildpack, and for each app, you need to set a config variable named STATIC to the location where the procfile is for that app. As an example:

```
$ heroku create -a example-1
$ heroku create -a example-2
$ heroku buildpacks:add -a example-1 https://github.com/rapidand/heroku-buildpack-multi-static
$ heroku buildpacks:add -a example-2 https://github.com/rapidand/heroku-buildpack-multi-static
$ heroku config:set -a example-1 STATIC=static.json
$ heroku config:set -a example-2 STATIC=backend/static.json
$ git push https://git.heroku.com/example-1.git HEAD:master
$ git push https://git.heroku.com/example-2.git HEAD:master
```

When example-1 builds, it'll copy static.json into /app/static.json, and when example-2 builds, it'll copy backend/static.json to /app/static.json. For example-2, the process types available for you to scale up will be the ones referenced (originally) in backend/static.json.

## Pipelines

Only **builds** will set the proper static.json. If you use [Heroku Pipelines](https://devcenter.heroku.com/articles/pipelines), then promoting a slug downstream will not trigger a build, and therefore will not look at the environment variable and act accordingly. Make sure that the proper static.json is referenced all the way upstream to the first stage that builds.

## Authors

Andrew Gwozdziewycz <apg@heroku.com> and Cyril David <cyx@heroku.com>
