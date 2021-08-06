# cl-server

## Goal

Elisp has `emacsclient --eval`, clojure has `babashka`, and 
common lisp will have `cl-server`.

``` shell
# MERELY GOALS - NOT READY TO USE YET.

# cl-server ::
$ echo "0 1 2 3 4" | cls '(nth 2 *input*)' 
2
$ ls | cls '(take 2 *input*)'
("CHANGES.md" "Dockerfile")
$ ls | cls '(filter #\'directory? *input*)'
("doc" "resources" "sci" "script" "src" "target" "test")

# Babashka ::
$ ls | bb -i '(filter #(-> % io/file .isDirectory) *input*)'
("doc" "resources" "sci" "script" "src" "target" "test")
bb took 4ms.
$ ls | bb -i '(take 2 *input*)'
("CHANGES.md" "Dockerfile")
$ bb '(vec (dedupe *input*))' <<< '[1 1 1 1 2]'
[1 2]
```

## Reference

+ [A related
  discussion](https://www.reddit.com/r/Common_Lisp/comments/owgrie/ways_to_talk_to_a_lisp_repl_a_brief_survey/)
+ [Babashka](https://github.com/babashka/babashka)
+ [Emacsclient](https://www.emacswiki.org/emacs/EmacsClient)
