# VariFS

VariFS is an userspace variable resolving file system, that mounts over a directory and resolves user defined `«variable»`s during file read.

_Sorry, the code looks horrible, i just wanted this thing quick :P_

## Example

First we have some variables:

```
$ cat .varifs
foo = bar
color = #ff8800
timezone = Europe/Berlin
```

And some optional "secret" variables (so we can omit this from VCS):

```
$ cat .varifs.secret
password = secret
```

Then we can reference those variables in file content:

```
$ cat testfile
hello «foo»
what = «color|start:1»
ever = «color|hex2rgb»
pass = «password»
```

And in symlink target:

```
$ file testlink
testlink: broken symbolic link to /usr/share/zoneinfo/«timezone»
```

Now when we mount over that directory:

```
$ mkdir -p "/tmp/varifstest"
$ ../varifs "/tmp/varifstest" -o root="$PWD"
```

Those variables are resolved during file read:

```
$ cat "/tmp/varifstest/testfile"
hello bar
what = ff8800
ever = 255,136,0
pass = secret
$ file "/tmp/varifstest/testlink"
/tmp/varifstest/testlink: symbolic link to /usr/share/zoneinfo/Europe/Berlin
```

When done, just unmount:

```
$ fusermount -u "/tmp/varifstest"
```

## Dependencies

- [Python 3](https://www.python.org)
- [python-fuse](https://www.python.org)

## Usage

```
$ varifs <WHERE_TO_MOUNT> -o root=<WHAT_TO_MOUNT>
$ fusermount -u <WHERE_TO_MOUNT>
```

## Environment variables

| Variable | Information |
|----------|-------------|
| `VARIFS_VARIFILE` | Variable filename, default: ".varifs" |
| `VARIFS_SECRETFILE` | Secret variable filename, default: ".varifs.secret" |
| `VARIFS_PREFIX` | Variable reference prefix, default: "«" |
| `VARIFS_SUFFIX` | Variabel reference suffix, default: "»" |
| `VARIFS_MODSEP` | Variable modification separator, default: "\|" |
| `VARIFS_MODARGSEP` | Variable modification argument separator, default ":" |

## Variable mods

We can modify variable values when referecing them, the syntax is:

```
«variable|mod:args»
```

| Mod | Arg(s) | Info |
|-----|--------|------|
| `start` | number | Remove number chars from start |
| `mul` | number | Multiply by number |
| `add` | number | Add number |
| `hex2rgb` | - | Convert hexadecimal color to RGB bytes |

## Ideas

- There has to be such project already? please let me know!
  - If not, rewrite in C, or something faster
- Check for tips in https://gwolf.org/2024/10/started-a-guide-to-writing-fuse-filesystems-in-python.html
- Print warning if a variable is not defined/used (but print where?)
- Variables in paths
  - Symlink target path can already have variables
- Option/ENVAR for varifile location?

## Licence

[MIT](meta/license)
