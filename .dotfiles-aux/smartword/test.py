"""Drives real interactive readline sessions through a pty.

Usage: python3 test.py   (needs bash, and python3 with its readline module)
"""
import os, pty, re, sys, tempfile, time

HERE = os.path.dirname(os.path.abspath(__file__))
SO = os.path.join(HERE, "smartword.so")
LINE = "cmd $(subcmd some/file"
EXPECTED = ["cmd $(subcmd some/file", "cmd $(subcmd some/", "cmd $(subcmd ",
            "cmd $(", "cmd ", ""]

tmp = tempfile.mkdtemp()
INPUTRC = os.path.join(tmp, "inputrc")
with open(INPUTRC, "w") as f:
    f.write('"\\C-w": smart-word-rubout\n')
BASHRC = os.path.join(tmp, "bashrc")
with open(BASHRC, "w") as f:
    f.write(f"enable -f {SO} smartword\nPS1='$ '\n")


def session(argv, keys, env=None):
    env = dict(os.environ, INPUTRC=INPUTRC, PS1="$ ", **(env or {}))
    pid, fd = pty.fork()
    if pid == 0:
        os.execvpe(argv[0], argv, env)
    time.sleep(3)  # readline discards keys typed before it's ready
    for k in keys:
        os.write(fd, k.encode()); time.sleep(0.4)
    out = b""
    while True:
        try: d = os.read(fd, 4096)
        except OSError: break
        if not d: break
        out += d
    os.waitpid(pid, 0)
    out = re.sub(r"\x1b\[[?0-9;]*[a-zA-Z]", "", out.decode(errors="replace"))
    return out.replace("\r", "")


def bash_sequence(argv, env=None):
    """Ctrl-W 0..5 times, then 5 times + Ctrl-Y; returns what was left."""
    keys = [LINE + "\x17" * k + "\x01printf '[%s]\\n' '\x05'\r" for k in range(6)]
    keys.append(LINE + "\x17" * 5 + "\x19\x01printf '[%s]\\n' '\x05'\r")
    out = session(argv, keys + ["exit\r"], env)
    return re.findall(r"^\[(.*)\]$", out, re.M)


failed = 0
def check(name, got, want):
    global failed
    ok = got == want
    failed += not ok
    print(f"{'ok  ' if ok else 'FAIL'} {name}" + ("" if ok else f"\n     got  {got!r}\n     want {want!r}"))


check("bash, enable -f", bash_sequence(["bash", "--rcfile", BASHRC, "-i"]), EXPECTED + [LINE])
check("bash, LD_PRELOAD", bash_sequence(["bash", "--norc", "-i"], {"LD_PRELOAD": SO}), EXPECTED + [LINE])
check("bash, not loaded (plain unix-word-rubout)",
      bash_sequence(["bash", "--norc", "-i"])[:3], [LINE, "cmd $(subcmd ", "cmd "])

out = session([sys.executable, "-q"], ['print(len("ab(cd\x17x"))\r', "exit()\r"],
              {"LD_PRELOAD": SO, "PYTHON_BASIC_REPL": "1"})
check("python REPL, LD_PRELOAD", re.findall(r"^(\d+)$", out, re.M), ["4"])

out = session(["bash", "--norc", "-i"], [f"enable -f {SO} smartword; enable -d smartword; echo a b\x17x\r", "exit\r"])
check("bash survives enable -d", re.findall(r"^(a x)$", out, re.M), ["a x"])

sys.exit(failed)
