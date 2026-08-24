# Z3 Validation Lane

This directory contains bounded countermodel checks for the canonical Master
Equation derivation. Version 1 tests the normalized product kernel, the Cornell
correction, and the repaired two-operator salvation architecture.

## Reproduce

```powershell
python -m venv .venv-z3
& .\.venv-z3\Scripts\python.exe -m pip install -r .\Z3_VALIDATION\requirements.txt
& .\.venv-z3\Scripts\python.exe .\Z3_VALIDATION\master_equation_kernel.py
```

The script exits with code 0 only when every expected SAT/UNSAT result matches.
It writes a new JSON receipt into `Z3_VALIDATION/receipts`.

An UNSAT counterexample query means no counterexample exists in the encoded
model under the assumptions stated in the test. Open analytic, empirical, and
bridge claims are listed separately in `OBLIGATION_LEDGER.md`.
