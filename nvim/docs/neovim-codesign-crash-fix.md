# Neovim Crash Fix: macOS Code Signature Invalid

## Root Cause

macOS kills Neovim due to invalid code signatures on native libraries (`.so` and `.dylib` files) when they are loaded dynamically.

### Proof from Crash Report

Location: `~/Library/Logs/DiagnosticReports/nvim-*.ips`

**Exception type (line 47):**
```json
"exception" : {"type":"EXC_BAD_ACCESS","signal":"SIGKILL (Code Signature Invalid)"}
```

**Termination reason (line 48):**
```json
"termination" : {"namespace":"CODESIGNING","indicator":"Invalid Page"}
```

**Stack trace showing the failure point:**
```
uv_dlopen -> add_language (treesitter parser loading)
```

## Solution

Re-sign all native libraries with an ad-hoc signature:

```bash
# Re-sign treesitter parsers
for f in ~/.local/share/nvim/site/parser/*.so; do
  codesign --force --sign - "$f"
done

# Re-sign blink.cmp fuzzy library (if using blink.cmp)
codesign --force --sign - ~/.local/share/nvim/lazy/blink.cmp/target/release/libblink_cmp_fuzzy.dylib
```

## Actions If Problem Resurfaces

1. **Check crash reports:**
   ```bash
   ls -lat ~/Library/Logs/DiagnosticReports/ | grep nvim | head -5
   ```

2. **Confirm it's a code signing issue** by reading the latest crash report and looking for:
   - `"signal":"SIGKILL (Code Signature Invalid)"`
   - `"namespace":"CODESIGNING"`

3. **Find and re-sign all native libraries:**
   ```bash
   # Find all .so files
   find ~/.local/share/nvim -name "*.so" -type f

   # Find all .dylib files
   find ~/.local/share/nvim -name "*.dylib" -type f

   # Re-sign them
   find ~/.local/share/nvim -name "*.so" -type f -exec codesign --force --sign - {} \;
   find ~/.local/share/nvim -name "*.dylib" -type f -exec codesign --force --sign - {} \;
   ```

4. **Common triggers** that may require re-signing:
   - Updating treesitter parsers (`:TSUpdate`)
   - Updating plugins with native components (blink.cmp, etc.)
   - Fresh plugin installations
