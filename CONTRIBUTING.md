# Contributing to ArchaicOS

First off, thank you for taking the time to contribute to ArchaicOS!

This project is primarily an educational operating system built entirely from scratch in x86 NASM Assembly. The focus is on understanding how each subsystem works by implementing it manually with a clean, modular architecture.

## Before You Contribute

Please keep the following goals in mind:

* Prioritize readability over clever optimizations.
* Keep modules focused on a single responsibility.
* Prefer reusable solutions over quick fixes.
* Keep the architecture clean and consistent.
* Avoid unnecessary dependencies or generated code.

## Coding Style

* Use NASM syntax.
* Write descriptive labels and function names.
* Add comments where they improve understanding, especially for complex logic.
* Keep functions as small and focused as practical.
* Preserve a consistent coding style throughout the project.

## Commit Messages

Write clear commit messages that describe what changed.

Examples:

```text
Add keyboard ring buffer
Implement terminal backspace
Refactor VGA cursor handling
Fix page fault exception handler
```

## Pull Requests

When opening a pull request:

* Clearly describe the purpose of the change.
* Explain any architectural decisions.
* Keep changes focused on a single feature or fix whenever possible.
* Ensure the project still builds successfully.

## Bug Reports

If you discover a bug, include:

* A description of the issue.
* Steps to reproduce it.
* Expected behavior.
* Actual behavior.
* Any relevant logs, screenshots, or emulator output.

## Feature Requests

Feature requests are welcome. Please explain:

* The problem being solved.
* The proposed solution.
* Why it fits the project's goals and architecture.

## Project Philosophy

ArchaicOS is designed as a learning project. While performance and correctness are important, understanding how each subsystem works is the primary objective.

Contributions that improve clarity, maintainability, documentation, or architecture are just as valuable as new features.

Thank you for contributing to ArchaicOS!
