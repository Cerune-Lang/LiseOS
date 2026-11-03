//! Host-only tool. The generated OS instructions come from Cerune source.
use std::{env, error::Error, fs, path::PathBuf};

use cerune_lang::{codegen::x86_64::Target, compile_to_native_object};

fn main() -> Result<(), Box<dyn Error>> {
    let mut args = env::args_os().skip(1);
    let input = PathBuf::from(args.next().ok_or("usage: liseos-object-builder INPUT.ceru OUTPUT.o")?);
    let output = PathBuf::from(args.next().ok_or("missing output object path")?);
    if args.next().is_some() {
        return Err("unexpected additional argument".into());
    }

    let source = fs::read_to_string(&input)?;
    // Unlike the current Cerune CLI emit-obj path, this library API does not
    // insert the host-dependent call-depth diagnostic runtime.
    //
    // It is *not* a general freestanding target: reject any unresolved host
    // references later using scripts/audit_elf.py.
    let object = compile_to_native_object(&source, Target::X86_64UnknownLinuxGnu, false)
        .map_err(|e| format!("Cerune compilation failed: {e:?}"))?;
    if object.get(..4) != Some(b"\x7fELF".as_slice()) {
        return Err("Cerune did not return an ELF object".into());
    }
    if let Some(dir) = output.parent() {
        fs::create_dir_all(dir)?;
    }
    fs::write(&output, &object)?;
    println!("Cerune object: {} ({} bytes)", output.display(), object.len());
    Ok(())
}

#[cfg(test)]
mod tests {
    use cerune_lang::{codegen::x86_64::Target, compile_to_native_object};

    #[test]
    fn bare_loop_produces_elf64_object() {
        let src = "fn main() -> void { while true {} }";
        let object = compile_to_native_object(src, Target::X86_64UnknownLinuxGnu, false)
            .expect("Cerune should compile the minimal entry point");
        assert_eq!(&object[..4], b"\x7fELF");
        assert_eq!(object[4], 2, "ELFCLASS64");
    }
}
