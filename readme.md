# cl-server

## Goal

Aim to become what `emacsclient --eval` is for elisp and what
`babashka` is for clojure for common lisp.

``` shell
# cl-server ::
$ echo "0 1 2 3 4" | cls "(nth 2 (magic-transform *input*))" 
2
$ ls | cls "(filter #'directory? *input*)"
("doc" "resources" "sci" "script" "src" "target" "test")

# Babashka ::
$ ls | bb -i '(filter #(-> % io/file .isDirectory) *input*)'
("doc" "resources" "sci" "script" "src" "target" "test")
bb took 4ms.
```

## Reference

+ [Babashka](https://github.com/babashka/babashka)
+ [Emacsclient](https://www.emacswiki.org/emacs/EmacsClient)
