# Review Integration Specification

## Purpose

This specification covers this repository's review callers.
The [upstream caller contract][caller-contract] defines Seer behavior.
The requirements below describe local configuration only.

## Requirements

### Requirement: Forward the correctness check name

The cascade caller MUST pass `MACROSCOPE_CORRECTNESS_CHECK` to Seer through the `macroscope_correctness_check` input.

#### Scenario: Cascade invocation

- **WHEN** the cascade caller invokes Seer
- **THEN** `macroscope_correctness_check` equals the repository variable `MACROSCOPE_CORRECTNESS_CHECK`

### Requirement: Preserve active rounds during label consumption

The cascade caller MUST cancel an active round only for a new `review` label event on the same pull request.

#### Scenario: Consumed request

- **WHEN** an `unlabeled` event removes `review` during an active cascade
- **THEN** the caller preserves the active round

#### Scenario: New request

- **WHEN** a `labeled` event applies `review` during an active cascade on the same pull request
- **THEN** the caller requests that GitHub cancel the active round

### Requirement: Dispatch optional Bugbot reviews separately

The optional Bugbot caller MUST invoke Seer's `review-cursor.yaml` separately from the cascade.
The caller MUST require a non-draft pull request with `review:cursor` and without `skip:cursor`.
It MUST accept a matching label event or a transition from draft to ready.

#### Scenario: Optional review request

- **WHEN** a maintainer applies `review:cursor` to a non-draft pull request without `skip:cursor`
- **THEN** the optional caller invokes Seer's `review-cursor.yaml`

#### Scenario: Pending draft request

- **WHEN** a draft pull request with `review:cursor` and without `skip:cursor` becomes ready
- **THEN** the optional caller invokes Seer's `review-cursor.yaml`

#### Scenario: Draft or skipped review

- **WHEN** the pull request remains draft or carries `skip:cursor`
- **THEN** the optional caller starts no Bugbot job

### Requirement: Preserve inherited CodeRabbit settings

The CodeRabbit configuration MUST enable `inheritance` and set `reviews.review_status` to `false`.

#### Scenario: Configuration inspection

- **WHEN** CodeRabbit reads `.coderabbit.yaml`
- **THEN** `inheritance` equals `true` and `reviews.review_status` equals `false`

[caller-contract]: https://github.com/runedeck/seer/blob/11f5eb5edfc1d20f32591e01bcc9cc1587c336c9/INSTALL.md
