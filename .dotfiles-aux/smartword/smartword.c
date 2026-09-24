/* smartword: adds a `smart-word-rubout` readline command.
 * Like unix-word-rubout, but words are also split at shell punctuation.
 * Each press kills one word plus any separators after it, so
 * `cmd $(subcmd some/file` goes: file, some/, subcmd , $(, cmd .
 * Killed text goes to the kill ring.
 *
 * Two ways to load it:
 *  - bash:       enable -f /path/to/smartword.so smartword
 *  - any program: LD_PRELOAD=/path/to/smartword.so
 * then bind it in ~/.inputrc:  "\C-w": smart-word-rubout
 * Loading it also sets bind-tty-special-chars off (see smartword_register).
 *
 * No readline symbols are linked directly: they are looked up at runtime, so
 * loading this into a program without readline is a no-op. The command is
 * registered from the constructor (readline already loaded, e.g. bash) and
 * from an rl_initialize wrapper (readline dlopen'ed later with RTLD_LOCAL,
 * e.g. Python's readline module). Built with -z nodelete, since readline
 * keeps a pointer to smart_word_rubout for as long as the process runs. */
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stddef.h>
#include <string.h>

typedef int rl_command_func_t(int, int);

static const char *DELIMS = " \t\n()|;&<>=`\"'/";

static struct {
  int *point;
  char **line_buffer;
  int (*kill_text)(int, int);
  int (*add_defun)(const char *, rl_command_func_t *, int);
  int (*initialize)(void);
} rl;

static int registered;

static int smart_word_rubout(int count, int key) {
  (void)key;
  if (count <= 0) count = 1;
  const char *buf = *rl.line_buffer;
  int p = *rl.point;
  while (count-- > 0 && p > 0) {
    while (p > 0 && strchr(DELIMS, buf[p-1])) p--;    /* trailing separators */
    while (p > 0 && !strchr(DELIMS, buf[p-1])) p--;   /* the word before them */
  }
  int orig = *rl.point;
  *rl.point = p;
  rl.kill_text(orig, p);
  return 0;
}

/* Look in a locally-loaded libreadline too, which RTLD_DEFAULT/RTLD_NEXT
 * can't see. */
static void *rl_sym_in(void *scope, const char *name) {
  void *s = dlsym(scope, name);
  if (s) return s;
  void *h = dlopen("libreadline.so.8", RTLD_LAZY | RTLD_NOLOAD);
  return h ? dlsym(h, name) : NULL;
}

static void smartword_register(void) {
  if (registered) return;  /* readline() calls rl_initialize on every line */
  rl.point = rl_sym_in(RTLD_DEFAULT, "rl_point");
  rl.line_buffer = rl_sym_in(RTLD_DEFAULT, "rl_line_buffer");
  rl.kill_text = rl_sym_in(RTLD_DEFAULT, "rl_kill_text");
  rl.add_defun = rl_sym_in(RTLD_DEFAULT, "rl_add_defun");
  if (rl.point && rl.line_buffer && rl.kill_text && rl.add_defun)
    registered = !rl.add_defun("smart-word-rubout", smart_word_rubout, -1);
  /* Otherwise the tty's werase char (^W) overrides the inputrc binding.
   * Done here rather than in inputrc so that an inputrc binding to
   * smart-word-rubout degrades to the default ^W when this isn't loaded. */
  int (*variable_bind)(const char *, const char *) =
      rl_sym_in(RTLD_DEFAULT, "rl_variable_bind");
  if (registered && variable_bind)
    variable_bind("bind-tty-special-chars", "off");
}

__attribute__((constructor)) static void init(void) { smartword_register(); }

/* Only interposes when LD_PRELOADed. RTLD_NEXT, not RTLD_DEFAULT, which
 * would find this function again. */
int rl_initialize(void) {
  if (!rl.initialize) rl.initialize = rl_sym_in(RTLD_NEXT, "rl_initialize");
  smartword_register();
  return rl.initialize ? rl.initialize() : 0;
}

/* Bash loadable builtin, so `enable -f` accepts the file. Declared by hand
 * to avoid needing bash's headers; the layout has been stable since bash 2. */
typedef struct word_list WORD_LIST;
struct builtin {
  char *name;
  int (*function)(WORD_LIST *);
  int flags;
  char *const *long_doc;
  const char *short_doc;
  char *handle;
};

static int smartword_builtin(WORD_LIST *list) {
  (void)list;
  return registered ? 0 : 1;
}

static char *const smartword_doc[] = {
  "Adds the smart-word-rubout readline command.",
  "",
  "Loading this builtin is what matters; running it just reports",
  "whether the command was registered (exit status 0) or not (1).",
  NULL
};

struct builtin smartword_struct = {
  "smartword", smartword_builtin, 0x01 /* BUILTIN_ENABLED */,
  smartword_doc, "smartword", NULL
};
