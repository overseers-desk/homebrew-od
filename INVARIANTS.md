# Invariants

Rules whose breach is a design change, not a fix; changing one is the owner's decision.

- This tap holds no source code and cuts no releases of its own: each tool's own repository is the release authority and a formula pulls that repository's (or PyPI's) release tarball, so a tool release here is exactly one edit, the `url` and `sha256` in `Formula/<tool>.rb`. Source or release machinery kept here would make the tap a second authority that drifts from the first.
