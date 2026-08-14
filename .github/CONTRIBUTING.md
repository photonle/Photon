# Contributor Guidelines

These guidelines have been written to ensure that code, issues and pull requests are to a good standard;
allowing for easier maintence and implementation.

## General

We're not looking for new components or sirens, unless there's an overwhelming reason to add them (such as being an example of a new feature).

## Code

### Style

Code should follow the style outlined in [Limelight Standards Document #1](https://github.com/limelight-development/standards/blob/master/lsd-1/readme.adoc).

### License

Contributors agree to their code being published under the Creative Commons Non-Commercial Attribution license and the Steam Workshop T&C.

## Pull Requests

- Pull requests should be titled meaningfully.
- PRs should focus on one main feature or change each.
- PRs should target development branch, not master.

### Titles

PR titles follow [Conventional Commits](https://www.conventionalcommits.org/), because
release notes and the changelog are generated from them:

```
feat(library): add Whelen Dominator siren models
fix: don't crash when a component is missing
```

Use `feat` for additions, `fix` for bug fixes, `perf` for optimisations and
`refactor` for internal changes. `docs`, `chore`, `style`, `test`, `build` and `ci`
are valid but are hidden from release notes. A title that doesn't follow this
format is left out of the changelog entirely.

## Issues

- Issues should have meaningful titles.
- Each issue should focus on one feature or issue.
- Issues should be appropriately labelled (feature / enhancement / bug / library)
