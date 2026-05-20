# PBS and API Token Key Management

## Principles
- Store backup encryption keys outside the PBS datastore.
- Rotate API tokens periodically and scope them minimally.
- Keep offline escrow copies of encryption keys.

## Minimum Controls
1. Create dedicated service accounts for backup automation.
2. Use separate tokens for backup, verification, and sync jobs.
3. Enforce expiration and quarterly rotation.
4. Store key fingerprints in a sealed inventory document.
