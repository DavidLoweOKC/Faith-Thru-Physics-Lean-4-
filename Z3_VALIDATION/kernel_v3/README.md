# Z3 Kernel v3

This package checks seven measurement and wrapper obligations. It produces a
machine-readable receipt and exits nonzero if an actual SAT/UNSAT result differs
from its declared expectation.

From the repository root:

```powershell
py -m pip install -r Z3_VALIDATION/requirements.txt
py Z3_VALIDATION/kernel_v3/kernel_v3.py
```

Or run `RUN_V3.ps1` / `RUN_V3.bat`. The runners prefer a repository-local
`.venv-z3` and otherwise use the available Python launcher.
