# Security Policy

## Supported versions

Only the `main` branch receives fixes.

## Reporting a vulnerability

Please do not open a public issue for a security problem. Email
muhittincamdali@gmail.com with a description, the affected code and steps to reproduce.

The package stores widget state and cached data in `UserDefaults` (usually an App Group
suite). That storage is not encrypted, so do not put credentials or other secrets in
`WidgetSnapshotStore` or `WidgetStateStore`.
