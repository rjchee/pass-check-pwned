# pass-check-pwned
A [pass](https://www.passwordstore.org) extension to check your passwords against the [Pwned Passwords API](https://haveibeenpwned.com/Passwords).

## pass check
`pass check <password-name>` will check if the password stored in the file has ever been pwned before. If it is, the command will print how many times that password has been pwned. This script uses the Pwned Password API's k-anonymity model to check passwords, so it will only ever send the first 5 characters of your passwords' SHA-1 hash over the network.

```
Usage: pass check [--help,-h] [--version] [--line=line-number,-l line-number] [--short-output,-s] [--verbose,-v] pass-names
```

## Examples
If your password has been pwned before, you'll see something like this.
```
pass check my-bad-password
my-bad-password has been pwned 3303003 time(s).
```

Otherwise, it will print
```
pass check my-good-password
No pwned passwords found.
```

Multiple password names can be passed in at once.
```
pass check my-bad-password my-good-password
my-bad-password has been pwned 3303003 time(s).
```

`pass check` without any arguments will check every password in your store. Depending on how many passwords you have, it may take a while to check all of them.

By default, `pass check` will check only the first line of your password files against the Pwned Passwords API. If you use multiline password files, and you want to check if a password on a different line has been pwned, you can use the `--line` flag to specify the line number you want to check. Line numbers are 1-indexed.

The `--short-output` flag will make `pass-check` output pwned passwords in the format `<password-name>:<count>`, where `password-name` is the name of the password in the password store and `count` is the number of times it's been pwned in the API.
```
pass check --short-output my-bad-password
my-bad-password:3303003
```

## Installation
1. Add `src/check.sh` to `~/.password-store/.extensions/`.
2. Set `PASSWORD_STORE_ENABLE_EXTENSIONS=true` to allow extensions to be run from the `.extensions` directory.
3. If you want tab completion for `pass check`, you can edit `pass`'s completion file to contain the case in `src/bash-completion-snippet`. For bash on Ubuntu 16.04, this might be located in `/usr/share/bash-completion/completions/pass`.

## Contributing
Feel free to make an issue or a pull request if you would like to see anything changed.
