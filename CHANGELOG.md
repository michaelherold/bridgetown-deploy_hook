# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0](https://github.com/michaelherold/bridgetown-deploy_hook/tree/v0.1.0) - 2023-03-11

### Added

- The ability to specify authorizers for any HTTP Authorization schemes, whether current or future, through the initializer. These can be anything responding to `#call` with a nilable string argument with a truthy value for success and a falsey one for failure.
- The ability the set the route for the deploy hook.
