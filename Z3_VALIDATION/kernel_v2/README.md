# Z3 Kernel v2

This package checks five privative-magnitude obligations and seven
sanctification-dynamics obligations. It writes a machine-readable JSON receipt
and exits nonzero if any actual SAT/UNSAT result differs from the declared
expectation.

From the repository root:

```powershell
py -m pip install -r Z3_VALIDATION/requirements.txt
py Z3_VALIDATION/kernel_v2/kernel_v2.py
```

Or run `RUN_V2.ps1` / `RUN_V2.bat`. Both runners prefer an existing local
virtual environment but also work with the system Python launcher.
