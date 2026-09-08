# Commit Attribution Specification

## Purpose

The authorship check validates declared commit attribution under trusted repository policy.
It does not prove which model executed the work.

## Requirements

### Requirement: Future Model Identities

The check MUST accept exact `authors:` entries and formatted model identities under trusted harness domains.
A formatted identity MUST use `Display Name (model-id) <model-id@domain>`.
The display and address IDs MUST match after context normalization.
A model ID MUST contain lowercase ASCII alphanumeric segments separated by dots or hyphens.
The domain MUST match an approved `<harness>.noreply.nexus.local` entry exactly.
New model versions under approved domains MUST require no catalog update.
Human identities and vendor aliases MUST remain exact policy entries.
Identity resolution MUST prefer an exact model ID within the selected harness before canonical aliases.
It MUST remove a trailing `[1m]` annotation before this comparison.
Matches across multiple harnesses MUST require an explicit harness.
Multiple exact matches within one harness MUST fail as ambiguous.

#### Scenario: Future version

- **WHEN** an unlisted Fable 5.2 or Astra identity has matching IDs under an approved harness domain
- **THEN** the check accepts the identity

#### Scenario: Mismatch or domain spoofing

- **WHEN** the model IDs differ or the domain adds a suffix to an approved domain
- **THEN** the check rejects the identity

#### Scenario: Current and legacy model IDs coexist

- **WHEN** the policy lists both `claude-fable-5` and `claude-fable-51m` for the selected harness
- **THEN** each ID resolves to its exact author entry

#### Scenario: Duplicate exact identity

- **WHEN** two author entries have the same model ID and harness
- **THEN** identity resolution rejects the ambiguity

### Requirement: Trusted Domain Policy

The check MUST read `model_domains:` from trusted `authors.yaml`.
When the list is absent, the check MUST infer domains from valid model entries in trusted `authors:`.
An explicit list MUST replace inference, including `model_domains: []`.
Trailer-only entries MUST NOT grant model domains.
The check MUST reject malformed policy before it examines the commit range.

#### Scenario: Legacy policy

- **WHEN** trusted policy lists model authors and omits `model_domains:`
- **THEN** the check accepts future model IDs under those author domains

#### Scenario: Explicit empty list

- **WHEN** trusted policy declares `model_domains: []`
- **THEN** the check accepts only exact author entries

#### Scenario: Trailer-only domain

- **WHEN** a domain appears only in a trailer entry
- **THEN** the check rejects an unlisted author under that domain

### Requirement: Trusted Execution and Commit Range

CI MUST execute the checker and helper from the exact pull request base checkout.
CI MUST use the policy from that same checkout.
CI MUST inspect every commit from the merge base to the pull request head, including merge commits.
Local pre-push checks MUST use the same checker with `origin/main:authors.yaml`.
For an orphan branch, they MUST inspect every commit reachable from the supplied head.
Target selection MUST prefer `--to-ref`, `PRE_COMMIT_TO_REF`, `GITLEAKS_PUSH_TO_REF`, then `HEAD`.
The check MUST fail when policy, commit references, or history reads fail.
Head changes MUST NOT authorize their own identities or replace CI checker code.
Authorship source and policy changes MUST receive the existing specification-presence check.

#### Scenario: Head policy change

- **WHEN** a head adds its own unapproved domain or changes the checker
- **THEN** CI uses base code and base policy to evaluate that head

#### Scenario: Local outgoing range

- **WHEN** a push contains an invalid author in any outgoing commit
- **THEN** the pre-push check rejects the range and names the commit

#### Scenario: Outgoing orphan differs from the working copy

- **WHEN** the hook supplies an orphan through `GITLEAKS_PUSH_TO_REF` while `HEAD` remains on the default branch
- **THEN** the check validates the complete outgoing history against trusted policy

#### Scenario: Explicit target overrides the environment

- **WHEN** the caller supplies `--to-ref` and an environment target
- **THEN** the check validates the explicit target

### Requirement: Contributor Identity

The check MUST accept exact `trailers:` entries only as contributors.
It MUST reject an author repeated as a contributor by normalized model ID and harness domain.
Normalization MUST remove an explicit trailing `[1m]` annotation.
It MUST map `claude-fable-51m` and `claude-opus-51m` to their respective version 5 IDs.
Other IDs ending in `1m` MUST retain their identity.

#### Scenario: Trailer alias used as author

- **WHEN** a commit uses an exact trailer-only alias as its author
- **THEN** the check rejects the commit

#### Scenario: Author repeated through an alias

- **WHEN** the contributor differs only by display name or a recognized context annotation
- **THEN** the check rejects the repeated author
