# Linux envsubst Command with Examples

## 1. Overview

In many cases, template, configuration, or initialization files  **keep the names of bash variables as placeholders** .
Thus, **we need to fill in the variables’ values before actual use.**
We’re going to learn how to do just that with the [*envsubst*](https://man7.org/linux/man-pages/man1/envsubst.1.html) command.

## 2. Basic Features of *envsubst*

The *envsubst* command searches the input for pattern *$VARIABLE *or  *${VARIABLE}* . **Then, it replaces the pattern with the value of the corresponding bash variable.**
In contrast, a pattern that does not refer to any variable is replaced by an empty string.
Moreover,  ***envsubst* recognizes only [exported variables](https://www.baeldung.com/linux/bash-variables-export)** *.*
The command is a part of the GNU ‘gettext’ package. Its basic syntax is:

```sh
envsubst [OPTION] [SHELL-FORMAT]
```

## 3. Examples of Use

Let’s prepare a simple greetings template in the file *welcome.txt*. We’re going to address the user with the name, add the desktop session’s name, and end up with a specific greeting:

```sh
Hello user $USER in $DESKTOP_SESSION. It's time to say $HELLO!
```

Let’s export the HELLO variable:

```sh
$ export HELLO="good morning"
$ envsubst < welcome.txt
Hello user joe in Lubuntu. It's time to say good morning!
```

And now, let’s unset this variable:

```sh
$ unset HELLO
$ envsubst < welcome.txt
Hello user joe in Lubuntu. It's time to say !
```

## 4. Specify Variables with SHELL-FORMAT

**The *SHELL-FORMAT* argument selects variables for substitution.**
That is, only variables mentioned in this argument will be replaced. **All other variables and all other words containing the dollar sign remain untouched.**
The variable pattern is the same as with the command input – *$VARIABLE *or  *${VARIABLE}* .
Let’s give it a check on the *shell_format_test.txt* input file:

```bash
This is $FOO and this $BAR
```

Also, let’s set and export two variables, *FOO* and  *BAR* :
```bash
$ export FOO=foo export BAR=bar
```

Now, we’re going to replace only  *FOO* :
```bash
$ envsubst '$FOO' < shell_format_test.txt
This is foo and this $BAR
```
We should use apostrophes around the content of *SHELL-FORMAT*  **to prevent variable substitution before the call to *envsubst*** .

## 5. The Format of *SHELL-FORMAT*

Let’s note that the structure of *SHELL-FORMAT* is very flexible. For example, variables may form a delimited list:
```bash
$ envsubst '$FOO,$BAR' < shell_format_test.txt
This is foo and this bar
```
Or, they can be a part of any text:
```bash
$ envsubst 'Please deal with $FOO and $BAR'< shell_format_test.txt
This is foo and this bar
```
The variable pattern must contain only alphanumeric ASCII characters and underscores and may not start with a digit.

## 6. Substituting All Environment Variables

As an example,  **let’s replace all environment variables found in our *welcome.txt* template file** :
```bash
$ envsubst "$(printf '${%s} ' $(env | cut -d'=' -f1))" < welcome.txt
Hello user joe in Lubuntu. It's time to say $HELLO!
```

Now, let’s analyze the *SHELL-FORMAT* argument.
First, the [*env*](https://man7.org/linux/man-pages/man1/env.1p.html) command provides a list of variables and their values in pairs. Then, we [*cut*](https://man7.org/linux/man-pages/man1/cut.1.html) each pair and extract the variable’s name.
Finally, [*printf*](https://man7.org/linux/man-pages/man1/printf.1.html) puts this name into curly braces and adds a leading dollar sign.

## 7. Listing the Content of *SHELL-FORMAT*

Let’s use a *-v* or *–variables* switch to print all variables present in the *SHELL-FORMAT* argument. **With this option, no actual substitution takes place.**
So, let’s print names of all environment variables in a rather fancy way (with the help of *[xargs](https://man7.org/linux/man-pages/man1/xargs.1.html)* and [*column*](https://man7.org/linux/man-pages/man1/column.1.html)):

```bash
$ envsubst "$(printf '${%s} ' $(env | cut -d'=' -f1))" --variables | xargs -L4 | column -t
XDG_VTNR               LC_PAPER                  LC_ADDRESS           XDG_SESSION_ID
XDG_GREETER_DATA_DIR   SELINUX_INIT              LC_MONETARY          SAL_USE_VCLPLUGIN
CLUTTER_IM_MODULE      SESSION                   GPG_AGENT_INFO       TERM
```

## 8. Conclusion

In this article, we looked through some of the details of the *envsubst* command. Furthermore, we studied examples of its use.
Finally, we showed how to use *envsubst* to replace all referenced environment variables in a text file with their corresponding values from the shell environment.
