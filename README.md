# idris2-http-async

This is a work-in-progress fork of
[idris2-http](https://github.com/idris-community/idris2-http) exploring an
asynchronous public API, among other improvements. It may or may not eventually
be merged with, or replace, idris2-http.

# Goals
Currently, the goals of this library are:
- Implement using communiy-standard libraries
- Improved performance and safety
- Move parts of this library that can stand alone to subprojects, and perhaps
  later separate repos

# TODO
- [ ] Replace bundled `Utils.Streaming` with `idris2-swirl`
- [ ] Replace manually-coordinated blocking parallel code with `idris2-async`
- [ ] Replace all instances of `List Bits8` with `idris2-bytestring`
- [x] Refactor `Data.Compress` to a separate package
- [ ] Refactor data declarations in `Network.HTTP` to `Data.HTTP`, in a separate
      package

# Contributions
The purpose of development in a
separate repository is to move fast and break things™ in a repository no one
(ideally) is using, while idris2-http is still under maintenance for
compatibility and bugfixes. As such, this gives us an opportunity to be as
breaking as we want with changes, for as minor of a reason as we want, since if
this is merged into idris2-http it will be all at once. As such the following
(and more!) contributions will be accepted:

- Anything that improves the public API
- Changes to better adhere to the [Idris2 Style
  Guide](https://github.com/stefan-hoeck/idris2-style-guide).
- Changes to use camelCase instead of snake_case
- Changes to make proof-related types more useful

Please be aware, that contributions may be rebased into an existing commit to
better present a nice log for eventual merging/cherry-picking. Master will be
force-pushed to. Here be dragons.
