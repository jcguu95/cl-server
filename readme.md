# cl-server

## Goal

Elisp has `emacsclient --eval`, clojure has `babashka`, and 
common lisp will have `cl-server`.

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

+ [A related
  discussion](https://www.reddit.com/r/Common_Lisp/comments/owgrie/ways_to_talk_to_a_lisp_repl_a_brief_survey/)
+ [Babashka](https://github.com/babashka/babashka)
+ [Emacsclient](https://www.emacswiki.org/emacs/EmacsClient)
