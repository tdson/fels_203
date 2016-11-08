# fels_203
Framgia DN Edu - Training Project

## License

All source code in this blog is available jointly under the MIT License
and the Beerware License. See [LICENSE.md](LICENSE.md) for details.

## See demo here
https://e-learning-sontd.herokuapp.com

## Getting started

To get started with the app, after clone the repo:

First, you need to copy `database.example.yml` and rename it:

```
mv /config/database.example.yml /config/database.yml
```

Then, the application need gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Then, run the server

```
$ rails server
```

We’ll be resizing images using the image manipulation program ImageMagick,
which we need to install on the development environment.

```
$ sudo apt-get update
$ sudo apt-get install imagemagick --fix-missing
```
