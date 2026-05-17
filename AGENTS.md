# Repository Guidelines

## Project Structure & Module Organization
This repository is currently unscaffolded: no source tree, test suite, or build files are committed yet. Keep the root clean and add top-level directories as responsibilities become clear:

- `src/` for application or library code
- `tests/` for automated tests
- `assets/` for static files such as images or fixtures
- `docs/` for longer technical notes

Place root-level configuration files only when they are project-wide, for example `package.json`, `pyproject.toml`, or `Makefile`.

## Build, Test, and Development Commands
No standard build or test commands exist in the current repository state. Any PR that introduces runnable code should also introduce documented entry points. Prefer simple, discoverable commands such as:

- `make test` to run the full test suite
- `make lint` to run formatters and linters
- `make dev` to start a local development entry point

If you do not use `make`, document the equivalent native command in `README.md`, such as `pytest`, `npm test`, or `cargo test`.

## Coding Style & Naming Conventions
Match the conventions of the language you add. Use descriptive names and keep files focused on one concern.

- Python: 4-space indentation, `snake_case` for modules/functions, `PascalCase` for classes
- JavaScript/TypeScript: `camelCase` for variables/functions, `PascalCase` for components/classes
- Markdown and YAML: 2-space indentation where indentation is required

Adopt a formatter and linter with the first nontrivial code addition, and commit its config with the code it governs.

## Testing Guidelines
Add tests with every feature and bug fix. Keep tests in `tests/` or next to the code if the toolchain strongly prefers colocated tests. Use naming patterns that work with the selected framework, for example `test_parser.py` or `parser.test.ts`.

Every bug fix should include a regression test. Document any coverage gaps in the PR description.

## Commit & Pull Request Guidelines
Git history is not available in this workspace, so use a clean baseline convention: short imperative commit subjects such as `Add CSV import validator`.

PRs should include:

- a brief summary of the change
- the reason for the change
- test evidence or a note that tests are not yet available
- screenshots or sample output when UI or CLI behavior changes
