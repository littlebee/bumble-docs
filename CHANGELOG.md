## [0.8.0](https://github.com/littlebee/bumble-docs.git/compare/0.7.0...0.8.0) (2018-04-11)
Support for React versions < 16.0 has been deprecated.  Please use version 0.7.x  for React 14 support.

### Other Commits
* [abcb2ed](https://github.com/littlebee/bumble-docs.git/commit/abcb2edaac9fca728cac48c80cb136447728c268) bumble docs works on react 16

## [0.7.0](https://github.com/littlebee/bumble-docs.git/compare/0.6.1...0.7.0) (2018-04-5)
Breaking change:   you will need to copy your own vendor libs into your docs/vendor  directory at build time.

### Other Commits
* [1b3b49e](https://github.com/littlebee/bumble-docs.git/commit/1b3b49ec5c54726f47738ab26b319f7bcbe24666) stop shipping static vendor libs with source

## [0.6.1](https://github.com/littlebee/bumble-docs.git/compare/0.6.0...0.6.1) (2018-04-5)


### Other Commits
* [df361de](https://github.com/littlebee/bumble-docs.git/commit/df361de2cde5c5c7c9e151cba256055e19676949) add babel-plugin-transform-class-properties when building ES6 examples

## [0.6.0](https://github.com/littlebee/bumble-docs.git/compare/0.5.5...0.6.0) (2018-04-5)


### Other Commits
* [34609b1](https://github.com/littlebee/bumble-docs.git/commit/34609b1369a85417be96b3a3e560081e7f30ca31) Doc generation works on React 16

## [0.5.5](https://github.com/littlebee/bumble-docs.git/compare/0.5.4...0.5.5) (2018-04-4)


### Other Commits
* [fac49d0](https://github.com/littlebee/bumble-docs.git/commit/fac49d0c84263d64520798112e708b98b5b91d08) upgrade babel presets to latest

## [0.5.4](https://github.com/littlebee/bumble-docs.git/compare/0.5.3...0.5.4) (2018-04-4)


### Other Commits
* [df801a9](https://github.com/littlebee/bumble-docs.git/commit/df801a97bedfd41105556b0759591c2a4845d89c) update coffee-react to 5.0.1 to support react 16

## [0.5.3](https://github.com/littlebee/bumble-docs.git/compare/0.5.2...0.5.3) (2017-02-20)


### Other Commits
* [a3b35bb](https://github.com/littlebee/bumble-docs.git/commit/a3b35bb1f361062e747ffdde186dcb45de53289c) add support for ignoring coffee-coverage pragma comments

## [0.5.2](https://github.com/littlebee/bumble-docs.git/compare/0.5.1...0.5.2) (2017-02-18)


### Other Commits
* [953e6ad](https://github.com/littlebee/bumble-docs.git/commit/953e6ad7da431657a4b071bc672395657f5c9cda) limit docs gen to coffee and cjsx files

## [0.5.1](https://github.com/littlebee/bumble-docs.git/compare/0.5.0...0.5.1) (2016-11-327)


### Bugs Fixed in this Release
* [431d1f8](https://github.com/littlebee/bumble-docs.git/commit/431d1f847f5e2c0de6143807aa577581f56e9e2c)  method matcher should tolerate lack of () in function definition and ignore blank lines

## [0.5.0](https://github.com/littlebee/bumble-docs.git/compare/0.4.6...0.5.0) (2016-11-326)


### Other Commits
* [20aa65a](https://github.com/littlebee/bumble-docs.git/commit/20aa65a65acddfdc24927aec7ab8f65e5f562113) always show propTypes and default props in docs and toc

## [0.4.6](https://github.com/littlebee/bumble-docs.git/compare/0.4.5...0.4.6) (2016-04-109)


### Bugs Fixed in this Release
* [23c7dc6](https://github.com/littlebee/bumble-docs.git/commit/23c7dc61438f5908a934cd4f33edd2333eec2b89)  add guard against mismatch in docContent links generator

### Other Commits
* [495d658](https://github.com/littlebee/bumble-docs.git/commit/495d65847e8f00902fb5ecd9b4c824020fd0de59) add a sample bumbleDocs.coffee file

## [0.4.5](https://github.com/littlebee/bumble-docs.git/compare/0.4.4...0.4.5) (2016-03-66)


### Other Commits
* [0421c37](https://github.com/littlebee/bumble-docs.git/commit/0421c37c8318dc6a38dd80a34add30c24d617e40) skip all docs generation unless ./bumbleDocs.(js|coffee) exists in user app root

## [0.4.4](https://github.com/littlebee/bumble-docs.git/compare/0.0.0...0.4.4) (2016-02-54)


### Other Commits
* [c55db07](https://github.com/littlebee/bumble-docs.git/commit/c55db07b1b0866bd04db74f6bec86a12113e393c) make docs gen work for tilegrid dependency loop.
